//
//  ModelMode.m
//  ChinaBrowser
//
//  Created by David on 14/11/22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelMode.h"

#import "ModelModeProgram.h"

#import "ADOModeProgram.h"
#import "ModelModeProgram.h"

@implementation ModelMode

- (void)setName:(NSString *)name
{
    _name = [name isKindOfClass:[NSString class]]?name:nil;
}

#pragma mark - instance
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.pkid_server = [dict[@"mid"] integerValue];
        if (self.pkid_server==0) {
            self.pkid_server = [dict[@"pkid"] integerValue];
        }
        self.name = dict[@"name"];
        self.sysRecommend = [dict[@"sys_recommend"] boolValue];
    }
    return self;
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super initWithResultSetDict:dict];
    if (self) {
        self.name = dict[@"name"];
        self.sysRecommend = [dict[@"sys_recommend"] boolValue];
    }
    return self;
}

@end