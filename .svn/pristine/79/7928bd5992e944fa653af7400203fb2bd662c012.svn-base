//
//  ModelUserPassword.m
//  ChinaBrowser
//
//  Created by huyan on 14/12/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelUserPassword.h"

#import <AGCommon/NSString+Common.h>

@implementation ModelUserPassword

- (void)setUserName:(NSString *)userName
{
    _userName = [userName isKindOfClass:[NSString class]]?userName:nil;
}

- (void)setPassword:(NSString *)password
{
    _password = [password isKindOfClass:[NSString class]]?password:nil;
}

-(void)setLan:(NSString *)lan
{
    _lan = [lan isKindOfClass:[NSString class]]?lan:nil;
}


- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.userName = dict[@"user_name"];
        self.password = [dict[@"password"] base64Decode:NSUTF32StringEncoding];
    }
    return self;
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super initWithResultSetDict:dict];
    if (self) {
        self.userName = dict[@"user_name"];
        self.password = [dict[@"password"] base64Decode:NSUTF32StringEncoding];
    }
    return self;
}

@end
