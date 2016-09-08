//
//  UIScrollViewMenu.m
//  ChinaBrowser
//
//  Created by David on 14-9-25.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewMenu.h"

@implementation UIScrollViewMenu

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
    NSInteger page = self.contentOffset.x/self.bounds.size.width;
    
    [super setFrame:frame];
    
    NSInteger itemCount = self.subviews.count;
    CGFloat inset = 0, paddingB = 0;
    for (NSInteger i=0; i<itemCount; i++) {
        UIView *viewItem = self.subviews[i];
        CGRect rc = CGRectInset(self.bounds, inset, inset);
        rc.origin.x = self.bounds.size.width*i+inset;
        rc.size.height-=paddingB;
        viewItem.frame = rc;
    }
    
    self.contentSize = CGSizeMake(frame.size.width*itemCount, frame.size.height);
    self.contentOffset = CGPointMake(frame.size.width*page, 0);
    
    [self setNeedsDisplay];
}

@end
