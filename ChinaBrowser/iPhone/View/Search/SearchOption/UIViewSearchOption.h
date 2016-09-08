//
//  UIViewSearchOption.h
//  ChinaBrowser
//
//  Created by David on 14-9-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewSearchOptionDelegate;
@class ModelSearchEngine;

@interface UIViewSearchOption : UIView

@property (nonatomic, weak) id<UIViewSearchOptionDelegate> delegate;

+ (instancetype)viewFromXib;

- (void)showInView:(UIView *)view centerOfDock:(CGPoint)centerOfDock;
- (void)dismiss;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIViewSearchOptionDelegate <NSObject>

- (void)viewSearchOption:(UIViewSearchOption *)viewSearchOption didSelectSearchEngine:(ModelSearchEngine *)searchEngine;

@end
