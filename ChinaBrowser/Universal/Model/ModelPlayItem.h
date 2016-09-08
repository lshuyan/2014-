//
//  ModelPlayItem.h
//  ChinaBrowser
//
//  Created by David on 14/12/2.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

@interface ModelPlayItem : ModelBase

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *fm;

+ (instancetype)modelWithTitle:(NSString *)title link:(NSString *)link fm:(NSString *)fm icon:(NSString *)icon;
- (instancetype)initWithTitle:(NSString *)title link:(NSString *)link fm:(NSString *)fm icon:(NSString *)icon;

@end
