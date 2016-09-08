//
//  UIControlItemApp.h
//  ChinaBrowser
//
//  Created by David on 14/11/3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControlItem.h"

@protocol UIControlItemAppDelegate;

@interface UIControlItemApp : UIControlItem

@property (nonatomic, weak) IBOutlet id<UIControlItemAppDelegate> delegate;

@property (nonatomic, assign) BOOL allowEdit;
@property (nonatomic, assign) BOOL edit;

@property (nonatomic, assign) UIBorder border;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

/**
 *  正字做动画，期间不允许交换位置
 */
@property (nonatomic, assign) BOOL animating;

@end

@protocol UIControlItemAppDelegate <NSObject>

- (void)controlItemAppDidBeginDrag:(UIControlItemApp *)controlItemApp;
- (void)controlItemAppMoving:(UIControlItemApp *)controlItemApp;
- (void)controlItemAppDidEndDrag:(UIControlItemApp *)controlItemApp;

- (void)controlItemAppWillEdit:(UIControlItemApp *)controlItemApp;
- (void)controlItemAppWillDelete:(UIControlItemApp *)controlItemApp;

@end
