//
//  ModelPlayItem.m
//  ChinaBrowser
//
//  Created by David on 14/12/2.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelPlayItem.h"

@implementation ModelPlayItem

+ (instancetype)modelWithTitle:(NSString *)title link:(NSString *)link fm:(NSString *)fm icon:(NSString *)icon
{
    return [[ModelPlayItem alloc] initWithTitle:title link:link fm:fm icon:icon];
}

- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link fm:(NSString *)fm icon:(NSString *)icon
{
    self = [super init];
    if (self) {
        self.title = title;
        self.link = link;
        self.fm = fm;
        self.icon = icon;
    }
    return self;
}

@end
