//
//  ModelTravelProvince.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelTravelProvince.h"

@implementation ModelTravelProvince

#pragma mark - property
- (void)setName:(NSString *)name
{
    _name = [name isKindOfClass:[NSString class]]?name:nil;
}

- (void)setImage:(NSString *)image
{
    _image = [image isKindOfClass:[NSString class]]?image:nil;
}

#pragma mark - instance
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.provinceId = [dict[@"id"] integerValue];
        self.name = dict[@"name"];
        self.image = dict[@"img"];
        self.imageSize = CGSizeMake([dict[@"w"] floatValue], [dict[@"h"] floatValue]);
    }
    return self;
}

@end
