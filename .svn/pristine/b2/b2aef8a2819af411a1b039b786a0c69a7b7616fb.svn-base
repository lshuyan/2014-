//
//  UIViewAppItem.m
//  ChinaBrowser
//
//  Created by 石显军 on 14/11/11.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewAppItem.h"
#import "UIImageView+WebCache.h"
#import "ModelApp.h"
#import "ADOApp.h"

@interface UIViewAppItem ()
{
    // 背景图片
    IBOutlet UIImageView *_bgImageView;
    // 应用图标
    IBOutlet UIImageView *_itemIcon;
    // 应用标题
    IBOutlet UILabel     *_itemTitle;
    // 添加按钮
    IBOutlet UIButton    *_itemBtn;
    
}
@end

@implementation UIViewAppItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _bgImageView.layer.borderColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1].CGColor;
    _bgImageView.layer.borderWidth = 1;
    
    _itemBtn.layer.borderColor = [UIColor colorWithRed:43/255.0 green:132/255.0 blue:59/255.0 alpha:1].CGColor;
    _itemBtn.layer.borderWidth = 1;
    [_itemBtn setTitle:LocalizedString(@"tianjia") forState:UIControlStateNormal];
    [_itemBtn setTitle:LocalizedString(@"dakai") forState:UIControlStateSelected];
}

- (void)layoutSubviews
{
    [_itemIcon setImageWithURL:[NSURL URLWithString:_item.icon] placeholderImage:nil];
    _itemTitle.text = _item.title;
    _itemBtn.selected = _callbackIsExistApp(_item);
    /**
     *    设置选中状态
     */
    if (_itemBtn.selected) {
        [self changeBtnState];
    }
}

#pragma mark - Action Method
- (IBAction)chickAdd:(UIButton *)sender
{
    if (sender.selected) {
        if (_callbackOpen) {
            _callbackOpen(_item);
        }
    }else{
        if (_callbackCanAddApp) {
            if (!_callbackCanAddApp()) {
                [SVProgressHUD showErrorWithStatus:LocalizedString(@"shouyeyingyongshuliangyidadaoshangxian")];
            }
            else {
                _item.userid = [UserManager shareUserManager].currUser.uid;
                _item.lan = [LocalizationUtil currLanguage];
                _item.sortIndex = [ADOApp queryMaxSortIndexWithUserId:_item.userid]+1;
                
                NSInteger pkid = [ADOApp addModel:_item];
                sender.selected = pkid>0?YES:NO;
                if (sender.selected) {
                    _item.pkid = pkid;
                    [self changeBtnState];
                    if (self.callbackAddApp) {
                        self.callbackAddApp(_item);
                    }
                }
            }
        }
    }
}

#pragma mark - Setter Method
- (void)setItem:(ModelApp *)item
{
    if (_item != item) {
        _item = item;
        [self setNeedsLayout];
    }
}

#pragma mark - Private Method
- (void)changeBtnState
{
    if (_itemBtn.selected) {
        _itemBtn.layer.borderColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1].CGColor;
        [_itemBtn setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        [_itemBtn setTitle:LocalizedString(@"dakai") forState:UIControlStateNormal];
    }
}

@end
