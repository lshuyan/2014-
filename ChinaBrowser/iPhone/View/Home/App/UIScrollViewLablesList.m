//
//  UIScrollViewLablesList.m
//  ChinaBrowser
//
//  Created by 石显军 on 14/11/11.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIScrollViewLablesList.h"
#import "ModelAppCate.h"

#define kItemTag    (11111)
#define kItemHeight (37)
#define kItemWidth  (70)

@interface UIScrollViewLablesList ()
{
    UIButton *_lastBtn;
}
@property (nonatomic, strong) UIView *itemBgView;
@end

@implementation UIScrollViewLablesList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadSubViews];
}

#pragma mark - Private Method
- (void)loadSubViews
{
    self.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    _itemBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, 70, 37)];
    _itemBgView.backgroundColor = [UIColor colorWithRed:50/255.0 green:132/255.0 blue:247/255.0 alpha:1];
    [self addSubview:_itemBgView];
}

- (void)layoutScrollView
{
    for (UIView *subView in self.subviews) {
        if (subView != _itemBgView) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.lableList.count; i++) {
        ModelAppCate *model = self.lableList[i];
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(0, kItemHeight * i, kItemWidth, kItemHeight)];
        item.tag = kItemTag + i;
        item.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [item setTitle:model.name forState:UIControlStateNormal];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [item setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        if (i == 1) {
            item.selected = YES;
            _lastBtn = item;
        }
        [item addTarget:self action:@selector(chickLableItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
    
    self.contentSize = CGSizeMake(70, 37 * (_lableList.count));
    
    if (_lableList.count>0) {
        if (self.lableListDelegate) {
            self.lableListDelegate(1);
        }
    }
}

#pragma mark - Setter Method
- (void)setLableList:(NSMutableArray *)lableList
{
    if (_lableList != lableList) {
        _lableList = lableList;
        [self layoutScrollView];
    }
}

#pragma mark - Action Method
- (void)chickLableItem:(UIButton *)button
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.itemBgView.frame =CGRectMake(0, kItemHeight * (button.tag - kItemTag), kItemWidth, kItemHeight);
    }];
    
    if (self.lableListDelegate) {
        self.lableListDelegate(button.tag - kItemTag);
    }
    _lastBtn.selected = NO;
    button.selected = YES;
    _lastBtn = button;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
