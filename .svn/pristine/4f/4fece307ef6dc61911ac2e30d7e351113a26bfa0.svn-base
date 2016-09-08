//
//  RotateUtil.h
//  ChinaBrowser
//
//  Created by David on 14-8-30.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  旋转控制类，全App状态机 形式
 */
@interface RotateUtil : NSObject

// 旋转控制相关
//@property (nonatomic, strong) UIViewController *rootController;  // 控制按钮所在的控制器
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, assign, readonly) UIInterfaceOrientationMask interfaceOrientationMask;

/**
 *  旋转锁
 */
@property (nonatomic, assign) BOOL rotateLock;
/**
 *  是否显示旋转锁
 */
@property (nonatomic, assign) BOOL shouldShowRotateLock;

+ (instancetype)shareRotateUtil;

/**
 *  存储当前状态
 */
+ (void)store;
/**
 *  恢复已存储的状态
 */
+ (void)restore;

@end
