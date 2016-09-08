//
//  ModelBanner.m
//  ChinaBrowser
//
//  Created by David on 14-4-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBanner.h"

@implementation ModelBanner

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.title = dict[@"title"];
        self.image = dict[@"icon"];
        self.link = dict[@"link"];
    }
    return self;
}

@end
