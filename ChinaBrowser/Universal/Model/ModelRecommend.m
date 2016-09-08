//
//  ModelRecommend.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelRecommend.h"

@implementation ModelRecommend

#pragma mark - property
- (void)setName:(NSString *)name
{
    _name = [name isKindOfClass:[NSString class]]?name:nil;
}

- (void)setLink:(NSString *)link
{
    _link = [link isKindOfClass:[NSString class]]?link:nil;
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
        self.name = dict[@"title"];
        self.link = dict[@"link"];
        self.icon = dict[@"icon"];
        self.color = dict[@"color"];
        self.type = (RecommendType)[dict[@"type"] integerValue];
        self.catId = [dict[@"catid"] integerValue];
    }
    return self;
}

@end
