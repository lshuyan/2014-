//
//  ModelSyncBase.m
//  ChinaBrowser
//
//  Created by David on 14/11/21.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelSyncBase.h"

@implementation ModelSyncBase

#pragma mark - property
- (void)setLan:(NSString *)lan
{
    _lan = [lan isKindOfClass:[NSString class]]?lan:nil;
}

#pragma mark - instance
+ (instancetype)model
{
    ModelSyncBase *model = [[[self class] alloc] init];
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lan = [LocalizationUtil currLanguage];
        self.userid = [UserManager shareUserManager].currUser.uid;
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.lan = [LocalizationUtil currLanguage];
        
        if (dict[@"pkid"])
            self.pkid_server = [dict[@"pkid"] integerValue];
        if (dict[@"user_id"])
            self.userid = [dict[@"user_id"] integerValue];
        if (dict[@"update_time"])
            self.updateTimeServer = [dict[@"update_time"] integerValue];
    }
    return self;
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super initWithResultSetDict:dict];
    if (self) {
        self.pkid = [dict[@"pkid"] integerValue];
        self.pkid_server = [dict[@"pkid_server"] integerValue];
        self.userid = [dict[@"user_id"] integerValue];
        self.lan = dict[@"lan"];
        
        self.updateTime = [dict[@"update_time"] integerValue];
        self.updateTimeServer = [dict[@"update_time_server"] integerValue];
    }
    return self;
}

@end