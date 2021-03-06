//
//  UIViewSync.m
//  ChinaBrowser
//
//  Created by David on 15/1/4.
//  Copyright (c) 2015年 KOTO Inc. All rights reserved.
//

#import "UIViewSync.h"

#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIButton+WebCache.h"

#import "UIControllerLogin.h"
#import "UIControllerUserInfo.h"
#import "KTAnimationKit.h"

@implementation UIViewSync
{
    IBOutlet UILabel *_labelSyncTime;
    IBOutlet UILabel *_labelUserName;
    IBOutlet UIButton *_btnAvatar;
    IBOutlet UIButton *_btnSync;
    
    IBOutlet UIActivityIndicatorView *_activityView;
}

#pragma mark - property
/**
 *  设置同步时间
 *
 *  @param syncTime >0表示同步成功显示同步时间；=0表示同步失败
 */
- (void)setSyncTime:(NSInteger)syncTime
{
    _syncTime = syncTime;
    [UserManager shareUserManager].currUser.syncTime = _syncTime;
    if ([UserManager shareUserManager].currUser.syncTime>0) {
        // 同步成功
        [KTAnimationKit animationEaseIn:_labelSyncTime];
        _labelSyncTime.text = LocalizedString(@"tongbuchenggong");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KTAnimationKit animationEaseIn:_labelSyncTime];
            _labelSyncTime.text = [LocalizedString(@"shangcitongbu_") stringByAppendingString:[NSString stringWithTimeInterval:[UserManager shareUserManager].currUser.syncTime]];
        });
    }
    else {
        // 同步失败
        _labelSyncTime.text = LocalizedString(@"tongbushibai");
    }
}

#pragma mark - super method
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    
    _btnAvatar.layer.borderWidth = 0.5;
    _btnAvatar.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    
    [_btnSync setTitle:LocalizedString(@"tongbu") forState:UIControlStateNormal];
    UIColor *color = [UIColor colorWithRed:0.000 green:0.463 blue:0.667 alpha:1.000];
    [_btnSync setTitleColor:color forState:UIControlStateNormal];
    [_btnSync setTitleColor:[color colorByMultiplyingBy:1.2] forState:UIControlStateHighlighted];
    
    [_btnSync setBackgroundImage:[[UIImage imageWithBundleFile:@"iPhone/Settings/Bookmark/synchronous_0.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];
    [_btnSync setBackgroundImage:[[UIImage imageWithBundleFile:@"iPhone/Settings/Bookmark/synchronous_1.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateHighlighted];
    
    [self updateUserStatus];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldAntialias(context, NO);
    
    CGFloat lineWidth = 0.5;
    
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    
    CGContextMoveToPoint(context, 0, lineWidth);
    CGContextAddLineToPoint(context, self.width, lineWidth);
    
    CGContextStrokePath(context);
}

#pragma mark - private methods
- (IBAction)onTouchSync
{
    ModelUser *user = [UserManager shareUserManager].currUser;
    
    if (user) {
        if ([SyncHelper shouldSyncWithType:_syncDataType]) {
            [_activityView startAnimating];
            _btnSync.hidden = YES;
            _labelSyncTime.text = LocalizedString(@"zhengzaitongbu_");
            [[SyncHelper shareSync] syncDataType:_syncDataType completion:^{
                NSInteger syncTime = [[NSDate date] timeIntervalSince1970];
                [self setSyncTime:syncTime];
                if (_callbackSyncCompletion) _callbackSyncCompletion();
                
                [_activityView stopAnimating];
                _btnSync.hidden = NO;
            } fail:^(NSError *error) {
                [self setSyncTime:0];
                if (_callbackSyncFail) _callbackSyncFail();
                
                [_activityView stopAnimating];
                _btnSync.hidden = NO;
            }];
        }
        else {
            UIControllerUserInfo *controllerUserInfo = [UIControllerUserInfo controllerFromXib];
            [_controllerRoot.navigationController pushViewController:controllerUserInfo animated:YES];
        }
    }
    else {
        UIControllerLogin *controller = [UIControllerLogin controllerFromXib];
        controller.fromController = FromControllerSync;
        controller.title = LocalizedString(@"yonghudenglu");
        [_controllerRoot.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)onTouchAvatar
{
    UIControllerUserInfo *controllerUserInfo = [UIControllerUserInfo controllerFromXib];
    [_controllerRoot.navigationController pushViewController:controllerUserInfo animated:YES];
}

#pragma mark - public methods
+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

/**
 *  调整大小，位于指定父视图的底部
 *
 */
- (void)resizeBottomSuperView
{
    CGRect rc = CGRectMake(0, self.superview.height-self.height, self.superview.width, self.height);
    self.frame = rc;
}

/**
 *  更新用户状态
 */
- (void)updateUserStatus
{
    ModelUser *user = [UserManager shareUserManager].currUser;
    if (user) {
        __weak typeof(_btnAvatar) wBtnAvatar = _btnAvatar;
        [_btnAvatar setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageWithBundleFile:@"iPhone/User/avatar_default.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (!image) {
                image = [UIImage imageWithBundleFile:@"iPhone/User/avatar_default.png"];
                [wBtnAvatar setImage:image forState:UIControlStateNormal];
            }
        }];
        _labelUserName.text = user.nickname;
        
        if ([SyncHelper shareSync].isSyncing) {
            [_activityView startAnimating];
            _btnSync.hidden = YES;
            _labelSyncTime.text = LocalizedString(@"zhengzaitongbu_");
        }
        else {
            if ([UserManager shareUserManager].currUser.syncTime>0) {
                _labelSyncTime.text = [LocalizedString(@"shangcitongbu_") stringByAppendingString:[NSString stringWithTimeInterval:[UserManager shareUserManager].currUser.syncTime]];
            }
            else {
                _labelSyncTime.text = LocalizedString(@"ninhaiweitongbu");
            }
        }
    }
    else {
        [_btnAvatar setImage:[UIImage imageWithBundleFile:@"iPhone/User/avatar_default.png"] forState:UIControlStateNormal];
        _labelUserName.text = LocalizedString(@"weidenglu");
        _labelSyncTime.text = nil;
    }
}

@end
