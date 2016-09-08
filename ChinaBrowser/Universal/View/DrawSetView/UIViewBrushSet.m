//
//  UIViewBrushSet.m
//  KTBrowser
//
//  Created by David on 14-2-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewBrushSet.h"
#import "UIColor+Expanded.h"

@interface UIViewBrushSet ()

{
    BOOL _isH;
}
- (void)setup;

@end

@implementation UIViewBrushSet
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
    

}

-(void)setup
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self setup];
}

+ (UIViewBrushSet *)viewBrushSetFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"UIViewBrushSet" owner:self options:nil] lastObject];
}

//设置画笔颜色
- (void)setColor:(UIColor *)color width:(CGFloat)width btnColorForTag:(NSInteger)tag
{
    _slider.value = width;
    
    CGRect rc = _viewBrush.bounds;
    rc.size.width = rc.size.height = _slider.value;
    _viewBrush.bounds = rc;
    _viewBrush.layer.cornerRadius = rc.size.width/2;
    
    _viewBrush.backgroundColor = color;
    

    for (UIView *subView in self.viewContent.subviews) {
        if ([subView isMemberOfClass:[UIButton class]]) {
            if (subView.tag == tag) {
                subView.transform = CGAffineTransformMakeScale(1.4, 1.4);
            }
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.viewContent.frame, touchPoint)) {
        [self animationRemoveFormSuperview];
    }
}

-(void)animationRemoveFormSuperview
{

    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect =  self.viewContent.frame;
        rect.origin.y = self.frame.size.height;
        self.viewContent.frame = rect;
        
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.01];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

//画笔颜色
-(void)onClickColorBtn:(UIButton *)btn
{
    _viewBrush.backgroundColor = btn.backgroundColor;
    //先把所有but 恢复正常大小
    [self.viewContent.subviews enumerateObjectsUsingBlock:^(UIView* subView, NSUInteger idx, BOOL *stop) {
      if ([subView isMemberOfClass:[UIButton class]]) {
          [UIView animateWithDuration:0.1 animations:^{
              subView.transform = CGAffineTransformMakeScale(1, 1);
          }];
          
        }
    }];
    //把点击的按钮 放大
    [UIView animateWithDuration:0.1 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.4, 1.4);
    }];

    [_delegate viewBrushSetLineColor:btn.backgroundColor btnColorForTag:btn.tag];
}

//拖拉滑动条
-(void)sliderValuechanged:(UISlider *)sender
{
    CGRect rc = _viewBrush.bounds;
    rc.size.width = rc.size.height = sender.value;
    _viewBrush.bounds = rc;
    _viewBrush.layer.cornerRadius = rc.size.width/2;
    
    if ([_delegate respondsToSelector:@selector(viewBrushSetLineWidth:)]) {
        [_delegate viewBrushSetLineWidth:_slider.value];
    }
}

/**
 *  根据传入VIew  显示大小
 *
 */
- (void)showInView:(UIView *)view completion:(void (^)())completion
{
    CGRect rect = view.frame;
    
    self.frame = rect;
    
    //背景添加手势
    self.userInteractionEnabled = YES;
    
    _arrColor = @[@"#FFFFFF", @"#FFFF00",
                  @"#FF00FF", @"#00FFFF",
                  @"#FF0000", @"#00FF00",
                  @"#0000FF", @"#000000",
                  @"#258B2A", @"#7B4117",
                  @"#5E5E5E", @"#BBBBBB"];
    _viewWrap.layer.cornerRadius  = _viewWrap.bounds.size.width/2;
    _viewBrush.layer.cornerRadius = _viewBrush.bounds.size.width/2;
    
    _viewWrap.layer.borderWidth  =
    _viewBrush.layer.borderWidth = 0.5;
    _viewWrap.layer.borderColor  =
    _viewBrush.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.viewContent.subviews enumerateObjectsUsingBlock:^(UIView* subView, NSUInteger idx, BOOL *stop) {
        if ([subView isKindOfClass:[UISlider class]]) {
            [(UISlider *)subView setMinimumValue:1];
            [(UISlider *)subView setMaximumValue:MIN(_viewWrap.bounds.size.height, _viewWrap.bounds.size.width)];
            [(UISlider *)subView addTarget:self action:@selector(sliderValuechanged:) forControlEvents:UIControlEventValueChanged];
            
        }
        
        else if ([subView isMemberOfClass:[UIButton class]]) {
            subView.layer.borderWidth = _viewWrap.layer.borderWidth;
            subView.layer.borderColor = _viewWrap.layer.borderColor;
            
            subView.backgroundColor = [UIColor colorWithHexString:_arrColor[subView.tag]];
            [(UIButton *)subView addTarget:self action:@selector(onClickColorBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
    
    rect = self.viewContent.frame;
    rect.origin.y = view.frame.size.height;
    rect.size.width = view.frame.size.width;

    
    if(view.width>view.height)
    {
        float i = 0;
        float spacing = (self.bounds.size.width-30*12)*1.0/13;
        
        for (UIView *subView in self.viewContent.subviews) {
            if ([subView isMemberOfClass:[UIButton class]]) {
                UIButton *but = (UIButton *)subView;
                but.frame = CGRectMake(spacing+(30+spacing)*1.0*i,62,30,30);
                i++;
            }
        }
        rect.size.height = 62 + 30 + 20;
        
    }
    self.viewContent.frame = rect;
    self.viewContent.userInteractionEnabled = YES;
    //添加动画效果

    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect =  self.viewContent.frame;
        rect.origin.y = view.frame.size.height-rect.size.height;
        self.viewContent.frame = rect;
        
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];;
    }];
    
    
}


@end