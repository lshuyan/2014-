//
//  UICellEditHead.m
//  ChinaBrowser
//
//  Created by HHY on 14/11/3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellEditIcon.h"

@implementation UICellEditIcon

- (void)awakeFromNib
{
    // Initialization code
    self.imageIcon.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
