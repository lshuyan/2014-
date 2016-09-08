//
//  UIViewFindInWebPage.h
//  ChinaBrowser
//
//  Created by David on 14/11/14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewFindInWebPageDelegate;

@interface UIViewFindInWebPage : UIView

@property (nonatomic, weak) id<UIViewFindInWebPageDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *btnPrev;
@property (nonatomic, weak) IBOutlet UIButton *btnNext;
@property (nonatomic, weak) IBOutlet UILabel *labelIndexTotal;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger currIndex;

+ (instancetype)viewFromXib;

- (void)showInView:(UIView *)view completion:(void(^)())completion;
- (void)dismissWithCompletion:(void(^)())completion;

@end

@protocol UIViewFindInWebPageDelegate <NSObject>

- (void)viewFindInWebPageDidBegin:(UIViewFindInWebPage *)viewFindInWebPage;
- (void)viewFindInWebPageDidEnd:(UIViewFindInWebPage *)viewFindInWebPage;
- (void)viewFindInWebPage:(UIViewFindInWebPage *)viewFindInWebPage findWithKeyword:(NSString *)keyword;
- (void)viewFindInWebPageFindPrev:(UIViewFindInWebPage *)viewFindInWebPage;
- (void)viewFindInWebPageFindNext:(UIViewFindInWebPage *)viewFindInWebPage;

@end
