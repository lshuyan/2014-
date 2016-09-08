//
//  UIViewTopBar.h
//  ChinaBrowser
//
//  Created by David on 14-9-1.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//
/*
 1、顶部工具栏(地址栏)
 2、
 */


#import <UIKit/UIKit.h>

#import "UIViewBarEventDelegate.h"
#import "AppLanguageProtocol.h"

/**
 *  顶部栏状态，更具顶部栏状态决定视图布局
 */
typedef NS_ENUM(NSInteger, ViewTopBarStatus) {
    /**
     *  未知的工具栏状态
     */
    ViewTopBarStatusUnknow,

    /**
     *  首页
     */
    ViewTopBarStatusHome,
    /**
     *  网页模式
     */
    ViewTopBarStatusWeb,
    /**
     *  输入聚焦
     */
    ViewTopBarStatusFocus,
    /**
     *  输入状态
     */
    ViewTopBarStatusInput
};

@class ModelSearchEngine;

@interface UIViewTopBar : UIView <AppLanguageProtocol>

@property (nonatomic, assign) IBOutlet id<UIViewBarEventDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *btnGoBack;
@property (nonatomic, weak) IBOutlet UIButton *btnGoForward;
@property (nonatomic, weak) IBOutlet UIButton *btnMenu;
@property (nonatomic, weak) IBOutlet UIButton *btnGoHome;
@property (nonatomic, weak) IBOutlet UIButton *btnWinds;

@property (nonatomic, weak) IBOutlet UIButton *btnRefresh;
@property (nonatomic, weak) IBOutlet UIButton *btnStop;

@property (nonatomic, weak) IBOutlet UIButton *btnCancel;
@property (nonatomic, weak) IBOutlet UIView *viewInput;
@property (nonatomic, weak) IBOutlet UITextField *textField;

/**
 *  多标签数量
 */
@property (nonatomic, assign) NSInteger numberOfWinds;

/**
 *  正在编辑App
 */
@property (nonatomic, assign) BOOL editingApp;

/**
 *  工具栏状态
 */
@property (nonatomic, assign) ViewTopBarStatus viewTopBarStatus;
/**
 *  记录输入状态前的状态，以便取消输入后还原状态
 */
@property (nonatomic, assign) ViewTopBarStatus viewTopBarStatusBeforeInput;

@property (nonatomic, strong) ModelSearchEngine *searchEngine;

/**
 *  支持动画设置标签数量
 *
 *  @param numberOfWinds    标签数量
 *  @param animated 是否动画
 */
- (void)setNumberOfWinds:(NSInteger)numberOfWinds animated:(BOOL)animated;

/**
 *  设置书签按钮图标是否高亮
 *
 *  @param highlighted BOOL 是否高亮
 */
- (void)setBookmarkIconHighlighted:(BOOL)highlighted;

@end
