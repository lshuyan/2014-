//
//  UICellHead.m
//  ChinaBrowser
//
//  Created by HHY on 14/10/31.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellHead.h"

@implementation UICellHead

- (void)awakeFromNib
{
    _imageViewIcon.layer.borderWidth = 0.5;
    _imageViewIcon.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    
    [self.btnSynchro.layer setCornerRadius:5];
    [self.btnSynchro.layer setMasksToBounds:YES];
    [self.btnSynchro setTitle:LocalizedString(@"tongbu") forState:UIControlStateNormal];
    [self.btnSynchro setBackgroundImage:[[UIImage imageWithBundleFile:@"iPhone/User/log_in_1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    [self.btnSynchro setBackgroundImage:[[UIImage imageWithBundleFile:@"iPhone/User/log_in_0.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateHighlighted];
//    [self.imageViewSync setImage:[UIImage imageWithBundleFile:@"iPhone/App/refresh.png"]];
//    [self.imageViewSync removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
