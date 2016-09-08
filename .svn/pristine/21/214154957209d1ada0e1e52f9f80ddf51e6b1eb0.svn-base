//
//  UIControllerManuallyAdd.h
//  ChinaBrowser
//
//  Created by 石显军 on 14/11/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

@class ModelApp;

@interface UIControllerManuallyAdd : UIControllerBase

@property (nonatomic, strong) void (^callbackDidEdit)(ModelApp *);

/**
 *  正在编辑的 App 实体，如果 没有 设置或 值为nil，表示是 新建
 */
@property (nonatomic, strong) ModelApp *editApp;

@end
