//
//  UIViewMenuPage.m
//  ChinaBrowser
//
//  Created by David on 14-9-25.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewMenuPage.h"

@implementation UIViewMenuPage
{
    NSMutableArray *_arrMenuItem;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _arrMenuItem = [NSMutableArray array];
        _rowCount = 2;
        _colCount = 4;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsLayout];
}

- (void)setRowCount:(NSInteger)rowCount
{
    _rowCount = rowCount;
    [self setNeedsLayout];
}

- (void)setColCount:(NSInteger)colCount
{
    _colCount = colCount;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.width<=0 || self.height<=0 || _colCount==0 || _rowCount==0 || _arrMenuItem.count==0) {
        return;
    }
    
    CGFloat itemw = self.width/_colCount;
    CGFloat itemh = self.height/_rowCount;
    
    NSInteger count = _arrMenuItem.count;
    for (NSInteger i=0; i<count; i++) {
        NSInteger col = GetColWithIndexCol(i, _colCount);
        NSInteger row = GetRowWithIndexCol(i, _colCount);
        CGRect rc = CGRectMake(itemw*col, itemh*row, itemw, itemh);
        UIView *item = _arrMenuItem[i];
        
        item.frame = rc;
    }
}

- (void)addMenuItem:(UIView *)menuItem
{
    [self addSubview:menuItem];
    [_arrMenuItem addObject:menuItem];
    
    [self setNeedsLayout];
}

- (void)setArrMenuItem:(NSArray *)arrMenuItem
{
    for (UIView *menuItem in arrMenuItem) {
        [self addSubview:menuItem];
        [_arrMenuItem addObject:menuItem];
    }
    
    [self setNeedsLayout];
}

@end
