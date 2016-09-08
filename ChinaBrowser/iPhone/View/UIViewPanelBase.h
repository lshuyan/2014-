//
//  UIViewPanelBase.h
//  ChinaBrowser
//
//  Created by David on 14-9-25.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewPanelBase : UIView

/**
 *  显示面板
 *
 *  @param view         显示在哪个目标视图上
 *  @param contentView  内容视图
 *  @param centerOfDock 停靠的边栏中点
 *  @param dockDirection 停靠的边栏方向
 */
- (void)showInView:(UIView *)view
       contentView:(UIView *)contentView
      centerOfDock:(CGPoint)centerOfDock
     dockDirection:(DockDirection)dockDirection;

/**
 * 消失
 */
- (void)dismiss;

@end
