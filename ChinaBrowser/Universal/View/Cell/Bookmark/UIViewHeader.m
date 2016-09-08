//
//  UIViewHeader.m
//  KTBrowser
//
//  Created by David on 14-3-6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewHeader.h"

#import <QuartzCore/QuartzCore.h>

@interface UIViewHeader ()

- (void)updateMask;

@end

@implementation UIViewHeader
{
    CALayer *_lineT;
    CALayer *_lineB;
    
    UIRectCorner _corner;
    CAShapeLayer *_layerMask;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    _layerMask = [CAShapeLayer layer];
    self.layer.mask = _layerMask;
    
    if (IsiPad) {
        _labelTitle.font    = [UIFont systemFontOfSize:15];
        _labelSubTitle.font = [UIFont systemFontOfSize:14];
    }
    
    _colorNor = [UIColor colorWithWhite:0.99 alpha:0.9];
    _colorSelect = [UIColor colorWithWhite:0.99 alpha:1];
    _colorHighlight  = [UIColor colorWithWhite:0.95 alpha:0.9];
    
    self.backgroundColor = _colorNor;
    _imageViewAccessory.contentMode = UIViewContentModeCenter;
    _imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.layer.masksToBounds=  YES;
    self.clipsToBounds = YES;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite:0.8 alpha:1] CGColor]);
    CGContextSetShouldAntialias(context, NO);
    CGContextSetAllowsAntialiasing(context, NO);
//    CGFloat dash[] = {5, 0.5};//第一个是实线的长度，第2个是空格的长度
//    CGContextSetLineDash(context, 1, dash, 2); //给虚线设置下类型，其中2是dash数组大小，如果想设置个性化的虚线 可以将dash数组扩展下即可
//    
    // 横线
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    
    CGContextStrokePath(context);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
//    if (!_lineT && !_lineB) {
//        _lineT = [CALayer layer];
//        _lineT.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1].CGColor;
//        
//        _lineB = [CALayer layer];
//        _lineB.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
//        
////        [self.layer addSublayer:_lineT];
////        [self.layer addSublayer:_lineB];
//    }
//    
//    _lineT.frame = CGRectMake(0, 0, frame.size.width, 0.5);
//    _lineB.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
    
    // 防止旋转过程中的突变
    self.layer.mask = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateMask) object:nil];
    [self performSelector:@selector(updateMask) withObject:nil afterDelay:0.2];
    
    [self setNeedsDisplay];
}

- (void)setColorHighlight:(UIColor *)colorHighlight
{
    _colorHighlight = colorHighlight;
}

- (void)setColorSelect:(UIColor *)colorSelect
{
    _colorSelect = colorSelect;
    if (self.selected) {
        self.backgroundColor = _colorSelect;
    }
}

- (void)setColorNor:(UIColor *)colorNor
{
    _colorNor = colorNor;
    if (!self.selected && !self.highlighted) {
        self.backgroundColor = _colorNor;
    }
}

- (void)updateMask
{
    if (_corner==0)
    {
        self.layer.mask = nil;
    }
    else {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:_corner cornerRadii:CGSizeMake(4, 4)];
        _layerMask.path = path.CGPath;
        
        self.layer.mask = _layerMask;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected];
//    animated?0.3:0
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (selected) {
            self.backgroundColor = _colorSelect;
            _imageViewAccessory.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else {
            self.backgroundColor = _colorNor;
            _imageViewAccessory.transform = CGAffineTransformIdentity;
        }
        
    } completion:nil];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL b = [super beginTrackingWithTouch:touch withEvent:event];
    if (self.enabled)
    {
        self.backgroundColor = _colorHighlight;
    }
    return b;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.backgroundColor = self.selected?_colorSelect:_colorNor;
    } completion:nil];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.backgroundColor = self.selected?_colorSelect:_colorNor;
    } completion:nil];
    
    [super cancelTrackingWithEvent:event];
}

+ (UIViewHeader *)viewHeaderFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewHeader" owner:nil options:nil][0];
}

- (void)setViewCorner:(UIRectCorner)corner
{
    _corner = corner;
    [self setNeedsLayout];
}

@end
