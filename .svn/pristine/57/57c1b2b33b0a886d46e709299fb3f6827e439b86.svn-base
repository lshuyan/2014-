//
//  UIViewSearchPanel.h
//  ChinaBrowser
//
//  Created by David on 14/10/27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewSearchPanelDelegate;

@interface UIViewSearchPanel : UIView

@property (nonatomic, weak) IBOutlet id<UIViewSearchPanelDelegate> delegate;

+ (instancetype)viewFromXib;

- (void)showInView:(UIView *)view completion:(void(^)(void))completion;
- (void)dismiss;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIViewSearchPanelDelegate <NSObject>

- (void)viewSearchPanel:(UIViewSearchPanel *)viewSearchPanel reqLink:(NSString *)link;
- (void)viewSearchPanelWillDismiss:(UIViewSearchPanel *)viewSearchPanel;

@end
