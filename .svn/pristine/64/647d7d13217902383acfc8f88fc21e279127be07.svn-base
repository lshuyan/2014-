//
//  SyncHelper.m
//  ChinaBrowser
//
//  Created by David on 14/12/19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "SyncHelper.h"

#import "ModelHistory.h"
#import "ModelBookmark.h"
#import "ModelMode.h"
#import "ModelModeProgram.h"
#import "ModelUserSettings.h"
#import "ModelSyncDelete.h"

#import "ADOUserSettings.h"
#import "ADOBookmark.h"
#import "ADOHistory.h"
#import "ADOMode.h"
#import "ADOModeProgram.h"
#import "ADOSyncDelete.h"

#import <AGCommon/UIDevice+Common.h>


NSString * const kNotificationDidSync = @"kNotificationDidSync";

/**
 *  同步子操作
 */
typedef struct {
    BOOL delete;
    BOOL get;
    BOOL add;
    BOOL update;
    BOOL clear;
} SyncSubOperation;

/**
 *  同步操作
 */
typedef struct {
    SyncSubOperation userSettings;
    SyncSubOperation history;
    SyncSubOperation bookmark;
    SyncSubOperation mode;
    SyncSubOperation modeProgram;
} SyncOperation;

static SyncHelper *_syncHelper;

@interface SyncHelper ()

@property (nonatomic, assign, readonly) NSInteger userId;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) ModelUserSettings *userSettings;

@end

@implementation SyncHelper
{
    AFHTTPClient *_afClient;
    /**
     *  是否正在同步的依据，就靠它，操作此结构体请慎重！！！【*****很重要】
     */
    SyncOperation _syncOperation;
}

+ (instancetype)shareSync
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _syncHelper = [[SyncHelper alloc] init];
    });
    return _syncHelper;
}

/**
 *  根据当前用户设置和网络环境，检查是否可以自动同步
 *
 *  @return BOOL 是否自动同步
 */
+ (BOOL)shouldAutoSync
{
    BOOL bFlag = NO;
    if (![UserManager shareUserManager].currUser) {
        return bFlag;
    }
    
    CMNetworkType netType = [[UIDevice currentDevice] currentNetworkType];
    switch ([UserManager shareUserManager].currUser.settings.syncStyle) {
        case SyncStyleWiFi:
        {
            if (CMNetworkTypeWifi==netType) {
                bFlag = YES;
            }
        }break;
        case SyncStyleAuto:
        {
            bFlag = YES;
        }break;
        case SyncStyleManual:
        {
            bFlag = NO;
        }break;
        default:
            break;
    }
    return bFlag;
}

/**
 *  是否允许同步某种数据类型
 *
 *  @param syncDataType 同步的数据类型
 *
 *  @return BOOL
 */
+ (BOOL)shouldSyncWithType:(SyncDataType)syncDataType
{
    BOOL flag = NO;
    switch (syncDataType) {
        case SyncDataTypeHistory:
        {
            flag = [UserManager shareUserManager].currUser.settings.syncLastVisit;
        }break;
        case SyncDataTypeBookmark:
        {
            flag = [UserManager shareUserManager].currUser.settings.syncBookmark;
        }break;
        case SyncDataTypeMode:
        case SyncDataTypeModeProgram:
        case SyncDataTypeReminder:
        {
            flag = [UserManager shareUserManager].currUser.settings.syncReminder;
        }break;
        case SyncDataTypeAll:
        {
            flag = YES;
        }break;
        default:
            break;
    }
    return flag;
}

#pragma mark - private methods
- (NSInteger)userId
{
    return [UserManager shareUserManager].currUser.uid;
}

- (NSString *)token
{
    return [UserManager shareUserManager].currUser.token;
}

- (ModelUserSettings *)userSettings
{
    return [UserManager shareUserManager].currUser.settings;
}

/**
 *  是否正在同步
 *
 *  @return BOOL
 */
- (BOOL)isSyncing
{
    BOOL retVal = NO;
    void *pOperation = &_syncOperation;
    NSInteger perSize = sizeof(BOOL);
    NSInteger count = sizeof(_syncOperation)/perSize;
    for (NSInteger i=0; i<count; i++) {
        BOOL b = NO;
        memcpy(&b, pOperation+perSize*i, perSize);
        retVal|=b;
    }
    return retVal;
}

/**
 *  某个数据类型是否正在同步
 *
 *  @param syncSubOperation 同步操作
 *
 *  @return BOOL 是否同步
 */
- (BOOL)isSyncingWithSyncSubOperation:(SyncSubOperation)syncSubOperation
{
    BOOL retVal = NO;
    void *pOperation = &syncSubOperation;
    NSInteger perSize = sizeof(BOOL);
    NSInteger count = sizeof(syncSubOperation)/perSize;
    for (NSInteger i=0; i<count; i++) {
        BOOL b = NO;
        memcpy(&b, pOperation+perSize*i, perSize);
        retVal|=b;
    }
    return retVal;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _afClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:GetApiBaseUrl()]];
        // 初始化同步操作结构体，置0
        memset(&_syncOperation, 0, sizeof(_syncOperation));
    }
    return self;
}

#pragma mark - 同步所有需要同步的数据
// --------------------- 批处理 delete=>get=>merge=>add/update
/**
 *  根据用户设置同步所有能同步的数据
 *
 *  @param completion completion description
 *  @param fail       fail description
 *  @param syncDataTypeCompletion       syncDataTypeCompletion description
 */
- (void)syncAllIfNeededWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail syncDataTypeCompletion:(SyncDataTypeCompletion)syncDataTypeCompletion
{
    if ([self isSyncing]) return;
    
    [self syncUserSettingsWithCompletion:^{
        if (syncDataTypeCompletion) {
            syncDataTypeCompletion(SyncDataTypeUserSettings);
        }
        
        // 需要同步的数据类型
        __block NSInteger syncDataTypeCount
        =(NSInteger)[UserManager shareUserManager].currUser.settings.syncBookmark
        +(NSInteger)[UserManager shareUserManager].currUser.settings.syncLastVisit
        +(NSInteger)[UserManager shareUserManager].currUser.settings.syncReminder;
        __block BOOL successed = NO;
        void (^compltionIfNeeded)()=^{
            syncDataTypeCount--;
            successed = YES;
            if (syncDataTypeCount==0) {
                if (completion) completion();
                [UserManager shareUserManager].currUser.syncTime = [[NSDate date] timeIntervalSince1970];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidSync object:nil];
            }
        };
        
        void (^failIfNeeded)(NSError *)=^(NSError *error){
            syncDataTypeCount--;
            if (syncDataTypeCount==0) {
                [UserManager shareUserManager].currUser.syncTime = [[NSDate date] timeIntervalSince1970];
                if (successed) {
                    if (completion) completion();
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidSync object:nil];
                }
                else {
                    if (fail) fail(error);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidSync object:nil];
                }
            }
        };
        
        if ([UserManager shareUserManager].currUser.settings.syncLastVisit) {
            // 最近访问
            [self syncHistoryWithCompletion:^{
                compltionIfNeeded();
                if (syncDataTypeCompletion) {
                    syncDataTypeCompletion(SyncDataTypeHistory);
                }
            } fail:^(NSError *error) {
                failIfNeeded(error);
            }];
        }
        if ([UserManager shareUserManager].currUser.settings.syncBookmark) {
            // 书签
            [self syncBookmarkWithCompletion:^{
                compltionIfNeeded();
                if (syncDataTypeCompletion) {
                    syncDataTypeCompletion(SyncDataTypeBookmark);
                }
            } fail:^(NSError *error) {
                failIfNeeded(error);
            }];
        }
        if ([UserManager shareUserManager].currUser.settings.syncReminder) {
            // 个性化定制
            [self syncReminderWithCompletion:^{
                compltionIfNeeded();
                if (syncDataTypeCompletion) {
                    syncDataTypeCompletion(SyncDataTypeReminder);
                }
            } fail:^(NSError *error) {
                failIfNeeded(error);
            }];
        }
        
        if (syncDataTypeCount==0) {
            if (completion) completion();
        }
    } fail:^(NSError *error) {
        if (fail) fail(error);
    }];
}

#pragma mark - 同步相关操作
// --------------------- 批处理 delete=>get=>merge=>add/update
/**
 *  同步用户设置
 *
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncUserSettingsWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if ([self isSyncingWithSyncSubOperation:_syncOperation.userSettings]) {
        if (fail) fail(nil);
        return;
    }
    
    [self syncGetUserSettingsWithCompletion:^{
        if ([UserManager shareUserManager].currUser.settings.updateTime>[UserManager shareUserManager].currUser.settings.updateTimeServer) {
            [self syncUpdateUserSetting:[UserManager shareUserManager].currUser.settings completion:^{
                if (completion) completion();
            } fail:^(NSError *error) {
                if (fail) fail(error);
            }];
        }
        else {
            if (completion) completion();
        }
    } fail:^(NSError *error) {
        if (fail) fail(error);
    }];
}

/**
 *  同步某种数据类型(SyncDataTypeModeProgram 除外)
 *
 *  @param type 同步的数据类型
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncDataType:(SyncDataType)type completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    switch (type) {
        case SyncDataTypeBookmark:
        {
            [self syncBookmarkWithCompletion:completion fail:fail];
        }break;
        case SyncDataTypeHistory:
        {
            [self syncHistoryWithCompletion:completion fail:fail];
        }break;
        case SyncDataTypeMode:
        {
            [self syncModeWithCompletion:completion fail:fail];
        }break;
        case SyncDataTypeReminder:
        {
            [self syncReminderWithCompletion:completion fail:fail];
        }break;
        case SyncDataTypeAll:
        {
            [self syncAllIfNeededWithCompletion:completion fail:fail syncDataTypeCompletion:nil];
        }break;
        default:
            break;
    }
}

/**
 *  同步最近浏览
    1、向服务器提交删除操作 delete
    2、从服务器上下载最新数据，添加到本地 get
    3、提交数据到服务器，按访问时间倒序查询最新的20条数据
        1）从20条数据中筛选出pkid_server>0 && update_time>update_time_server 的数据提交到服务器修改 update
        2）从20条数据中筛选出pkid_server=0的数据 提交到服务器 add
 *
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncHistoryWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if ([self isSyncingWithSyncSubOperation:_syncOperation.history]) {
        if (fail) fail(nil);
        return;
    }
    
    // 1、向服务器提交删除操作 delete
    NSArray *arrSyncDelete = [ADOSyncDelete queryWithSyncDataType:SyncDataTypeHistory userId:[self userId]];
    [self syncDeleteHistoryWithArrSyncDelete:arrSyncDelete completion:^{
        // 2、从服务器上下载最新数据，添加到本地 get
        [self syncGetHistoryWithCompletion:^{
            // 3、提交数据到服务器，按访问时间倒序查询最新的20条数据
            NSArray *arrAllLastHistory = [ADOHistory queryLastNumber:kLastVisitNumber withUserId:[self userId]];
            NSPredicate *predicateToAdd = [NSPredicate predicateWithFormat:@"self.pkid_server==0"];
            NSPredicate *predicateToUpdate = [NSPredicate predicateWithFormat:@"self.pkid_server>0 and self.updateTime>self.updateTimeServer"];
            NSArray *arrHistoryToAdd = [arrAllLastHistory filteredArrayUsingPredicate:predicateToAdd];
            NSArray *arrHistoryToUpdate = [arrAllLastHistory filteredArrayUsingPredicate:predicateToUpdate];
            
            __block SyncSubOperation syncSubOperation;
            memset(&syncSubOperation, 0, sizeof(syncSubOperation));
            
            if (arrHistoryToAdd.count>0) {
                syncSubOperation.add = YES;
                for (ModelHistory *modelHistory in arrHistoryToAdd) {
                    modelHistory.updateTimeServer = modelHistory.updateTime;
                }
            }
            if (arrHistoryToUpdate.count>0) {
                syncSubOperation.update = YES;
                for (ModelHistory *modelHistory in arrHistoryToUpdate) {
                    modelHistory.updateTimeServer = modelHistory.updateTime;
                }
            }
            
            if (syncSubOperation.add) {
                // Add，将服务器最后的更新时间，设置为本地最后更新的时间
                [self syncAddArrHistory:arrHistoryToAdd completion:^{
                    syncSubOperation.add = NO;
                    if (!syncSubOperation.update && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.add = NO;
                    if (!syncSubOperation.update && fail) fail(error);
                }];
            }
            
            if (syncSubOperation.update) {
                // Update，将服务器器最后的更新时间，修改为本地最后更新的时间
                [self syncUpdateArrHistory:arrHistoryToUpdate async:NO completion:^{
                    syncSubOperation.update = NO;
                    if (!syncSubOperation.add && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.update = NO;
                    if (!syncSubOperation.add && fail) fail(error);
                }];
            }
            
            if (!(syncSubOperation.add || syncSubOperation.update)) {
                if (completion) completion();
            }
            
        } fail:^(NSError *error) {
            if (fail) fail(error);
        }];
    } fail:^(NSError *error) {
        if (fail) fail(error);
    }];
}

/**
 *  同步书签
 *
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncBookmarkWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if ([self isSyncingWithSyncSubOperation:_syncOperation.bookmark]) {
        if (fail) fail(nil);
        return;
    }
    
    NSArray *arrSyncDelete = [ADOSyncDelete queryWithSyncDataType:SyncDataTypeBookmark userId:[self userId]];
    [self syncDeleteBookmarkWithArrSyncDelete:arrSyncDelete completion:^{
        [self syncGetBookmarkWithCompletion:^{
            NSArray *arrBookmarkToAdd = [ADOBookmark queryWillAddWithUserId:[self userId]];
            NSArray *arrBookmarkToUpdate = [ADOBookmark queryWillUpdateWithUserId:[self userId]];
            
            __block SyncSubOperation syncSubOperation;
            memset(&syncSubOperation, 0, sizeof(syncSubOperation));
            
            if (arrBookmarkToAdd.count>0) syncSubOperation.add = YES;
            if (arrBookmarkToUpdate.count>0) syncSubOperation.update = YES;
            
            if (syncSubOperation.add) {
                [self syncAddArrBookmark:arrBookmarkToAdd completion:^{
                    syncSubOperation.add = NO;
                    if (!syncSubOperation.update && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.add = NO;
                    if (!syncSubOperation.update && fail) fail(error);
                }];
            }
            
            if (syncSubOperation.update) {
                [self syncUpdateArrBookmark:arrBookmarkToUpdate completion:^{
                    syncSubOperation.update = NO;
                    if (!syncSubOperation.add && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.update = NO;
                    if (!syncSubOperation.add && fail) fail(error);
                }];
            }
            
            if (!(syncSubOperation.add||syncSubOperation.update)) {
                if (completion) completion();
            }
        } fail:^(NSError *error) {
            if (fail) fail(error);
        }];
    } fail:^(NSError *error) {
        if (fail) fail(error);
    }];
}

/**
 *  同步定制提醒(个性化定制)
 *
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncReminderWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    [self syncModeWithCompletion:^{
        NSArray *arrMode = [ADOMode queryWithUserId:[self userId] sysRecommend:NO];
        NSMutableArray *arrModePkidServer = [NSMutableArray array];
        for (ModelMode *mode in arrMode) {
            [arrModePkidServer addObject:@(mode.pkid_server)];
        }
        [self syncModeProgramWithArrModePkidServer:arrModePkidServer completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationDidSyncReminder object:nil];
            
            if (completion) completion();
        } fail:^(NSError *error) {
            if (fail) fail(error);
        }];
    } fail:^(NSError *error) {
        if (fail) fail(error);
    }];
}

- (void)syncModeWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if ([self isSyncingWithSyncSubOperation:_syncOperation.mode]) {
        if (fail) fail(nil);
        return;
    }
    
    NSArray *arrSyncDelete = [ADOSyncDelete queryWithSyncDataType:SyncDataTypeMode userId:[self userId]];
    [self syncDeleteModeWithArrSyncDelete:arrSyncDelete completion:^{
        [self syncGetModeWithCompletion:^{
            NSArray *arrModeToAdd = [ADOMode queryWillAddWithUserId:[self userId]];
            NSArray *arrModeToUpdate = [ADOMode queryWillUpdateWithUserId:[self userId]];
            
            __block SyncSubOperation syncSubOperation;
            memset(&syncSubOperation, 0, sizeof(syncSubOperation));
            
            if (arrModeToAdd.count>0) syncSubOperation.add = YES;
            if (arrModeToUpdate.count>0) syncSubOperation.update = YES;
            
            if (syncSubOperation.add) {
                [self syncAddArrMode:arrModeToAdd completion:^{
                    syncSubOperation.add = NO;
                    if (!_syncOperation.mode.update && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.add = NO;
                    if (!_syncOperation.mode.update && fail) fail(error);
                }];
            }
            
            if (syncSubOperation.update) {
                [self syncUpdateArrMode:arrModeToUpdate completion:^{
                    syncSubOperation.update = NO;
                    if (!_syncOperation.mode.add && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.update = NO;
                    if (!_syncOperation.mode.add && fail) fail(error);
                }];
            }
            
            if (!(syncSubOperation.add||syncSubOperation.update)) {
                if (completion) completion();
            }
        } fail:^(NSError *error) {
            if (fail) fail(error);
        }];
    } fail:^(NSError *error) {
        if (fail) fail(error);
    }];
}

- (void)syncModeProgramWithArrModePkidServer:(NSArray *)arrModePkidServer completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if ([self isSyncingWithSyncSubOperation:_syncOperation.modeProgram]) {
        if (fail) fail(nil);
        return;
    }
    
    NSArray *arrSyncDelete = [ADOSyncDelete queryWithSyncDataType:SyncDataTypeModeProgram userId:[self userId]];
    [self syncDeleteModeProgramWithArrSyncDelete:arrSyncDelete completion:^{
        [self syncGetModeProgramWithArrModePkidServer:arrModePkidServer completion:^{
            NSMutableArray *arrModeProgramToAdd = [NSMutableArray array];
            NSMutableArray *arrModeProgramToUpdate = [NSMutableArray array];
            
            for (NSNumber *modePkidServer in arrModePkidServer) {
                [arrModeProgramToAdd addObjectsFromArray:[ADOModeProgram queryWillAddWithModePkidServer:[modePkidServer integerValue]]];
                [arrModeProgramToUpdate addObjectsFromArray:[ADOModeProgram queryWillUpdateWithModePkidServer:[modePkidServer integerValue]]];
            }
            
            __block SyncSubOperation syncSubOperation;
            memset(&syncSubOperation, 0, sizeof(syncSubOperation));
            
            if (arrModeProgramToAdd.count>0) syncSubOperation.add = YES;
            if (arrModeProgramToUpdate.count>0) syncSubOperation.update = YES;
            
            if (syncSubOperation.add) {
                [self syncAddArrModeProgram:arrModeProgramToAdd completion:^{
                    syncSubOperation.add = NO;
                    if (!syncSubOperation.update && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.add = NO;
                    if (!syncSubOperation.update && fail) fail(error);
                }];
            }
            
            if (syncSubOperation.update) {
                [self syncUpdateArrModeProgram:arrModeProgramToUpdate completion:^{
                    syncSubOperation.update = NO;
                    if (!syncSubOperation.add && completion) completion();
                } fail:^(NSError *error) {
                    syncSubOperation.update = NO;
                    if (!syncSubOperation.add && fail) fail(error);
                }];
            }
            
            if (!(syncSubOperation.add||syncSubOperation.update)) {
                if (completion) completion();
            }
            
        } fail:^(NSError *error) {
            if (fail) fail(error);
        }];
    } fail:^(NSError *error) {
        if (fail) fail(error);
    }];
}

#pragma mark - 同步操作 删除 批处理同步 delete【成功之后再删除本地数据库 **** 很重要】
// --------------------- 批处理同步 delete【成功之后再删除本地数据库 **** 很重要】
/**
 *  删除服务器上的 历史记录（最近浏览）
 *
 *  @param arrSyncDelete 需要同步的删除项
 *  @param completion    completion description
 *  @param fail          fail description
 */
- (void)syncDeleteHistoryWithArrSyncDelete:(NSArray *)arrSyncDelete completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.history.delete) {
        if (fail) fail(nil);
        return;
    }
    
    if (0==arrSyncDelete.count) {
        _syncOperation.history.delete = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.history.delete = YES;
    
    NSMutableArray *arrDictPKidServer = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
    for (ModelSyncDelete *model in arrSyncDelete) {
        [arrDictPKidServer addObject:@{@"pkid":@(model.pkid_server)}];
    }
    NSString *jsonPkidServer = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictPKidServer options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"history":jsonPkidServer};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_DeleteUserHistory parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.history.delete = NO;
        /**
         *  即将删除的pkid
         */
        NSMutableArray *arrPkidWillDelete = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
        for (ModelSyncDelete *model in arrSyncDelete) {
            [arrPkidWillDelete addObject:@(model.pkid)];
        }
        [ADOSyncDelete deleteWithArrPkid:arrPkidWillDelete];
        
        if (completion) completion();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.history.delete = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  删除服务器上的 书签(文件夹)
 *
 *  @param arrSyncDelete 需要同步的删除项
 *  @param completion    completion description
 *  @param fail          fail description
 */
- (void)syncDeleteBookmarkWithArrSyncDelete:(NSArray *)arrSyncDelete completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.bookmark.delete) {
        if (fail) fail(nil);
        return;
    }
    
    if (0==arrSyncDelete.count) {
        _syncOperation.bookmark.delete = NO;
        completion();
        return;
    }
    
    _syncOperation.bookmark.delete = YES;
    
    NSMutableArray *arrDictPKidServer = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
    for (ModelSyncDelete *model in arrSyncDelete) {
        [arrDictPKidServer addObject:@{@"pkid":@(model.pkid_server)}];
    }
    NSString *jsonPkidServer = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictPKidServer options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"bookmark":jsonPkidServer};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_DeleteUserBookmark parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.bookmark.delete = NO;
        /**
         *  即将删除的pkid
         */
        NSMutableArray *arrPkidWillDelete = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
        for (ModelSyncDelete *model in arrSyncDelete) {
            [arrPkidWillDelete addObject:@(model.pkid)];
        }
        [ADOSyncDelete deleteWithArrPkid:arrPkidWillDelete];
        
        if (completion) completion();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.bookmark.delete = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  删除服务器上的定制 模式，同时删除该 模式 下的所有节目
 *
 *  @param arrSyncDelete 需要同步的删除项
 *  @param completion    completion description
 *  @param fail          fail description
 */
- (void)syncDeleteModeWithArrSyncDelete:(NSArray *)arrSyncDelete completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.mode.delete) {
        if (fail) fail(nil);
        return;
    }
    
    if (0==arrSyncDelete.count) {
        _syncOperation.mode.delete = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.mode.delete = YES;
    
    NSMutableArray *arrDictPKidServer = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
    for (ModelSyncDelete *model in arrSyncDelete) {
        [arrDictPKidServer addObject:@{@"pkid":@(model.pkid_server)}];
    }
    NSString *jsonPkidServer = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictPKidServer options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"mode":jsonPkidServer};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_DeleteUserMode parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.mode.delete = NO;
        /**
         *  即将删除的pkid
         */
        NSMutableArray *arrPkidWillDelete = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
        for (ModelSyncDelete *model in arrSyncDelete) {
            [arrPkidWillDelete addObject:@(model.pkid)];
        }
        [ADOSyncDelete deleteWithArrPkid:arrPkidWillDelete];
        
        if (completion) completion();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.mode.delete = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  删除服务器上的 模式-节目
 *
 *  @param arrSyncDelete 需要同步的删除项
 *  @param completion    completion description
 *  @param fail          fail description
 */
- (void)syncDeleteModeProgramWithArrSyncDelete:(NSArray *)arrSyncDelete completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.modeProgram.delete) {
        if (fail) fail(nil);
        return;
    }
    
    if (0==arrSyncDelete.count) {
        _syncOperation.modeProgram.delete = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.modeProgram.delete = YES;
    
    NSMutableArray *arrDictPKidServer = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
    for (ModelSyncDelete *model in arrSyncDelete) {
        [arrDictPKidServer addObject:@{@"pkid":@(model.pkid_server)}];
    }
    NSString *jsonPkidServer = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictPKidServer options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"mode_program":jsonPkidServer};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_DeleteUserModeProgram parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.modeProgram.delete = NO;
        
        /**
         *  即将删除的pkid
         */
        NSMutableArray *arrPkidWillDelete = [NSMutableArray arrayWithCapacity:arrSyncDelete.count];
        for (ModelSyncDelete *model in arrSyncDelete) {
            [arrPkidWillDelete addObject:@(model.pkid)];
        }
        [ADOSyncDelete deleteWithArrPkid:arrPkidWillDelete];
        
        if (completion) completion();
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.modeProgram.delete = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

#pragma mark - 同步操作 get
// --------------------- 同步 get
/**
 *  下载用户设置
 *
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncGetUserSettingsWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.userSettings.get) {
        if (fail) fail(nil);
        return;
    }
    
    _syncOperation.userSettings.get = YES;
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token]};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_GetUserSettings parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.userSettings.get = NO;
        NSDictionary *dictResult = [self resovleJSON:JSON];
        if (dictResult) {
            ModelUserSettings *modelUserSettings= [ModelUserSettings modelWithDict:dictResult];
            // 比较更新时间，本地更新时间<服务器上的更新时间，则需要更新本地数据
            if ([UserManager shareUserManager].currUser.settings.updateTime<modelUserSettings.updateTimeServer) {
                modelUserSettings.updateTime = modelUserSettings.updateTimeServer;
                [UserManager shareUserManager].currUser.settings = modelUserSettings;
                [ADOUserSettings updateModel:modelUserSettings];
            }
            if (completion) completion([UserManager shareUserManager].currUser.settings);
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.userSettings.get = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  下载 历史记录
 *
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncGetHistoryWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.history.get) {
        if (fail) fail(nil);
        return;
    }
    
    _syncOperation.history.get = YES;
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"pagesize":@(kLastVisitNumber)};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_GetUserHistory  parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.history.get = NO;
        NSArray *arrDictHistory = [self resovleJSON:JSON];
        if (arrDictHistory) {
            NSMutableArray *arrPkidServer = [NSMutableArray arrayWithCapacity:arrDictHistory.count];
            if (arrDictHistory.count>0) {
                NSMutableArray *arrHistoryServer = [NSMutableArray arrayWithCapacity:arrDictHistory.count];
                //  最新的用户历史记录
                for (NSDictionary *dictHistory in arrDictHistory) {
                    ModelHistory *modelHistoryServer = [ModelHistory modelWithDict:dictHistory];
                    [arrHistoryServer addObject:modelHistoryServer];
                    [arrPkidServer addObject:@(modelHistoryServer.pkid_server)];
                    
                    /**
                     *  查询本地是否存在该链接的记录
                     */
                    ModelHistory *modelHistoryLocal = [ADOHistory queryWithPkidServer:modelHistoryServer.pkid_server userId:[self userId]];
                    ModelHistory *modelHistorySameLink = nil;
                    if (modelHistoryLocal) {
                        modelHistorySameLink = [ADOHistory queryWithLink:modelHistoryServer.link userId:[self userId] exceptPkid:modelHistoryLocal.pkid];
                        if (modelHistorySameLink) {
                            // 需要删除重复项
                            ModelHistory *modelTmp = modelHistorySameLink.updateTime>modelHistoryLocal.updateTime?modelHistorySameLink:modelHistoryLocal;
                            NSInteger willDeletePkid = modelHistorySameLink.updateTime>modelHistoryLocal.updateTime?modelHistoryLocal.pkid:modelHistorySameLink.pkid;
                            
                            // 删除 modelBookmarkLocal
                            [ADOHistory deleteWithPkid:willDeletePkid];
                            
                            if (modelTmp.updateTime<modelHistoryServer.updateTimeServer) {
                                modelHistoryServer.pkid = modelTmp.pkid;
                                modelHistoryServer.updateTime = modelHistoryServer.updateTimeServer;
                                [ADOHistory updateModel:modelHistoryServer];
                            }
                            else {
                                modelTmp.pkid_server = modelHistoryServer.pkid_server;
                                [ADOHistory updateModel:modelTmp];
                            }
                        }
                        else {
                            if (modelHistoryLocal.updateTime<modelHistoryServer.updateTimeServer) {
                                // 本地存在，并且服务器时间大于本地操作时间，则更新成服务器上的数据(数据合并)
                                modelHistoryServer.pkid = modelHistoryLocal.pkid;
                                modelHistoryServer.updateTime = modelHistoryServer.updateTimeServer;
                                
                                [ADOHistory updateModel:modelHistoryServer];
                            }
                        }
                    }
                    else {
                        modelHistorySameLink = [ADOHistory queryWithLink:modelHistoryServer.link userId:[self userId]];
                        if (modelHistorySameLink) {
                            if (modelHistorySameLink.updateTime<modelHistoryServer.updateTimeServer) {
                                modelHistoryServer.pkid = modelHistorySameLink.pkid;
                                modelHistoryServer.updateTime = modelHistoryServer.updateTimeServer;
                                [ADOHistory updateModel:modelHistoryServer];
                            }
                            else {
                                modelHistorySameLink.pkid_server = modelHistoryServer.pkid_server;
                                [ADOHistory updateModel:modelHistorySameLink];
                            }
                        }
                        else {
                            // 本地不存在，新增服务器数据，同步下来的新数据
                            modelHistoryServer.updateTime = modelHistoryServer.updateTimeServer;
                            modelHistoryServer.pkid = [ADOHistory addModel:modelHistoryServer];
                        }
                    }
                }
            }
            
            // 删除pkid_server>0 && pkid_server not in arrPkidServer
            [ADOHistory deleteWithArrPkidServer:arrPkidServer userId:[self userId]];
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.history.get = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  从服务器上获取最新的 用户 书签数据，服务器的数据排序一定是 order by update_time asc，否则可能出现数据 混乱错误
 *
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncGetBookmarkWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.bookmark.get) {
        if (fail) fail(nil);
        return;
    }
    
    _syncOperation.bookmark.get = YES;
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"pagesize":@(NSIntegerMax)};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_GetUserBookmark  parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.bookmark.get = NO;
        NSArray *arrDictBookmark = [self resovleJSON:JSON];
        if (arrDictBookmark) {
            NSMutableArray *arrBookmarkServer = [NSMutableArray arrayWithCapacity:arrDictBookmark.count];
            NSMutableArray *arrPkidServer = [NSMutableArray arrayWithCapacity:arrDictBookmark.count];
            for (NSDictionary *dictBookmark in arrDictBookmark) {
                ModelBookmark *modelBookmarkServer = [ModelBookmark modelWithDict:dictBookmark];
                [arrBookmarkServer addObject:modelBookmarkServer];
                [arrPkidServer addObject:@(modelBookmarkServer.pkid_server)];
                
                ModelBookmark *modelBookmarkLocal = [ADOBookmark queryWithPkidServer:modelBookmarkServer.pkid_server userId:[self userId]];
                if (modelBookmarkServer.isFolder) {
                    // 书签文件夹
                    if (modelBookmarkLocal) {
                        if (modelBookmarkLocal.updateTime<modelBookmarkServer.updateTimeServer) {
                            modelBookmarkServer.pkid = modelBookmarkLocal.pkid;
                            modelBookmarkServer.parent_pkid = [ADOBookmark queryPkidWithPkidServer:modelBookmarkServer.parent_pkid_server];
                            modelBookmarkServer.updateTime = modelBookmarkServer.updateTimeServer;
                            [ADOBookmark updateModel:modelBookmarkServer];
                        }
                    }
                    else {
                        modelBookmarkServer.updateTime = modelBookmarkServer.updateTimeServer;
                        modelBookmarkServer.pkid = [ADOBookmark addModel:modelBookmarkServer];
                    }
                }
                else {
                    // 书签
                    ModelBookmark *modelBookmarkSameLink = nil;
                    if (modelBookmarkLocal) {
                        modelBookmarkSameLink = [ADOBookmark queryWithLink:modelBookmarkServer.link userId:[self userId] exceptPkid:modelBookmarkLocal.pkid];
                        if (modelBookmarkSameLink) {
                            // 需要删除重复项
                            ModelBookmark *modelTmp = modelBookmarkSameLink.updateTime>modelBookmarkLocal.updateTime?modelBookmarkSameLink:modelBookmarkLocal;
                            NSInteger willDeletePkid = modelBookmarkSameLink.updateTime>modelBookmarkLocal.updateTime?modelBookmarkLocal.pkid:modelBookmarkSameLink.pkid;
                            
                            // 删除 modelBookmarkLocal
                            [ADOBookmark deleteWithPkid:willDeletePkid];
                            
                            if (modelTmp.updateTime<modelBookmarkServer.updateTimeServer) {
                                modelBookmarkServer.pkid = modelTmp.pkid;
                                modelBookmarkServer.parent_pkid = [ADOBookmark queryPkidWithPkidServer:modelBookmarkServer.parent_pkid_server];
                                modelBookmarkServer.updateTime = modelBookmarkServer.updateTimeServer;
                                [ADOBookmark updateModel:modelBookmarkServer];
                            }
                            else {
                                modelTmp.pkid_server = modelBookmarkServer.pkid_server;
                                modelTmp.parent_pkid_server = [ADOBookmark queryPkidServerWithPkid:modelTmp.parent_pkid];
                                [ADOBookmark updateModel:modelTmp];
                            }
                        }
                        else {
                            if (modelBookmarkLocal.updateTime<modelBookmarkServer.updateTimeServer) {
                                modelBookmarkServer.pkid = modelBookmarkLocal.pkid;
                                modelBookmarkServer.parent_pkid = [ADOBookmark queryPkidWithPkidServer:modelBookmarkServer.parent_pkid_server];
                                modelBookmarkServer.updateTime = modelBookmarkServer.updateTimeServer;
                                [ADOBookmark updateModel:modelBookmarkServer];
                            }
                        }
                    }
                    else {
                        modelBookmarkSameLink = [ADOBookmark queryWithLink:modelBookmarkServer.link userId:[self userId]];
                        if (modelBookmarkSameLink) {
                            if (modelBookmarkSameLink.updateTime<modelBookmarkServer.updateTimeServer) {
                                modelBookmarkServer.pkid = modelBookmarkSameLink.pkid;
                                modelBookmarkServer.parent_pkid = modelBookmarkSameLink.parent_pkid;
                                modelBookmarkServer.parent_pkid_server = [ADOBookmark queryPkidServerWithPkid:modelBookmarkServer.parent_pkid];
                                modelBookmarkServer.updateTime = modelBookmarkServer.updateTimeServer;
                                [ADOBookmark updateModel:modelBookmarkServer];
                            }
                            else {
                                modelBookmarkSameLink.pkid_server = modelBookmarkServer.pkid_server;
                                modelBookmarkSameLink.parent_pkid_server = [ADOBookmark queryPkidServerWithPkid:modelBookmarkSameLink.parent_pkid];
                                [ADOBookmark updateModel:modelBookmarkSameLink];
                            }
                        }
                        else {
                            modelBookmarkServer.updateTime = modelBookmarkServer.updateTimeServer;
                            modelBookmarkServer.parent_pkid = [ADOBookmark queryParentPkidWithParentPkidServer:modelBookmarkServer.parent_pkid_server];
                            modelBookmarkServer.pkid = [ADOBookmark addModel:modelBookmarkServer];
                        }
                    }
                }
            }
            [ADOBookmark deleteWithArrPkidServer:arrPkidServer userId:[self userId]];
            if (completion) completion(arrBookmarkServer);
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.bookmark.get = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

- (void)syncGetModeWithCompletion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.mode.get) {
        if (fail) fail(nil);
        return;
    }
    
    _syncOperation.mode.get = YES;
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"pagesize":@(NSIntegerMax)};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_GetUserMode  parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.mode.get = NO;
        NSArray *arrDictMode = [self resovleJSON:JSON];
        if (arrDictMode) {
            NSMutableArray *arrModeServer = [NSMutableArray arrayWithCapacity:arrDictMode.count];
            NSMutableArray *arrPkidServer = [NSMutableArray arrayWithCapacity:arrDictMode.count];
            for (NSDictionary *dictMode in arrDictMode) {
                ModelMode *modelModeServer = [ModelMode modelWithDict:dictMode];
                [arrModeServer addObject:modelModeServer];
                [arrPkidServer addObject:@(modelModeServer.pkid_server)];

                // 比较pkid_server
                ModelMode *modelModeLocal = [ADOMode queryWithPkidServer:modelModeServer.pkid_server];
                ModelMode *modelModeSameName = nil;
                if (modelModeLocal) {
                    modelModeSameName = [ADOMode queryWithName:modelModeServer.name sysRecommend:modelModeServer.sysRecommend userId:[self userId] exceptPkid:modelModeLocal.pkid];
                    if (modelModeSameName) {
                        ModelMode *modelTmp = modelModeLocal.updateTime>modelModeSameName.updateTime?modelModeLocal:modelModeSameName;
                        NSInteger willDeletePkid = modelModeLocal.updateTime>modelModeSameName.updateTime?modelModeSameName.pkid:modelModeLocal.pkid;
                        
                        // 删除重名项
                        [ADOMode deleteWithPkid:willDeletePkid];
                        
                        if (modelTmp.updateTime<modelModeServer.updateTimeServer) {
                            modelModeServer.pkid = modelTmp.pkid;
                            modelModeServer.updateTime = modelModeServer.updateTimeServer;
                            [ADOMode updateModel:modelModeServer];
                        }
                        else {
                            modelTmp.pkid_server = modelModeServer.pkid_server;
                            [ADOMode updateModel:modelTmp];
                        }
                    }
                    else {
                        if (modelModeLocal.updateTime<modelModeServer.updateTimeServer) {
                            // 修改本地数据
                            modelModeServer.pkid = modelModeLocal.pkid;
                            modelModeServer.updateTime = modelModeServer.updateTimeServer;
                            [ADOMode updateModel:modelModeServer];
                        }
                    }
                }
                else {
                    // 添加到本地
                    modelModeServer.updateTime = modelModeServer.updateTimeServer;
                    modelModeServer.pkid = [ADOMode addModel:modelModeServer];
                }
            }
            
            [ADOMode deleteWithArrPkidServer:arrPkidServer userId:[self userId]];
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.mode.get = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

- (void)syncGetModeProgramWithArrModePkidServer:(NSArray *)arrModePkidServer completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.modeProgram.get) {
        if (fail) fail(nil);
        return;
    }
    
    _syncOperation.modeProgram.get = YES;
    
    NSMutableArray *arrDictPkidServer = [NSMutableArray arrayWithCapacity:arrModePkidServer.count];
    for (NSNumber *modePkidServer in arrModePkidServer) {
        [arrDictPkidServer addObject:@{@"mode_pkid":modePkidServer}];
    }
    NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictPkidServer options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"pagesize":@(NSIntegerMax),
                                @"mode_pkid":jsonStr};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_GetUserModeProgram  parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.modeProgram.get = NO;
        NSDictionary *dictMode = [self resovleJSON:JSON];
        if (dictMode) {
            for (NSNumber *modePkid in arrModePkidServer) {
                NSArray *arrDictModeProgram = dictMode[[modePkid stringValue]];
                if ([arrDictModeProgram isKindOfClass:[NSArray class]] && arrDictModeProgram.count>0) {
                    NSMutableArray *arrModeProgramServer = [NSMutableArray arrayWithCapacity:arrDictModeProgram.count];
                    NSMutableArray *arrPkidServer = [NSMutableArray arrayWithCapacity:arrDictModeProgram.count];
                    for (NSDictionary *dictModeProgram in arrDictModeProgram) {
                        ModelModeProgram *modelModeProgramServer = [ModelModeProgram modelWithDict:dictModeProgram];
                        modelModeProgramServer.modePkid = [ADOMode queryModePkidWithModePkidServer:[modePkid integerValue]];
                        [arrModeProgramServer addObject:modelModeProgramServer];
                        [arrPkidServer addObject:@(modelModeProgramServer.pkid_server)];
                        
                        // 是否存在改服务器数据
                        ModelModeProgram *modelModeProgramLocal = [ADOModeProgram queryWithPkidServer:modelModeProgramServer.pkid_server];
                        // 服务器上的最新数据时间可能跟本地其他数据有冲突，如果有冲突，保留最新的数据，删除旧的数据，最新的依据是比较本地的update_time
                        ModelModeProgram *modelModeProgramSameTime = nil;
                        if (modelModeProgramLocal) {
                            modelModeProgramSameTime = [ADOModeProgram queryWithModePkid:modelModeProgramServer.modePkidServer time:modelModeProgramServer.time exceptPkid:modelModeProgramLocal.pkid];
                            if (modelModeProgramSameTime) {
                                // 存在重复的数据，需要删除一个
                                ModelModeProgram *modelTmp = modelModeProgramSameTime.updateTime>modelModeProgramLocal.updateTime?modelModeProgramSameTime:modelModeProgramLocal;
                                NSInteger willDeletePkid = modelModeProgramSameTime.updateTime>modelModeProgramLocal.updateTime?modelModeProgramLocal.pkid:modelModeProgramSameTime.pkid;
                                
                                // 删除 modelModeProgramLocal
                                [ADOModeProgram deleteWithPkid:willDeletePkid];
                                
                                if (modelTmp.updateTime<modelModeProgramServer.updateTimeServer) {
                                    // 设置成服务器数据
                                    modelModeProgramServer.pkid = modelTmp.pkid;
                                    modelModeProgramServer.updateTime = modelModeProgramServer.updateTimeServer;
                                    [ADOModeProgram updateModel:modelModeProgramServer];
                                }
                                else {
                                    // 设置成本地数据
                                    modelTmp.pkid_server = modelModeProgramServer.pkid_server;
                                    [ADOModeProgram updateModel:modelTmp];
                                }
                                
                            }
                            else {
                                if (modelModeProgramLocal.updateTime<modelModeProgramServer.updateTimeServer) {
                                    modelModeProgramServer.pkid = modelModeProgramLocal.pkid;
                                    modelModeProgramServer.updateTime = modelModeProgramServer.updateTimeServer;
                                    [ADOModeProgram updateModel:modelModeProgramServer];
                                }
                            }
                        }
                        else {
                            modelModeProgramSameTime = [ADOModeProgram queryWithModePkid:modelModeProgramServer.modePkid time:modelModeProgramServer.time];
                            if (modelModeProgramSameTime) {
                                if (modelModeProgramSameTime.updateTime<modelModeProgramServer.updateTimeServer) {
                                    // 设置成服务器数据
                                    modelModeProgramServer.pkid = modelModeProgramSameTime.pkid;
                                    modelModeProgramServer.updateTime = modelModeProgramServer.updateTimeServer;
                                    [ADOModeProgram updateModel:modelModeProgramServer];
                                }
                                else {
                                    // 设置成本地数据
                                    modelModeProgramSameTime.pkid_server = modelModeProgramServer.pkid_server;
                                    [ADOModeProgram updateModel:modelModeProgramSameTime];
                                }
                                
                            }
                            else {
                                modelModeProgramServer.updateTime = modelModeProgramServer.updateTimeServer;
                                modelModeProgramServer.pkid = [ADOModeProgram addModel:modelModeProgramServer];
                            }
                        }
                    }
                    
                    [ADOModeProgram deleteWithArrPkidServer:arrPkidServer modePkidServer:[modePkid integerValue]];
                }
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.modeProgram.get = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

#pragma mark - 同步操作 批处理同步 add【成功之后再修改本地数据库中的update_time_server,pkid_server和相关的外键pkid_server **** 很重要】
// --------------------- 批处理同步 add【成功之后再修改本地数据库中的update_time_server,pkid_server和相关的外键pkid_server **** 很重要】
/**
 *  往服务器添加最近浏览的历史记录，添加成功后更新本地的pkid_server
 *
 *  @param arrHistory   历史记录实体 数组
 *  @param completion   completion description
 *  @param fail         fail description
 */
- (void)syncAddArrHistory:(NSArray *)arrHistory completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.history.add) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrHistory.count<=0) {
        _syncOperation.history.add = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.history.add = YES;
    NSMutableArray *arrDictHistory = [NSMutableArray arrayWithCapacity:arrHistory.count];
    for (ModelHistory *modelHistory in arrHistory) {
        modelHistory.updateTimeServer = modelHistory.updateTime;
        NSDictionary *dictHistory = @{@"title":modelHistory.title,
                                      @"link":modelHistory.link,
                                      @"icon":modelHistory.icon,
                                      @"time":@(modelHistory.time),
                                      @"times":@(modelHistory.times),
                                      @"update_time":@(modelHistory.updateTimeServer),
                                      @"user_id":@(modelHistory.userid)};
        [arrDictHistory addObject:dictHistory];
    }
    NSString *jsonArrModel = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictHistory
                                                                                            options:0
                                                                                              error:nil]
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"history":jsonArrModel};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_AddUserHistory parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.history.add = NO;
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    break;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                ModelHistory *modelHistory = arrHistory[index];
                [ADOHistory updatePkidServer:pkidServer updateTimeServer:modelHistory.updateTimeServer withPkid:modelHistory.pkid];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.history.add = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  往服务器添加书签(文件件)，添加成功后，更新本地相关的pkid_server和parent_pkid_server
 *
 *  @param arrBookmark  书签实体 数据
 *  @param completion    完成block
 *  @param fail          失败block
 */
- (void)syncAddArrBookmark:(NSArray *)arrBookmark completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.bookmark.add) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrBookmark.count<=0) {
        _syncOperation.bookmark.add = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.bookmark.add = YES;
    
    NSMutableArray *arrDictBookmark = [NSMutableArray arrayWithCapacity:arrBookmark.count];
    for (ModelBookmark *modelBookmark in arrBookmark) {
        modelBookmark.updateTimeServer = modelBookmark.updateTime;
        NSDictionary *dictBookmark = @{@"title":modelBookmark.title?:@"",
                                       @"link":modelBookmark.link?:@"",
                                       @"icon":modelBookmark.icon?:@"",
                                       @"is_folder":@(modelBookmark.isFolder),
                                       @"can_edit":@(modelBookmark.canEdit),
                                       @"sort_index":@(modelBookmark.sortIndex),
                                       @"parent_pkid":@(modelBookmark.parent_pkid_server),
                                       @"update_time":@(modelBookmark.updateTimeServer),
                                       @"user_id":@(modelBookmark.userid)};
        [arrDictBookmark addObject:dictBookmark];
    }

    NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictBookmark options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"bookmark":jsonStr};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_AddUserBookmark parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.bookmark.add = NO;
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    break;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                ModelBookmark *modelBookmark = arrBookmark[index];
                // 删除已存在的项目
                [ADOBookmark deleteWithPkidServer:pkidServer userId:modelBookmark.userid exceptPkid:modelBookmark.pkid];
                
                //
                modelBookmark.pkid_server = pkidServer;
                [ADOBookmark updateModel:modelBookmark];
                
                /**
                 *  更新 parent_pkid_esrver
                 */
                [ADOBookmark updateParentPkidServer:pkidServer withParentPkid:modelBookmark.pkid];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.bookmark.add = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  往服务器添加 定制 模式，添加成功后，更新本地的相关的pkid_server和 ModelModeProgram 中的 mode_pkid_server
 *
 *  @param arrMode      模式实体数组
 *  @param completion   完成block
 *  @param fail         失败block
 */
- (void)syncAddArrMode:(NSArray *)arrMode completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.mode.add) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrMode.count<=0) {
        _syncOperation.mode.add = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.mode.add = YES;
    NSMutableArray *arrDictMode = [NSMutableArray arrayWithCapacity:arrMode.count];
    for (ModelMode *modelMode in arrMode) {
        modelMode.updateTimeServer = modelMode.updateTime;
        NSDictionary *dictMode = @{@"name":modelMode.name,
                                   @"sys_recommend":@(modelMode.isSysRecommend),
                                   @"update_time":@(modelMode.updateTimeServer),
                                   @"user_id":@(modelMode.userid)};
        [arrDictMode addObject:dictMode];
    }
    NSString *jsonArrModel = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictMode
                                                                                            options:0
                                                                                              error:nil]
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"mode":jsonArrModel};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_AddUserMode parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.mode.add = NO;
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    break;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                ModelMode *modelMode = arrMode[index];
                // 删除已存在的项目
                [ADOMode deleteWithPkidServer:pkidServer userId:modelMode.userid exceptPkid:modelMode.pkid];
                
                //
                modelMode.pkid_server = pkidServer;
                [ADOMode updateModel:modelMode];
                
                /**
                 *  更新 模式—节目 中的 mode_pkid_server
                 */
                [ADOModeProgram updateModePkidServer:pkidServer withModePkid:modelMode.pkid];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.mode.add = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  往服务器添加 模式-节目，添加成功后，更新本地相关的pkid_server
 *
 *  @param arrModeProgram   模式-节目实体 数组
 *  @param completion       completion description
 *  @param fail             fail description
 */
- (void)syncAddArrModeProgram:(NSArray *)arrModeProgram completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.modeProgram.add) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrModeProgram.count<=0) {
        _syncOperation.modeProgram.add = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.modeProgram.add = YES;
    
    NSMutableArray *arrDictModeProgram = [NSMutableArray arrayWithCapacity:arrModeProgram.count];
    for (ModelModeProgram *modeProgram in arrModeProgram) {
        modeProgram.updateTimeServer = modeProgram.updateTime;
        NSDictionary *dictModeProgram = @{@"mode_pkid":@(modeProgram.modePkidServer),
                                          @"program_pkid":@(modeProgram.modelProgram.pkid_server),
                                          @"time":@(modeProgram.time),
                                          @"repeat":@(modeProgram.repeatMode),
                                          @"is_on":@(modeProgram.on),
                                          @"update_time":@(modeProgram.updateTimeServer)};
        [arrDictModeProgram addObject:dictModeProgram];
    }
    
    NSString *jsonArrModel = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictModeProgram
                                                                                            options:0
                                                                                              error:nil]
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"mode_program":jsonArrModel};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_AddUserModeProgram parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.modeProgram.add = NO;
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    break;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                ModelModeProgram *modelModeProgram = arrModeProgram[index];
                // 删除已存在的项目(time)
                [ADOModeProgram deleteWithPkidServer:pkidServer modePkidServer:modelModeProgram.modePkidServer exceptPkid:modelModeProgram.pkid];
                modelModeProgram.pkid_server = pkidServer;
                [ADOModeProgram updateModel:modelModeProgram];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.modeProgram.add = NO;
        if (fail) fail(error);
    }];
    [afReq start];
    
}

#pragma mark - 同步操作 批处理同步 update【成功之后再修改本地数据库 **** 很重要】
// --------------------- 批处理同步 update【成功之后再修改本地数据库 **** 很重要】
/**
 *  向服务器修改用户设置
 *
 *  @param userSetting 用户设置实体
 *  @param completion  completion description
 *  @param fail        fail description
 */
- (void)syncUpdateUserSetting:(ModelUserSettings *)userSetting completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.userSettings.update) {
        if (fail) fail(nil);
        return;
    }
    
    _syncOperation.userSettings.update = YES;
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"sync_bookmark":@(userSetting.syncBookmark),
                                @"sync_lastvisit":@(userSetting.syncLastVisit),
                                @"sync_reminder":@(userSetting.syncReminder),
                                @"sync_style":@(userSetting.syncStyle),
                                @"update_time":@(userSetting.updateTimeServer)};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:GetApiWithName(API_UpdateUserSettings) parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.userSettings.update = NO;
        NSDictionary *dictResult = [self resovleJSON:JSON];
        if (dictResult) {
            ModelUserSettings *modelUserSettingsServer = [ModelUserSettings modelWithDict:dictResult];
            [UserManager shareUserManager].currUser.settings = modelUserSettingsServer;
            [ADOUserSettings updateModel:modelUserSettingsServer];
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
            
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.userSettings.update = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  修改服务器 最近浏览(历史记录前20条)
 *
 *  @param arrHistory   历史记录实体 数组 ModelHistory
 *  @param async        异步实现; YES:不检查是否正在同步；NO:需要检查是否正在同步
 *  @param completion   completion description
 *  @param fail         fail description
 */
- (void)syncUpdateArrHistory:(NSArray *)arrHistory async:(BOOL)async completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.history.update && !async) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrHistory.count<=0) {
        _syncOperation.history.update = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.history.update = YES;
    NSMutableArray *arrDictHistory = [NSMutableArray arrayWithCapacity:arrHistory.count];
    for (ModelHistory *modelHistory in arrHistory) {
        modelHistory.updateTimeServer = modelHistory.updateTime;
        NSDictionary *dictHistory = @{@"pkid":@(modelHistory.pkid_server),
                                      @"title":modelHistory.title,
                                      @"link":modelHistory.link,
                                      @"icon":modelHistory.icon,
                                      @"time":@(modelHistory.time),
                                      @"times":@(modelHistory.times),
                                      @"update_time":@(modelHistory.updateTimeServer),
                                      @"user_id":@(modelHistory.userid)};
        [arrDictHistory addObject:dictHistory];
    }
    NSString *jsonArrModel = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictHistory
                                                                                            options:0
                                                                                              error:nil]
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"history":jsonArrModel};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_UpdateUserHistory parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.history.update = NO;
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    continue;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                if (pkidServer<=0) {
                    continue;
                }
                ModelHistory *modelHistory = arrHistory[index];
                [ADOHistory updatePkidServer:pkidServer updateTimeServer:modelHistory.updateTimeServer withPkid:modelHistory.pkid];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.history.update = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  修改服务器 书签
 *
 *  @param arrBookmark 书签实体 数组 ModelBookmark
 *  @param completion  completion description
 *  @param fail        fail description
 */
- (void)syncUpdateArrBookmark:(NSArray *)arrBookmark completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.bookmark.update) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrBookmark.count<=0) {
        _syncOperation.bookmark.update = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.bookmark.update = YES;
    
    NSMutableArray *arrDictBookmark = [NSMutableArray arrayWithCapacity:arrBookmark.count];
    for (ModelBookmark *modelBookmark in arrBookmark) {
        modelBookmark.updateTimeServer = modelBookmark.updateTime;
        NSDictionary *dictBookmark = @{@"pkid":@(modelBookmark.pkid_server),
                                       @"title":modelBookmark.title?:@"",
                                       @"link":modelBookmark.link?:@"",
                                       @"icon":modelBookmark.icon?:@"",
                                       @"is_folder":@(modelBookmark.isFolder),
                                       @"can_edit":@(modelBookmark.canEdit),
                                       @"sort_index":@(modelBookmark.sortIndex),
                                       @"parent_pkid":@(modelBookmark.parent_pkid_server),
                                       @"update_time":@(modelBookmark.updateTimeServer),
                                       @"user_id":@(modelBookmark.userid)};
        [arrDictBookmark addObject:dictBookmark];
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictBookmark options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"bookmark":jsonStr};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_UpdateUserBookmark parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.bookmark.update = NO;
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    continue;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                if (pkidServer<=0) {
                    continue;
                }
                ModelBookmark *modelBookmark = arrBookmark[index];
                // 删除已存在的项目
                [ADOBookmark updateModel:modelBookmark];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.bookmark.update = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  修改服务器 个性化定制 模式
 *
 *  @param arrMode    模式实体 数组
 *  @param completion completion description
 *  @param fail       fail description
 */
- (void)syncUpdateArrMode:(NSArray *)arrMode completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.mode.update) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrMode.count<=0) {
        _syncOperation.mode.update = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.mode.update = YES;
    NSMutableArray *arrDictMode = [NSMutableArray arrayWithCapacity:arrMode.count];
    for (ModelMode *modelMode in arrMode) {
        modelMode.updateTimeServer = modelMode.updateTime;
        NSDictionary *dictMode = @{@"pkid":@(modelMode.pkid_server),
                                   @"name":modelMode.name,
                                   @"sys_recommend":@(modelMode.isSysRecommend),
                                   @"update_time":@(modelMode.updateTimeServer),
                                   @"user_id":@(modelMode.userid)};
        [arrDictMode addObject:dictMode];
    }
    NSString *jsonArrModel = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictMode
                                                                                            options:0
                                                                                              error:nil]
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"mode":jsonArrModel};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_UpdateUserMode parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.mode.update = NO;
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    continue;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                if (pkidServer<=0) {
                    continue;
                }
                ModelMode *modelMode = arrMode[index];
                // 将服务器时间修改设置本地时间办
                [ADOMode updateModel:modelMode];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.mode.update = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

/**
 *  修改服务器 模式-节目
 *
 *  @param arrModeProgram 模式-节目 实体 数组
 *  @param completion     completion description
 *  @param fail           fail description
 */
- (void)syncUpdateArrModeProgram:(NSArray *)arrModeProgram completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if (_syncOperation.modeProgram.update) {
        if (fail) fail(nil);
        return;
    }
    
    if (arrModeProgram.count<=0) {
        _syncOperation.modeProgram.update = NO;
        if (completion) completion();
        return;
    }
    
    _syncOperation.modeProgram.update = YES;
    
    NSMutableArray *arrDictModeProgram = [NSMutableArray arrayWithCapacity:arrModeProgram.count];
    for (ModelModeProgram *modeProgram in arrModeProgram) {
        modeProgram.updateTimeServer = modeProgram.updateTime;
        NSDictionary *dictModeProgram = @{@"pkid":@(modeProgram.pkid_server),
                                          @"mode_pkid":@(modeProgram.modePkidServer),
                                          @"program_pkid":@(modeProgram.modelProgram.pkid_server),
                                          @"time":@(modeProgram.time),
                                          @"repeat":@(modeProgram.repeatMode),
                                          @"is_on":@(modeProgram.on),
                                          @"update_time":@(modeProgram.updateTimeServer)};
        [arrDictModeProgram addObject:dictModeProgram];
    }
    
    NSString *jsonArrModel = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrDictModeProgram
                                                                                            options:0
                                                                                              error:nil]
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"mode_program":jsonArrModel};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_UpdateUserModeProgram parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _syncOperation.modeProgram.update = NO;
        
        NSArray *arrDictPkidServer = [self resovleJSON:JSON];
        if (arrDictPkidServer.count>0) {
            for (NSInteger index=0; index<arrDictPkidServer.count; index++) {
                NSDictionary *dictPkidServer = arrDictPkidServer[index];
                if (!dictPkidServer[@"pkid"]) {
                    continue;
                }
                NSInteger pkidServer = [dictPkidServer[@"pkid"] integerValue];
                if (pkidServer<=0) {
                    continue;
                }
                ModelModeProgram *modelModeProgram = arrModeProgram[index];
                // 将服务器时间修改设置本地时间办
                [ADOModeProgram updateModel:modelModeProgram];
            }
            
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _syncOperation.modeProgram.update = NO;
        if (fail) fail(error);
    }];
    [afReq start];
}

#pragma mark - 同步 清空服务器上的用户数据
// ------------------- 同步 清空服务器上的用户数据
/**
 *  清空服务器上的用户数据
 *
 *  @param syncDataType 数据类型
 *  @param completion   completion description
 *  @param fail         fail description
 */
- (void)syncClearDataType:(SyncDataType)syncDataType completion:(SyncCompletion)completion fail:(SyncFail)fail
{
    if ([self isSyncingWithSyncSubOperation:_syncOperation.userSettings]) {
        if (fail) fail(nil);
        return;
    }
    
    switch (syncDataType) {
        case SyncDataTypeBookmark:
        {
            [ADOBookmark clearWithUserId:[self userId]];
            if ([self isSyncingWithSyncSubOperation:_syncOperation.bookmark]) {
                if (fail) fail(nil);
                return;
            }
        }break;
        case SyncDataTypeHistory:
        {
            [ADOHistory clearWithUserId:[self userId]];
            if ([self isSyncingWithSyncSubOperation:_syncOperation.history]) {
                if (fail) fail(nil);
                return;
            }
        }break;
        case SyncDataTypeMode:
        {
            [ADOMode clearWithUserId:[self userId]];
            if ([self isSyncingWithSyncSubOperation:_syncOperation.mode]) {
                if (fail) fail(nil);
                return;
            }
        }break;
        case SyncDataTypeModeProgram:
        {
            if ([self isSyncingWithSyncSubOperation:_syncOperation.modeProgram]) {
                if (fail) fail(nil);
                return;
            }
        }break;
        case SyncDataTypeAll:
        {
            if ([self isSyncing]) {
                if (fail) fail(nil);
                return;
            }
        }break;
        default:
            if (fail) fail(nil);
            return;
            break;
    }
    
    NSDictionary *dictParam = @{@"uid":@([self userId]),
                                @"token":[self token],
                                @"data_type":@(syncDataType)};
    NSMutableURLRequest *req = [_afClient requestWithMethod:@"POST" path:API_ClearUserData parameters:dictParam];
    AFJSONRequestOperation *afReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (syncDataType&SyncDataTypeBookmark)
            _syncOperation.bookmark.clear = NO;
        if (syncDataType&SyncDataTypeHistory)
            _syncOperation.history.clear = NO;
        if (syncDataType&SyncDataTypeMode)
            _syncOperation.mode.clear = NO;
        if (syncDataType&SyncDataTypeModeProgram)
            _syncOperation.modeProgram.clear = NO;
        
        NSDictionary *dictResult = [self resovleJSON:JSON];
        if (dictResult) {
            if (completion) completion();
        }
        else {
            if (fail) fail(nil);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (syncDataType&SyncDataTypeBookmark)
            _syncOperation.bookmark.clear = NO;
        if (syncDataType&SyncDataTypeHistory)
            _syncOperation.history.clear = NO;
        if (syncDataType&SyncDataTypeMode)
            _syncOperation.mode.clear = NO;
        if (syncDataType&SyncDataTypeModeProgram)
            _syncOperation.modeProgram.clear = NO;
        
        if (fail) fail(error);
    }];
    [afReq start];
}

#pragma mark - 同步操作完成后的数据基本验证
// ----------------------- private methods
- (id)resovleJSON:(id)JSON
{
    id data = nil;
    do {
        if (![JSON isKindOfClass:[NSDictionary class]]) break;
        
        id error = JSON[@"error"];
        NSString *msg = JSON[@"msg"];
        data = JSON[@"data"];
        NSInteger errorCode = error?[error integerValue]:0;
        
        if (errorCode>=2000 || [data isKindOfClass:[NSNull class]]) {
            data = nil;
            _DEBUG_LOG(@"errorCode:%ld msg=%@", (long)errorCode, msg);
        }
        
    } while (NO);
    
    return data;
}

@end
