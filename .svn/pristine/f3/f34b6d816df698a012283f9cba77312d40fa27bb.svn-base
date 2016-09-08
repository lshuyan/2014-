//
//  UIViewPreviewTab.h
//  Browser-wzdh
//
//  Created by David on 14-5-30.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewPreviewTabDelegate;

@interface UIViewPreviewTab : UIControl

@property (nonatomic, weak) IBOutlet id<UIViewPreviewTabDelegate> delegate;

@property (nonatomic, strong, readonly) UILabel *labelTitle;
@property (nonatomic, strong, readonly) UIView *viewPreview;

+ (instancetype)viewPreviewTabWithView:(UIView *)view scale:(CGFloat)scale;
+ (instancetype)viewPreviewTabWithView:(UIView *)view;

@end

@protocol UIViewPreviewTabDelegate <NSObject>

- (void)viewPreviewTabWillSelect:(UIViewPreviewTab *)viewPreviewTab;
- (void)viewPreviewTabWillRemove:(UIViewPreviewTab *)viewPreviewTab;
- (void)viewPreviewTabWillBeginDragY:(UIViewPreviewTab *)viewPreviewTab;
- (void)viewPreviewTabWillEndDragY:(UIViewPreviewTab *)viewPreviewTab;

@end
