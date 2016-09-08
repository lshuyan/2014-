//
//  UICellItemList.m
//  ChinaBrowser
//
//  Created by 石显军 on 14/11/11.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellItemList.h"

@implementation UICellItemList

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    CGContextStrokePath(context);
}

@end
