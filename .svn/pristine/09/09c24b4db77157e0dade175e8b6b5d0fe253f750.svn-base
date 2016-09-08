//
//  ModelUser.m
//  ChinaBrowser
//
//  Created by David on 13-10-18.
//  Copyright (c) 2013年 VeryApps. All rights reserved.
//

#import "ModelUser.h"

#import "ModelUserSettings.h"
#import <objc/runtime.h>

#import "ADOUserSettings.h"
#import "ADOSyncTime.h"

@implementation ModelUser

#pragma mark - property
- (void)setUsername:(NSString *)username
{
    _username = [username isKindOfClass:[NSString class]]?username:nil;
}

- (void)setNickname:(NSString *)nickname
{
    _nickname = [nickname isKindOfClass:[NSString class]]?nickname:nil;
}

- (void)setEmail:(NSString *)email
{
    _email = [email isKindOfClass:[NSString class]]?email:nil;
}

- (void)setAvatar:(NSString *)avatar
{
    _avatar = [avatar isKindOfClass:[NSString class]]?avatar:nil;
}

- (void)setPwd:(NSString *)pwd
{
    _pwd = [pwd isKindOfClass:[NSString class]]?pwd:nil;
}

/**
 *  设置同步时间
 *
 *  @param syncTime syncTime description
 */
- (void)setSyncTime:(NSInteger)syncTime
{
    _syncTime = syncTime;
    [ADOSyncTime setSyncTime:syncTime withUserId:_uid];
}

#pragma mark - instance

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSRange rangeGender = NSMakeRange(UserGenderMale, UserGenderSecrecy);
        if (!NSLocationInRange(_gender, rangeGender)) {
            // 如果不在已知的性别范围类，默认指定为 3：保密
            _gender = UserGenderSecrecy;
        }
        
        _syncTime = [ADOSyncTime getSyncTimeWithUserId:_uid];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    Class clazz = [self class];
    u_int count;
    
    objc_property_t *properties     = class_copyPropertyList(clazz, &count);
    NSMutableArray  *propertyArray  = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++) {
        const char* propertyName = property_getName(properties[i]);
        NSString *key = [NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        if ([key isEqualToString:@"settings"] || [key isEqualToString:@"syncTime"]) {
            continue;
        }
        
        [propertyArray addObject:key];
    }
    free(properties);
    
    for (NSString *name in propertyArray) {
        id value = [self valueForKey:name];
        if (value) {
            [aCoder encodeObject:value forKey:name];
        }
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.uid = [dict[@"id"] integerValue];
        self.username = dict[@"username"];
        self.nickname = dict[@"nickname"];
        self.token = dict[@"token"];
        self.avatar = dict[@"avatar"];
        self.gender = [dict[@"gender"] integerValue];
        self.email = dict[@"email"];
        self.autoCreate = [dict[@"auto_create"] boolValue];
        _syncTime = [ADOSyncTime getSyncTimeWithUserId:_uid];
        
        NSDictionary *dictSettings = dict[@"settings"];
        if (dictSettings) {
            _settings = [ModelUserSettings modelWithDict:dictSettings];
            _settings.userid = _uid;
        }
        else {
            /**
             *  登录解析出的用户万一不存在 用户设置项，则客户端默认指定一个(这种情况绝不允许存在，默认的用户设置需要在服务器上为用户分配)
             */
            _settings = [ADOUserSettings queryWithUserId:_uid];
            if (!_settings) {
                _settings = [ModelUserSettings model];
                _settings.userid = _uid;
                _settings.lan = [LocalizationUtil currLanguage];
                _settings.syncBookmark = YES;
                _settings.syncLastVisit = YES;
                _settings.syncReminder = YES;
                _settings.syncStyle = SyncStyleWiFi;
                _settings.updateTimeServer =
                _settings.updateTime = [[NSDate date] timeIntervalSince1970];
            }
        }
    }
    return self;
}

@end
