//
//  UICellUserLogin.m
//  ChinaBrowser
//
//  Created by David on 14/11/8.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellUserLogin.h"

@implementation UICellUserLogin

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _imageViewIcon.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    _imageViewIcon.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
