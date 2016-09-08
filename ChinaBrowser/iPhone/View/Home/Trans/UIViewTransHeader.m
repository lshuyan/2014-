//
//  UIViewTransHeader.m
//  ChinaBrowser
//
//  Created by David on 14-9-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewTransHeader.h"

@implementation UIViewTransHeader
{
    __weak IBOutlet UIImageView *_imageViewIcon;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [UIView animateWithDuration:0.3 animations:^{
        _imageViewIcon.transform = CGAffineTransformMakeRotation(selected?M_PI:0);
    }];
}

- (void)setColorNormal:(UIColor *)colorNormal
{
    _colorNormal = colorNormal;
    self.backgroundColor = _colorNormal;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.colorNormal = [UIColor colorWithWhite:0.95 alpha:1];
    _imageViewIcon.image = [UIImage imageWithBundleFile:@"trans/arrow_bottom.png"];
    _imageViewIcon.contentMode = UIViewContentModeCenter;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    
    CGContextStrokePath(context);
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewTransHeader" owner:nil options:nil][0];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL b = [super beginTrackingWithTouch:touch withEvent:event];
    if (self.enabled) {
        self.backgroundColor = _colorTouch?:[UIColor colorWithWhite:0.9 alpha:1];
    }
    return b;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = _colorNormal?:[UIColor colorWithWhite:0.95 alpha:1];
    } completion:nil];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = _colorNormal?:[UIColor colorWithWhite:0.95 alpha:1];
    } completion:nil];
    
    [super cancelTrackingWithEvent:event];
}

@end
