//
//  ModelAppCate.h
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

/**
 *  应用分类
 */
@interface ModelAppCate : ModelBase

/**
 *  分类ID
 */
@property (nonatomic, assign) NSInteger catId;

/**
 *  分类名称
 */
@property (nonatomic, strong) NSString *name;

/**
 *  分类icon
 */
@property (nonatomic, strong) NSString *icon;

/**
 *  APP列表
 */
@property (nonatomic, strong) NSMutableArray *arrApp;

@end
