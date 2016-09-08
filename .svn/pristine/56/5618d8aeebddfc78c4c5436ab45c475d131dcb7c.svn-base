//
//  UIViewBrushSet.h
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@protocol UIViewBrushSetDelegate;

@interface UIViewBrushSet : UIViewPopButtomBase
{
    IBOutlet UIView *_viewWrap;
    IBOutlet UIView *_viewBrush;
    
    IBOutlet UISlider *_slider;

    NSArray *_arrColor;
}


@property (nonatomic, weak) id<UIViewBrushSetDelegate> delegate;

+ (UIViewBrushSet *)viewBrushSetFromXib;

- (void)setColor:(UIColor *)color width:(CGFloat)width btnColorForTag:(NSInteger)tag;

@end

@protocol UIViewBrushSetDelegate <NSObject>

- (void)viewBrushSetLineColor:(UIColor *)lineColor btnColorForTag:(NSInteger)tag;
- (void)viewBrushSetLineWidth:(CGFloat)lineWidth;

@end
