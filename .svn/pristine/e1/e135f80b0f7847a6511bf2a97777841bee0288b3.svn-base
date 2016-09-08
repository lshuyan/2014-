//
//  UICellDesktopStyle.m
//  ChinaBrowser
//
//  Created by David on 14/10/31.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellDesktopStyle.h"

@implementation UICellDesktopStyle

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
    _labelTitle.highlightedTextColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    _imageViewIcon.highlighted = UITableViewCellAccessoryCheckmark==accessoryType;
    _labelTitle.highlighted = UITableViewCellAccessoryCheckmark==accessoryType;
}

@end
