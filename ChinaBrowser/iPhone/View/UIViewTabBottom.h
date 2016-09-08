//
//  UIViewTabBottom.h
//  ChinaBrowser
//
//  Created by David on 14/12/15.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewTabBottom : UIView

@property (nonatomic, strong) void (^callbackNewWindow)(void);
@property (nonatomic, strong) void (^callbackBack)(void);

+ (instancetype)viewFromXib;

- (void)setAllowNew:(BOOL)allowNew;

@end
