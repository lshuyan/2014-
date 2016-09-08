//
//  UIViewTravelItem.m
//  ChinaBrowser
//
//  Created by David on 14-9-18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewTravelItem.h"


@implementation UILabelGradient

- (void)setText:(NSString *)text
{
    [super setText:[text stringByAppendingString:@"  \0"]];
    self.shadowColor = [UIColor blackColor];
    self.shadowOffset = CGSizeMake(0, 1);
}

- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    CGSize size = [self.text sizeWithFont:self.font];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat colors[] = {
        0, 0, 0, 0.6,
        0, 0, 0, 0
    };
    CGFloat localtions[] = {0, 1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, localtions, 2);
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(self.bounds.size.width, 0),
                                CGPointMake(self.bounds.size.width-size.width-20, 0),
                                kCGGradientDrawsAfterEndLocation);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    [super drawRect:rect];
}

@end

@implementation UIViewTravelItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [_labelTitle setNeedsDisplay];
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    [_labelTitle setNeedsDisplay];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    CGSize size = [_labelTitle.text sizeWithFont:_labelTitle.font];
//    size.height = _labelTitle.bounds.size.height;
//    size.width+=10;
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGFloat colors[] = {
//        0, 0, 0, 0.5,
//        0, 0, 0, 0
//    };
//    CGFloat localtions[] = {0, 1};
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, localtions, 2);
//    CGContextDrawLinearGradient(context,
//                                gradient,
//                                CGPointMake(_labelTitle.frame.origin.x+_labelTitle.bounds.size.width, _labelTitle.frame.origin.y),
//                                CGPointMake(_labelTitle.frame.origin.x+_labelTitle.bounds.size.width-size.width, _labelTitle.frame.origin.y),
//                                kCGGradientDrawsAfterEndLocation);
//    
//    CGColorSpaceRelease(colorSpace);
//    CGGradientRelease(gradient);
//}


+ (UIViewTravelItem *)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewTravelItem" owner:nil options:nil][0];
}


@end
