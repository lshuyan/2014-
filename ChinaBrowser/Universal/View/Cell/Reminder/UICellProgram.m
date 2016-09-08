//
//  UICellProgram.m
//  ChinaBrowser
//
//  Created by David on 14/11/27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellProgram.h"

@implementation UICellProgram

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = bg;
    
    bg = [[UIImageView alloc] initWithFrame:self.bounds];
    bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    bg.image = [[UIImage imageWithBundleFile:@"iPhone/FM/bg_cell_program.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self insertSubview:bg atIndex:0];
    
    self.textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.accessoryType = selected?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

+ (instancetype)cellFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

@end
