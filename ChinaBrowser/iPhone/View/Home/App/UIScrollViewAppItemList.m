//
//  UIScrollViewAppItemList.m
//  ChinaBrowser
//
//  Created by 石显军 on 14/11/17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewAppItemList.h"
#import "UIViewAppItem.h"

#define kItemWidth  (104)
#define kItemHeight (45)
#define kItemY      (8)

@interface UIScrollViewAppItemList ()
{
    NSMutableArray *_arrItem;
}

@end

@implementation UIScrollViewAppItemList
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrItem = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _arrItem = [[NSMutableArray alloc] init];
}

#pragma mark - Setter Method
- (void)setAppList:(NSMutableArray *)appList
{
    if (_appList != appList) {
        _appList = appList;
        [self layoutSelf];
    }
}

#pragma mark - Private Method
- (void)layoutSelf
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [_arrItem removeAllObjects];
    
    int column = self.width/120;
    
    int itemX = (self.width - column*104) / (column+1);
    
    for (int i = 0; i < _appList.count; i++) {
        UIViewAppItem *item = [[[NSBundle mainBundle] loadNibNamed:@"UIViewAppItem" owner:self options:nil] lastObject];
        item.frame = CGRectMake(itemX + i%column*(kItemWidth + itemX), kItemY + i/column*(kItemY + kItemHeight), kItemWidth, kItemHeight);
        item.callbackAddApp = _callbackAddApp;
        item.callbackIsExistApp = _callbackIsExistApp;
        item.callbackCanAddApp = _callbackCanAddApp;
        item.callbackOpen = _callbackOpen;
        item.item = _appList[i];
        [self addSubview:item];
        [_arrItem addObject:item];
    }
    
    NSInteger line = _appList.count%column == 0? (_appList.count / column) : (_appList.count / column + 1);
    
    if ((kItemY + kItemHeight) * line > self.height) {
        self.contentSize = CGSizeMake(self.width, (kItemY + kItemHeight) * line+kItemY);
    }else{
        self.contentSize = CGSizeMake(self.width, self.height+1);
    }
    
}

#pragma mark - Public Method
- (void)layoutScrollViewSubviews
{
    NSInteger column = self.width/120;
    
    NSInteger itemX = (self.width - column*104) / (column+1);
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIViewAppItem *item = self.subviews[i];
        [UIView animateWithDuration:0.4 animations:^{
            item.frame = CGRectMake(itemX + i%column*(kItemWidth + itemX), kItemY + i/column*(kItemY + kItemHeight), kItemWidth, kItemHeight);
        }];
    }
    
    NSInteger line = _appList.count%column == 0? (_appList.count / column) : (_appList.count / column + 1);
    
    if ((kItemY + kItemHeight) * line > self.height) {
        self.contentSize = CGSizeMake(self.width, (kItemY + kItemHeight) * line+kItemY);
    }else{
        self.contentSize = CGSizeMake(self.width, self.height+1);
    }
    
    if (self.width < self.height) {
        [self performSelector:@selector(layoutSelf) withObject:nil afterDelay:0.5];
    }
}
@end