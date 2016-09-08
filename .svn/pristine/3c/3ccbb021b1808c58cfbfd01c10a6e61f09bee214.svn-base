//
//  UIViewTopBar.m
//  ChinaBrowser
//
//  Created by David on 14-9-1.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewTopBar.h"

#import "ModelSearchEngine.h"
#import "UIButton+WebCache.h"

@interface UIViewTopBar () <UITextFieldDelegate>

@end

@implementation UIViewTopBar
{
    UILabel *_labelNumber;
    
    UIImageView *_leftViewSearchIcon;
    UIView *_leftViewSearchOption;
    UIView *_leftViewBookmark;
    UIButton *_btnQRCode;
    
    UIButton *_btnBookmark;
    UIButton *_btnSearchOption;
    UIButton *_btnSearchArrow;
    
    UIView *_viewAppEditOverLayer;
}

#pragma mark - property
- (void)setEditingApp:(BOOL)editingApp
{
    _editingApp = editingApp;
    
    if (_editingApp) {
        self.userInteractionEnabled = NO;
        _viewAppEditOverLayer = [[UIView alloc] initWithFrame:self.bounds];
        _viewAppEditOverLayer.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _viewAppEditOverLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self addSubview:_viewAppEditOverLayer];
        [UIView animateWithDuration:0.35 animations:^{
            _viewAppEditOverLayer.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        }];
    }
    else {
        [UIView animateWithDuration:0.35 animations:^{
            _viewAppEditOverLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        } completion:^(BOOL finished) {
            [_viewAppEditOverLayer removeFromSuperview];
            _viewAppEditOverLayer = nil;
            self.userInteractionEnabled = YES;
        }];
    }
}

- (void)setNumberOfWinds:(NSInteger)numberOfWinds
{
    [self setNumberOfWinds:numberOfWinds animated:YES];
}

- (void)setNumberOfWinds:(NSInteger)numberOfWinds animated:(BOOL)animated
{
    if (animated) {
        CATransition *anim = [CATransition animation];
        anim.type = kCATransitionPush;
        if (numberOfWinds>_numberOfWinds) {
            // 增加
            anim.subtype = kCATransitionFromTop;
        }
        else {
            // 减少
            anim.subtype = kCATransitionFromBottom;
        }
        anim.duration = 0.25;
        anim.fillMode = kCAFillModeForwards;
        [_labelNumber.layer addAnimation:anim forKey:@"moveIn"];
        
        _numberOfWinds = numberOfWinds;
        _labelNumber.text = [@(_numberOfWinds) stringValue];
    }
    else {
        _numberOfWinds = numberOfWinds;
        _labelNumber.text = [@(_numberOfWinds) stringValue];
    }
}

- (void)setViewTopBarStatus:(ViewTopBarStatus)viewTopBarStatus
{
    [self setViewTopBarStatus:viewTopBarStatus animated:YES];
}

- (void)setViewTopBarStatus:(ViewTopBarStatus)viewTopBarStatus animated:(BOOL)aniamted
{
    if (viewTopBarStatus==_viewTopBarStatus) return;
    
    if (viewTopBarStatus==ViewTopBarStatusInput) {
        if (_viewTopBarStatus!=ViewTopBarStatusFocus) {
            _viewTopBarStatusBeforeInput = _viewTopBarStatus;
        }
    }
    
    _viewTopBarStatus = viewTopBarStatus;
    
    if (aniamted) {
        [UIView animateWithDuration:0.3 animations:^{
            [self resize];
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [self resize];
    }
}

#pragma mark - super methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_btnWinds addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    
    CGRect rc = _btnGoBack.bounds;
    _leftViewSearchIcon = [[UIImageView alloc] initWithFrame:rc];
    _leftViewSearchIcon.contentMode = UIViewContentModeCenter;
    
    _btnRefresh.hidden =
    _btnStop.hidden = YES;
    
    rc.size.width+=5;
    _leftViewBookmark = [[UIView alloc] initWithFrame:rc];
    {
        _btnBookmark = [[UIButton alloc] initWithFrame:_leftViewSearchIcon.bounds];
        [_btnBookmark addTarget:self action:@selector(onTouchBarItem:) forControlEvents:UIControlEventTouchUpInside];
        [_leftViewBookmark addSubview:_btnBookmark];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(_leftViewBookmark.width-6, 7, 1, _leftViewBookmark.height-14);
        layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [_leftViewBookmark.layer addSublayer:layer];
    }
    
    rc.size.width = _btnGoBack.width+15;
    _leftViewSearchOption = [[UIView alloc] initWithFrame:rc];
    {
        _btnSearchOption = [[UIButton alloc] initWithFrame:_leftViewSearchIcon.bounds];
        [_btnSearchOption addTarget:self action:@selector(onTouchBarItem:) forControlEvents:UIControlEventTouchUpInside];
        [_leftViewSearchOption addSubview:_btnSearchOption];
        
        rc.origin.x = _btnSearchOption.right;
        rc.size.width = 12;
        _btnSearchArrow = [[UIButton alloc] initWithFrame:rc];
        [_btnSearchArrow addTarget:self action:@selector(onTouchBarItem:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSearchArrow setImage:[UIImage imageWithBundleFile:@"iPhone/Search/sanjiao.png"] forState:UIControlStateNormal];
        [_leftViewSearchOption addSubview:_btnSearchArrow];
        
        [_btnSearchArrow addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        [_btnSearchOption addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    rc = _leftViewSearchIcon.frame;
    {
        _btnQRCode = [[UIButton alloc] initWithFrame:rc];
        [_btnQRCode addTarget:self action:@selector(onTouchBarItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 14, 14)];
    {
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;
        view.userInteractionEnabled = NO;
        _labelNumber = [[UILabel alloc] initWithFrame:view.bounds];
        _labelNumber.font = [UIFont systemFontOfSize:10];
        _labelNumber.textAlignment = NSTextAlignmentCenter;
        _labelNumber.backgroundColor = [UIColor clearColor];
        [_btnWinds addSubview:view];
        [view addSubview:_labelNumber];
        
        _labelNumber.textColor = [UIColor colorWithWhite:0.85 alpha:1];
        _labelNumber.highlightedTextColor = [UIColor colorWithWhite:0.6 alpha:1];
    }

    [self updateByLanguage];
    
    [_btnBookmark setImage:[UIImage imageWithBundleFile:@"iPhone/Home/collect_0.png"] forState:UIControlStateNormal];
    [_btnBookmark setImage:[UIImage imageWithBundleFile:@"iPhone/Home/collect_1.png"] forState:UIControlStateHighlighted];
    [_btnBookmark setImage:[UIImage imageWithBundleFile:@"iPhone/Home/collect_2.png"] forState:UIControlStateSelected];
    
    NSArray *arrBtn = @[_btnGoBack, _btnGoForward, _btnMenu, _btnWinds, _btnGoHome, _btnQRCode, _btnRefresh, _btnStop];
    NSArray *arrImg = @[@"t_arrow_left", @"t_arrow_right", @"t_list", @"t_multi_label", @"t_home", @"qr_code", @"t_refresh", @"t_stop"];
    [arrBtn enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn setImage:[UIImage imageWithBundleFile:[NSString stringWithFormat:@"iPhone/Home/%@_0.png", arrImg[idx]]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageWithBundleFile:[NSString stringWithFormat:@"iPhone/Home/%@_1.png", arrImg[idx]]] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageWithBundleFile:[NSString stringWithFormat:@"iPhone/Home/%@_1.png", arrImg[idx]]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageWithBundleFile:[NSString stringWithFormat:@"iPhone/Home/%@_3.png", arrImg[idx]]] forState:UIControlStateDisabled];
    }];
    _leftViewSearchIcon.image = [UIImage imageWithBundleFile:@"iPhone/Home/search_0.png"];
    
//    _viewInput.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
//    _viewInput.layer.borderWidth = 0.6;
    _viewInput.layer.cornerRadius = 6;
    
    // TODO:设置背景
    self.backgroundColor = kBgColorNavHome;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setViewTopBarStatus:ViewTopBarStatusHome animated:NO];
    });
}

- (void)dealloc
{
    [_btnWinds removeObserver:self forKeyPath:@"highlighted"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"highlighted"]) {
        BOOL highlighted = [change[NSKeyValueChangeNewKey] boolValue];
        if (object==_btnWinds) {
            _labelNumber.highlighted = highlighted;
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    _DEBUG_LOG(@"%s", __FUNCTION__);
    [super setFrame:frame];
    [self resize];
}

- (void)resize
{
    CGRect rc = CGRectZero;
    CGFloat spacex = 10;
    
    if (IsPortrait) {
        switch (_viewTopBarStatus) {
            case ViewTopBarStatusHome:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
                _textField.textColor = [UIColor whiteColor];
                [_textField setValue:[UIColor colorWithWhite:0.9 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha =
                _btnCancel.alpha = 0;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 0;
                
                // 设置frame
                rc = _viewInput.frame;
                rc.origin.x = spacex;
                rc.size.width = self.width-rc.origin.x*2;
                _viewInput.frame = rc;
                
                rc = _btnCancel.frame;
                rc.origin.x = self.width;
                _btnCancel.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewSearchIcon;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = _btnQRCode;
                _textField.rightViewMode = UITextFieldViewModeAlways;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
            }break;
            case ViewTopBarStatusWeb:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                _textField.textColor = [UIColor blackColor];
                [_textField setValue:[UIColor colorWithWhite:0.35 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha =
                _btnCancel.alpha = 0;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 1;
                
                
                // 设置frame
                rc = _btnRefresh.frame;
                rc.origin.x = self.width-rc.size.width-spacex*2;
                _btnRefresh.frame =
                _btnStop.frame = rc;
                
                rc = _viewInput.frame;
                rc.origin.x = spacex;
                rc.size.width = _btnRefresh.left-rc.origin.x-spacex;
                _viewInput.frame = rc;
                
                rc = _btnCancel.frame;
                rc.origin.x = self.width;
                _btnCancel.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewBookmark;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = nil;
                _textField.rightViewMode = UITextFieldViewModeNever;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
            }break;
            case ViewTopBarStatusFocus:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                _textField.textColor = [UIColor blackColor];
                [_textField setValue:[UIColor colorWithWhite:0.35 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha =
                _btnCancel.alpha = 0;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 0;
                
                // 设置frame
                rc = _btnCancel.frame;
                rc.origin.x = self.width;
                _btnCancel.frame = rc;
                
                rc = _viewInput.frame;
                rc.origin.x = spacex;
                rc.size.width = self.width-rc.origin.x-spacex;
                _viewInput.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewSearchOption;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = nil;
                _textField.rightViewMode = UITextFieldViewModeNever;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            }break;
            case ViewTopBarStatusInput:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                _textField.textColor = [UIColor blackColor];
                [_textField setValue:[UIColor colorWithWhite:0.35 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha = 0;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 0;
                
                _btnCancel.alpha = 1;
                
                // 设置frame
                rc = _btnCancel.frame;
                rc.origin.x = self.width-rc.size.width-spacex;
                _btnCancel.frame = rc;
                
                rc = _viewInput.frame;
                rc.origin.x = spacex;
                rc.size.width = _btnCancel.left-rc.origin.x-spacex;
                _viewInput.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewSearchOption;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = nil;
                _textField.rightViewMode = UITextFieldViewModeNever;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
            }break;
            default:
                break;
        }
    }
    else {
        switch (_viewTopBarStatus) {
            case ViewTopBarStatusHome:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
                _textField.textColor = [UIColor whiteColor];
                [_textField setValue:[UIColor colorWithWhite:0.9 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha = 1;

                _btnCancel.alpha = 0;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 0;
                
                // 设置frame
                rc = _btnGoBack.frame;
                rc.origin.x = spacex;
                _btnGoBack.frame = rc;
                
                rc = _btnGoForward.frame;
                rc.origin.x = _btnGoBack.right+spacex;
                _btnGoForward.frame = rc;
                
                rc = _btnWinds.frame;
                rc.origin.x = self.width-rc.size.width-spacex;
                _btnWinds.frame = rc;
                
                rc = _btnGoHome.frame;
                rc.origin.x = _btnWinds.left-rc.size.width-spacex;
                _btnGoHome.frame = rc;
                
                rc = _btnMenu.frame;
                rc.origin.x = _btnGoHome.left-rc.size.width-spacex;
                _btnMenu.frame = rc;
                
                rc = _viewInput.frame;
                rc.origin.x = _btnGoForward.right+spacex;
                rc.size.width = _btnMenu.left-rc.origin.x-spacex;
                _viewInput.frame = rc;
                
                rc = _btnCancel.frame;
                rc.origin.x = self.width;
                _btnCancel.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewSearchIcon;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = _btnQRCode;
                _textField.rightViewMode = UITextFieldViewModeAlways;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
            }break;
            case ViewTopBarStatusWeb:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                _textField.textColor = [UIColor blackColor];
                [_textField setValue:[UIColor colorWithWhite:0.35 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha = 1;
                
                _btnCancel.alpha = 0;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 1;
                
                // 设置frame
                rc = _btnGoBack.frame;
                rc.origin.x = spacex;
                _btnGoBack.frame = rc;
                
                rc = _btnGoForward.frame;
                rc.origin.x = _btnGoBack.right+spacex;
                _btnGoForward.frame = rc;
                
                rc = _btnWinds.frame;
                rc.origin.x = self.width-rc.size.width-spacex;
                _btnWinds.frame = rc;
                
                rc = _btnGoHome.frame;
                rc.origin.x = _btnWinds.left-rc.size.width-spacex;
                _btnGoHome.frame = rc;
                
                rc = _btnMenu.frame;
                rc.origin.x = _btnGoHome.left-rc.size.width-spacex;
                _btnMenu.frame = rc;
                
                rc = _btnRefresh.frame;
                rc.origin.x = _btnMenu.left-rc.size.width-spacex;
                _btnRefresh.frame =
                _btnStop.frame = rc;
                
                rc = _viewInput.frame;
                rc.origin.x = _btnGoForward.right+spacex;
                rc.size.width = _btnRefresh.left-rc.origin.x-spacex;
                _viewInput.frame = rc;
                
                rc = _btnCancel.frame;
                rc.origin.x = self.width;
                _btnCancel.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewBookmark;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = nil;
                _textField.rightViewMode = UITextFieldViewModeNever;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
            }break;
            case ViewTopBarStatusFocus:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                _textField.textColor = [UIColor blackColor];
                [_textField setValue:[UIColor colorWithWhite:0.35 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha =
                _btnCancel.alpha = 1;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 0;
                
                // 设置frame
                rc = _btnCancel.frame;
                rc.origin.x = self.width;
                _btnCancel.frame = rc;
                
                rc = _viewInput.frame;
                rc.origin.x = spacex;
                rc.size.width = self.width-rc.origin.x-spacex;
                _viewInput.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewSearchOption;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = nil;
                _textField.rightViewMode = UITextFieldViewModeNever;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            }break;
            case ViewTopBarStatusInput:
            {
                // TODO:设置背景
                _viewInput.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
                _textField.textColor = [UIColor blackColor];
                [_textField setValue:[UIColor colorWithWhite:0.35 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                
                // 设置按钮的显示/隐藏
                _btnGoBack.alpha =
                _btnGoForward.alpha =
                _btnMenu.alpha =
                _btnGoHome.alpha =
                _btnWinds.alpha = 0;
                
                _btnCancel.alpha = 1;
                
                _btnStop.alpha =
                _btnRefresh.alpha = 0;
                
                // 设置frame
                rc = _btnCancel.frame;
                rc.origin.x = self.width-rc.size.width-spacex;
                _btnCancel.frame = rc;
                
                rc = _viewInput.frame;
                rc.origin.x = spacex;
                rc.size.width = _btnCancel.left-rc.origin.x-spacex;
                _viewInput.frame = rc;
                
                // 设置leftView, rightView
                _textField.leftView = _leftViewSearchOption;
                _textField.leftViewMode = UITextFieldViewModeAlways;
                
                _textField.rightView = nil;
                _textField.rightViewMode = UITextFieldViewModeNever;
                _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                
            }break;
            default:
                break;
        }
    }
}

- (BOOL)resignFirstResponder
{
    return [_textField resignFirstResponder];
}

#pragma mark - IBAction
- (IBAction)onTouchCancel
{
    [_delegate view:self barEvent:BarEventCancelInputUrl barItem:_btnCancel];
}

- (IBAction)onTouchBarItem:(UIView *)barItem
{
    if (barItem==_btnGoBack) {
        [_delegate view:self barEvent:BarEventGoBack barItem:barItem];
    }
    else if (barItem==_btnGoForward) {
        [_delegate view:self barEvent:BarEventGoForward barItem:barItem];
    }
    else if (barItem==_btnGoHome) {
        [_delegate view:self barEvent:BarEventHome barItem:barItem];
    }
    else if (barItem==_btnMenu) {
        [_delegate view:self barEvent:BarEventMenu barItem:barItem];
    }
    else if (barItem==_btnWinds) {
        [_delegate view:self barEvent:BarEventWindows barItem:barItem];
    }
    else if (barItem==_btnRefresh) {
        [_delegate view:self barEvent:BarEventRefresh barItem:barItem];
    }
    else if (barItem==_btnStop) {
        [_delegate view:self barEvent:BarEventStop barItem:barItem];
    }
    else if (barItem==_btnQRCode) {
        [_delegate view:self barEvent:BarEventQRCode barItem:barItem];
    }
    else if (barItem==_btnBookmark) {
        [_delegate view:self barEvent:BarEventBookmark barItem:barItem];
    }
    else if (barItem==_btnSearchOption || barItem==_btnSearchArrow) {
        [_delegate view:self barEvent:BarEventSearchOption barItem:_btnSearchOption];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_delegate view:self barEvent:BarEventDidBeginInputUrl barItem:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_delegate view:self barEvent:BarEventDidEndInputUrl barItem:textField];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - public methods
- (void)setSearchEngine:(ModelSearchEngine *)searchEngine
{
    _searchEngine = searchEngine;
    
    __unsafe_unretained UIButton *wBtnSearchOption = _btnSearchOption;
    [_btnSearchOption setImageWithURL:[NSURL URLWithString:searchEngine.colorIcon] forState:UIControlStateNormal placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image.scale!=[UIScreen mainScreen].scale) {
            NSData *data = UIImagePNGRepresentation(image);
            [wBtnSearchOption setImage:[UIImage imageWithData:data scale:[UIScreen mainScreen].scale] forState:UIControlStateNormal];
        }
    }];
}

/**
 *  设置书签按钮图标是否高亮
 *
 *  @param highlighted BOOL 是否高亮
 */
- (void)setBookmarkIconHighlighted:(BOOL)highlighted
{
    _btnBookmark.selected = highlighted;
}

#pragma mark - AppLanguageProtocl
- (void)updateByLanguage
{
    _textField.placeholder = LocalizedString(@"sousuohuoshuruwangzhi");
    [_btnCancel setTitle:LocalizedString(@"quxiao") forState:UIControlStateNormal];
    [_btnCancel setTitle:LocalizedString(@"quxiao") forState:UIControlStateSelected];
    [_btnCancel setTitle:LocalizedString(@"quxiao") forState:UIControlStateDisabled];
}

@end
