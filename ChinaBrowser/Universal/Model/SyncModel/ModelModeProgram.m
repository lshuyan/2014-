//
//  ModelModelProgram.m
//  ChinaBrowser
//
//  Created by David on 14/11/22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelModeProgram.h"

#import "ModelProgram.h"
#import "ADOProgram.h"

@implementation ModelModeProgram

#pragma mark - instance
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        if (![dict[@"pkid"] isKindOfClass:[NSNull class]]) {
            self.pkid_server = [dict[@"pkid"] integerValue];
        }
        
        if (![dict[@"mode_pkid"] isKindOfClass:[NSNull class]]) {
            self.modePkidServer = [dict[@"mode_pkid"] integerValue];
        }
        
        if (![dict[@"time"] isKindOfClass:[NSNull class]]) {
            self.time = [dict[@"time"] integerValue];
        }
        
        if (![dict[@"repeat"] isKindOfClass:[NSNull class]]) {
            self.repeatMode = [dict[@"repeat"] integerValue];
        }
        
        // -------- 系统预设字段
        if (![dict[@"on"] isKindOfClass:[NSNull class]]) {
            self.on = [dict[@"on"] boolValue];
        }
        
        if (![dict[@"pid"] isKindOfClass:[NSNull class]]) {
            self.modelProgram = [ADOProgram queryWithPkidServer:[dict[@"pid"] integerValue]];
        }
        
        // ---------------- 同步时用的字段
        if (dict[@"is_on"]) {
            if (![dict[@"is_on"] isKindOfClass:[NSNull class]]) {
                self.on = [dict[@"is_on"] boolValue];
            }
        }
        
        if (!_modelProgram) {
            self.modelProgram = [ADOProgram queryWithPkidServer:[dict[@"program_pkid"] integerValue]];
        }
    }
    return self;
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super initWithResultSetDict:dict];
    if (self) {
        self.modePkid = [dict[@"mode_pkid"] integerValue];
        self.modePkidServer = [dict[@"mode_pkid_server"] integerValue];
        self.time = [dict[@"time"] integerValue];
        self.repeatMode = [dict[@"repeat"] integerValue];
        self.on = [dict[@"is_on"] boolValue];
        
        self.modelProgram = [ADOProgram queryWithPkidServer:[dict[@"program_pkid_server"] integerValue]];
    }
    return self;
}

@end
