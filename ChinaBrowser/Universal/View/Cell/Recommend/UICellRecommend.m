//
//  UICellRecommend.m
//  ChinaBrowser
//
//  Created by David on 14/11/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellRecommend.h"

@implementation UICellRecommend

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UICellRecommend" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    // Initialization code

    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = [UIBezierPath bezierPathWithRoundedRect:_imageViewIcon.bounds cornerRadius:10].CGPath;
    
    _imageViewIcon.layer.mask = mask;
    
    [self setPlaying:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlaying:(BOOL)playing
{
    if (playing) {
        [_btnPlay setImage:[UIImage imageWithBundleFile:@"iPhone/Home/cri/stop.png"] forState:UIControlStateNormal];
    }
    else {
        [_btnPlay setImage:[UIImage imageWithBundleFile:@"iPhone/Home/cri/play.png"] forState:UIControlStateNormal];
    }
}

@end
