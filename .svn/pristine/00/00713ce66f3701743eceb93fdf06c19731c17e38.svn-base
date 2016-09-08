//
//  ModelAppCate.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelAppCate.h"
#import "ModelApp.h"

@implementation ModelAppCate

#pragma mark - property
- (void)setName:(NSString *)name
{
    _name = [name isKindOfClass:[NSString class]]?name:nil;
}

- (void)setIcon:(NSString *)icon
{
    _icon = [icon isKindOfClass:[NSString class]]?icon:nil;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.name = dict[@"catname"];
        self.icon = dict[@"icon"];
        self.catId = [dict[@"catid"] integerValue];
        self.arrApp = [NSMutableArray array];
     
        NSArray *arrAppDict = dict[@"list"];
        if ([arrAppDict isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictApp in arrAppDict) {
                ModelApp *model = [ModelApp modelWithDict:dictApp];
                [_arrApp addObject:model];
            }
        }
    }
    return self;
}

@end
