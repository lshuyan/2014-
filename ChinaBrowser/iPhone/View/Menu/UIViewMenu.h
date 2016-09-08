//
//  UIViewMenu.h
//  ChinaBrowser
//
//  Created by David on 14-9-25.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIControlItem.h"

@protocol UIViewMenuDelegate;

@interface UIViewMenu : UIView

@property (nonatomic, weak) id<UIViewMenuDelegate> delegate;

/**
 *  以下三个是设置 enable 状态区分，其中 viewMenuItemBookmark 的状态为：书签存在为 disable，不存在为 enable
 */
@property (nonatomic, weak) UIControlItem *viewMenuItemBookmark;
@property (nonatomic, weak) UIControlItem *viewMenuItemRefresh;
@property (nonatomic, weak) UIControlItem *viewMenuItemFindInPage;

/**
 *  以下三个是设置 select 状态区分
 */
@property (nonatomic, weak) UIControlItem *viewMenuItemNoImageMode;
@property (nonatomic, weak) UIControlItem *viewMenuItemFullscreen;
@property (nonatomic, weak) UIControlItem *viewMenuItemNoSaveHistory;

+ (instancetype)viewFromXib;

/**
 *  设置浏览器模式标识，YES为浏览器模式，跟浏览器相关的菜单项随之 启用，否则 禁用；
 *
 *  @param browserMode 是否浏览器模式
 */
- (void)setBrowserMode:(BOOL)browserMode;

/**
 *  设置书签菜单项是否启用
 *
 *  @param enable 是否启用
 */
- (void)setBookmarkItemEnable:(BOOL)enable;

- (void)showInView:(UIView *)view centerOfDock:(CGPoint)centerOfDock dockDirection:(DockDirection)dockDirection;
- (void)dismiss;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIViewMenuDelegate <NSObject>

- (void)viewMenu:(UIViewMenu *)viewMenu seletedMenuItem:(MenuItem)menuItem;

@end
