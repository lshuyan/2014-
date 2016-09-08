//
//  UICellNews.m
//  ChinaBrowser
//
//  Created by David on 14-4-28.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellNews.h"

#import <QuartzCore/QuartzCore.h>

@implementation UICellNews

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
    
    _imageViewIcon.contentMode = UIViewContentModeScaleAspectFill;
//    _imageViewIcon.layer.borderWidth = 0.6;
//    _imageViewIcon.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.8].CGColor;
    _imageViewIcon.clipsToBounds = YES;
    
    _labelTitle.textColor =
    _labelSource.textColor =
    _labelDescr.textColor =
    _labelDate.textColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsRead:(BOOL)isRead
{
    _isRead = isRead;
    
    _labelTitle.textColor =
    _labelSource.textColor =
    _labelDescr.textColor =
    _labelDate.textColor = isRead?[UIColor grayColor]:[UIColor blackColor];
}

- (void)setHasImage:(BOOL)hasImage
{
    _hasImage = hasImage;
    
    CGRect rc = _labelTitle.frame;
    if (hasImage) {
        _imageViewIcon.hidden = NO;
        rc.size.width = _imageViewIcon.frame.origin.x-10-rc.origin.x;
    }
    else {
        _imageViewIcon.hidden = YES;
        rc.size.width = self.contentView.bounds.size.width-10-rc.origin.x;
    }
    _labelTitle.frame = rc;
    
    rc = _labelDescr.frame;
    rc.size.width = _labelTitle.frame.size.width;
    _labelDescr.frame = rc;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UICellNews" owner:nil options:nil][0];
}

@end
