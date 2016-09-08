//
//  UIView+ViewController.m
//  WXWeibo
//
//  Created by elite on 14-4-12.
//  Copyright (c) 2014年 无限互联3G学院 www.iphonetrain.com. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController
{
    // 下一个响应者
    id next = [self nextResponder];
    
    while (next) {
        
        next = [next nextResponder];
        
        // 当下一个响应者派生自ViewController
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        
    }
    
    return nil;
}

@end
