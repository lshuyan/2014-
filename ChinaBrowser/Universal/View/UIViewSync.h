//
//  UIViewSync.h
//  ChinaBrowser
//
//  Created by David on 15/1/4.
//  Copyright (c) 2015年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewSync : UIView

/**
 *  同步时间 UNIX时间戳
 */
@property (nonatomic, assign) NSInteger syncTime;

/**
 *  同步类型
 */
@property (nonatomic, assign) SyncDataType syncDataType;

/**
 *  弹出登录窗口的控制器
 */
@property (nonatomic, weak) UIViewController *controllerRoot;

@property (nonatomic, strong) void (^callbackSyncBegin)();
@property (nonatomic, strong) void (^callbackSyncCompletion)();
@property (nonatomic, strong) void (^callbackSyncFail)();

+ (instancetype)viewFromXib;

/**
 *  调整大小，位于指定父视图的底部
 *
 */
- (void)resizeBottomSuperView;

/**
 *  更新用户状态
 */
- (void)updateUserStatus;

@end
