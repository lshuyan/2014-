//
//  UICellSearchOption.m
//  ChinaBrowser
//
//  Created by David on 14-9-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellSearchOption.h"

@implementation UICellSearchOption

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    /*
    CAShapeLayer *layerMask = [CAShapeLayer layer];
    layerMask.frame = _imageViewIcon.bounds;
    layerMask.path = [UIBezierPath bezierPathWithRoundedRect:layerMask.bounds cornerRadius:_imageViewIcon.width/2].CGPath;
    _imageViewIcon.layer.mask = layerMask;
     */
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:0.9].CGColor);
    
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UICellSearchOption" owner:nil options:nil][0];
}

@end
