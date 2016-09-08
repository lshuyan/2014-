//
//  UICellSelectionFolder.m
//  ChinaBrowser
//
//  Created by HHY on 14/11/13.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UICellBookmarkHisoty.h"
#define kWidthDefault 269;
#define kWidthEidt 190;

@implementation UICellBookmarkHisoty

- (void)awakeFromNib
{
    self.cellSeparatorStyle = CellSeparatorStyleNone;
    _imageViewLeftIcon.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, NO);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    float x;
    if (self.cellSeparatorStyle == CellSeparatorStyleFill) {
        x=0;
    }
    else if (self.cellSeparatorStyle == CellSeparatorStyleFolder) {
        x = self.labelFolderTitle.frame.origin.x;
    }
    else
    {
        x = self.labelBookmarkTitle.frame.origin.x;
    }

    
    CGContextMoveToPoint(context, x, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    CGContextStrokePath(context);
}

////编辑 or 非编辑状态
//- (void)willTransitionToState:(UITableViewCellStateMask)state NS_AVAILABLE_IOS(3_0)
//{
//    [super willTransitionToState:state];
//
//}

- (void)setCellStyle:(CellStyle)cellStyle
{
    _cellStyle = cellStyle;
    CGRect rc = self.labelBookmarkTitle.frame;
    if (cellStyle == CellStyleNone) {
        rc.origin.y = 1;
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.labelBookmarkDetail.hidden = NO;
        self.labelBookmarkTitle.frame = rc;
        
    }else{
        
        rc.origin.y = 9;
        self.imageViewLeftIcon.image = [UIImage imageWithBundleFile:@"iPhone/App/folder.png"];
        self.labelBookmarkDetail.hidden = YES;
        self.labelBookmarkTitle.center = CGPointMake(self.labelBookmarkTitle.center.x, self.contentView.center.y);
    }
    
}


@end
