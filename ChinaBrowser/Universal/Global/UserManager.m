//
//  UserManager.m
//  ChinaBrowser
//
//  Created by David on 14/10/31.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UserManager.h"

#import "ModelUser.h"
#import "ModelUserSettings.h"
#import "ADOUserSettings.h"
#import "ADOSyncTime.h"
#import "CHKeychain.h"

#define kLoginUserId @"kLoginUserId"

static UserManager *userManager;

@implementation UserManager

#pragma mark - instance
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *szUid = [CHKeychain load:kLoginUserId];
        if (szUid) {
            _currUser = [ModelUser modelWithData:[CHKeychain load:szUid]];
            _currUser.settings = [ADOUserSettings queryWithUserId:_currUser.uid];
        }
    }
    return self;
}

+ (instancetype)shareUserManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[UserManager alloc] init];
    });
    return userManager;
}

- (void)deleteUserWithUid:(NSInteger)uid
{
    [CHKeychain delete:[@(uid) stringValue]];
}

/**
 *  更新用户信息
 *
 *  @param modelUser ModelUser
 */
- (void)updateUser:(ModelUser *)modelUser
{
    if (_currUser.uid==modelUser.uid) {
        ModelUserSettings *userSettings = _currUser.settings;
        _currUser = modelUser;
        _currUser.settings = userSettings;
        
        NSString *szUserId = [@(modelUser.uid) stringValue];
        [CHKeychain save:kLoginUserId data:szUserId];
        [CHKeychain save:[@(modelUser.uid) stringValue] data:[ModelUser dataWithModel:modelUser]];
    }
}

/**
 *  用户登录
 *
 *  @param user user description
 */
- (void)loginUser:(ModelUser *)user
{
    if (user) {
        _currUser = user;
        
        NSString *szUserId = [@(_currUser.uid) stringValue];
        [CHKeychain save:kLoginUserId data:szUserId];
        [CHKeychain save:szUserId data:[ModelUser dataWithModel:_currUser]];
        
        // TODO:保存用户设置信息，将本地updatetime设置为服务器的updatetime
        ModelUserSettings *modelUserSettings = [ADOUserSettings queryWithUserId:_currUser.uid];
        if (modelUserSettings) {
            _currUser.settings.updateTime = _currUser.settings.updateTimeServer;
            _currUser.settings.pkid = modelUserSettings.pkid;
            [ADOUserSettings updateModel:_currUser.settings];
        }
        else {
            _currUser.settings.updateTime = _currUser.settings.updateTimeServer;
            _currUser.settings.pkid = [ADOUserSettings addModel:_currUser.settings];
        }
    }
}

/**
 *  退出用户
 */
- (void)logout
{
    _currUser = nil;
    [CHKeychain delete:kLoginUserId];
}

@end
