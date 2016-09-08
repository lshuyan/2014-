//
//  UIViewNav.h
//  ChinaBrowser
//
//  Created by David on 14/11/13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewNav : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

+ (instancetype)viewNav;

- (CGRect)resizeWithOrientation:(UIInterfaceOrientation)orientation;

@end
