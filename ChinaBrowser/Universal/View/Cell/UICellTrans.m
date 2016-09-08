//
//  UICellTrans.m
//  ChinaBrowser
//
//  Created by David on 14-9-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellTrans.h"

@implementation UICellTrans

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UICellTrans" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.selectedBackgroundView = view;
    
    [_btnPlaySound setImage:[UIImage imageWithBundleFile:@"trans/sound.png"] forState:UIControlStateNormal];
    _btnPlaySound.imageView.contentMode = UIViewContentModeCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
