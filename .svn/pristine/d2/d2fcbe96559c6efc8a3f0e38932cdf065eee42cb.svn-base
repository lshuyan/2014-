//
//  UIViewDraw.h
//  ChinaBrowser
//
//  Created by David on 14-10-9.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewDraw : UIView

@property (nonatomic, assign) BOOL isClearMode;
@property (nonatomic, assign) CGFloat brushLineWidth;
@property (nonatomic, assign) CGFloat eraserLineWidth;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
//对应颜色按钮的TAG值  , 用作当前颜色按钮变形
@property (nonatomic, assign) NSInteger colorWithBtnTag;

@property (nonatomic, readonly) BOOL canUndo;
@property (nonatomic, readonly) BOOL canRedo;

/**
 *  撤销
 */
- (void)undo;
/**
 *  重做
 */
- (void)redo;
/**
 *  清除
 */
- (void)clear;

@end
