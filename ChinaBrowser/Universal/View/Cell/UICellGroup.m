//
//  UICellGroup.m
//  ChinaBrowser
//
//  Created by HHY on 14/12/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellGroup.h"

#define kThumbnailLength    78.0f

@implementation UICellGroup

- (void)awakeFromNib {
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellFromXib
{
    return  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)bind:(ALAssetsGroup *)assetsGroup
{
//    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kThumbnailLength;
    
    self.imageViewL.image      = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.labelName.text       = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.labelNumber.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

@end