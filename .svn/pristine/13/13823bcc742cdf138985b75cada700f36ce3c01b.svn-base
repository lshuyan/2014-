//
//  UIControllerSetSkin.h
//  ChinaBrowser
//
//  Created by David on 14-3-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//
/**
 *  皮肤管理
 *  自定义皮肤图片保存在 document/skin/iphone|ipad 文件夹，命名为 "时间戳_皮肤1.jpg"
 */

#import "UIControllerBase.h"

@protocol UIControllerSetSkinDelegate;

/**
 *  皮肤管理模块
 */
@interface UIControllerSetSkin : UIControllerBase

@property (nonatomic, weak) IBOutlet id<UIControllerSetSkinDelegate> delegate;

@end

@protocol UIControllerSetSkinDelegate <NSObject>

- (void)controllerSetSkinDidChanageSkin:(UIControllerSetSkin *)controllerSetSkin;

@end
