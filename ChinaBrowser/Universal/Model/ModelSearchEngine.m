//
//  ModelSearchEngine.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelSearchEngine.h"

@implementation ModelSearchEngine

#pragma mark - property
- (void)setName:(NSString *)name
{
    _name = [name isKindOfClass:[NSString class]]?name:nil;
}

- (void)setIcon:(NSString *)icon
{
    _icon = [icon isKindOfClass:[NSString class]]?icon:nil;
}

- (void)setLink:(NSString *)link
{
    _link = [link isKindOfClass:[NSString class]]?link:nil;
}

#pragma mark - instance
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.seachEngineId = [dict[@"id"] integerValue];
        self.name = dict[@"name"];
        self.icon = dict[@"icon"];
        self.colorIcon = dict[@"color_icon"];
        self.link = dict[@"search_link"];
    }
    return self;
}

@end