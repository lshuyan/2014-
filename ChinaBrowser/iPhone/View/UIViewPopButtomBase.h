//
//  UIViewPopButtomBase.h
//  ChinaBrowser
//
//  Created by David on 14/11/7.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @Author David, 14-11-07 14:11:14
 *
 *  底部弹出的视图基类
 */
@interface UIViewPopButtomBase : UIView

@property (nonatomic, weak) IBOutlet UIView *viewContent;

@property (nonatomic, weak) IBOutlet UIView *viewTop;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnRight;

@property (nonatomic, weak) IBOutlet UIView *viewBottom;


+ (instancetype)viewFromXib;

- (void)showInView:(UIView *)view completion:(void (^)())completion;
- (void)dismissWithCompletion:(void (^)())completion;

- (void)onTouchOk;

@end
