//
//  ModelSNSItem.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelSNSItem.h"

@implementation ModelSNSItem

#pragma mark - property
- (void)setName:(NSString *)name
{
    _name = [name isKindOfClass:[NSString class]]?name:nil;
}

- (void)setIcon:(NSString *)icon
{
    _icon = [icon isKindOfClass:[NSString class]]?icon:nil;
}

#pragma mark - instance
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.shareType = (ShareType)[dict[@"type"] integerValue];
        self.name = dict[@"name"];
        self.icon = dict[@"icon"];
    }
    return self;
}

@end
