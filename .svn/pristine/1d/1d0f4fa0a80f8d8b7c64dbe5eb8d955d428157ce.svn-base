//
//  UIViewBanner.h
//  DailyHeadlines
//
//  Created by David on 2011-12-16.
//  Copyright 2011年 com.veryapps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewBannerDelegate.h"

@interface UIViewBanner : UIView

@property (nonatomic, assign) id<UIViewBannerDelegate> delegate;
@property (nonatomic, assign) BOOL shouldShowCloseBtn;
@property (nonatomic, assign) BOOL shouldShowPageControl;
@property (nonatomic, assign) UIViewContentMode viewContentMode;

- (void)startAutoScroll:(NSTimeInterval)tiScroll;
- (void)stopAutoScroll;

- (void)setArrBanner:(NSArray *)arrBanner;

@end
