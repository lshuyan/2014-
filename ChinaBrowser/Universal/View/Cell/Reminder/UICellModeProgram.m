//
//  UICellModeProgram.m
//  ChinaBrowser
//
//  Created by David on 14/11/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellModeProgram.h"

@implementation UICellModeProgram
{
    __weak IBOutlet UIImageView *_imageViewTime;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    _imageViewTime.image = [UIImage imageWithBundleFile:@"iPhone/FM/time.png"];
    
    _labelTitle.textColor =
    _labelRepeat.textColor = [UIColor darkGrayColor];
    
    UIView *bgSelect = [[UIView alloc] init];
    bgSelect.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.selectedBackgroundView = bgSelect;
}

+ (instancetype)cellFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
