//
//  UIViewSectionHeader.m
//  ChinaBrowser
//
//  Created by David on 14/11/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSectionHeader.h"

@implementation UIViewSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _labelTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.textColor = [UIColor darkGrayColor];
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_labelTitle];
        self.clipsToBounds = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, NO);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    
    CGContextStrokePath(context);
}

@end
