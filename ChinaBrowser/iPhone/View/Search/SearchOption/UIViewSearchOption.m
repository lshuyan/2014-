//
//  UIViewSearchOption.m
//  ChinaBrowser
//
//  Created by David on 14-9-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSearchOption.h"

#import "UICellSearchOption.h"

#import "ModelSearchEngine.h"

#import "UIImageView+WebCache.h"

@interface UIViewSearchOption () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation UIViewSearchOption
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_viewContent;
    IBOutlet UIImageView *_imageViewBg;
    
    BOOL _animating;
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismiss)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewSearchOption" owner:nil options:nil][0];
}

/**
 *  显示面板
 *
 *  @param view         显示在哪个目标视图上
 *  @param centerOfDock 停靠的边栏中点
 */
- (void)showInView:(UIView *)view centerOfDock:(CGPoint)centerOfDock
{
    _animating = YES;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.frame = view.bounds;
    [view addSubview:self];
    
    CGRect rc = _viewContent.frame;
    rc.origin.y = centerOfDock.y;
    rc.origin.x = centerOfDock.x-19;
    
    _viewContent.frame = CGRectIntegral(rc);
    _imageViewBg.image = [[UIImage imageWithBundleFile:@"iPhone/Search/bg_box.png"] stretchableImageWithLeftCapWidth:19 topCapHeight:30];
    
    _viewContent.layer.anchorPoint = CGPointMake((centerOfDock.x-_viewContent.left)/_viewContent.width, 0);
    _viewContent.layer.position = centerOfDock;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    anim.keyTimes = @[@(0), @(0.75), @(1)];
    anim.duration = 0.3;
    anim.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [_viewContent.layer addAnimation:anim forKey:@"transform"];
    
    CABasicAnimation *animOpacity = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animOpacity.fromValue = (id)[UIColor clearColor].CGColor;
    animOpacity.toValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
    animOpacity.duration = 0.3;
    animOpacity.delegate = self;
    [animOpacity setValue:^{
        _animating = NO;
    } forKey:@"handle"];
    [self.layer addAnimation:animOpacity forKey:@"backgroundColor"];
    
    _viewContent.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[AppSetting shareAppSetting].searchIndex inSection:0]
                            animated:NO
                      scrollPosition:UITableViewScrollPositionNone];
}

/**
 *  消失
 */
- (void)dismiss
{
    // self dismisss
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    if (_animating) {
        return;
    }
    
    _animating = YES;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1)]];
    anim.keyTimes = @[@(0), @(0.25), @(1)];
    anim.duration = 0.35;
    anim.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [_viewContent.layer addAnimation:anim forKey:@"transform"];
    
    CABasicAnimation *animOpacity = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animOpacity.toValue = (id)[UIColor clearColor].CGColor;
    animOpacity.fromValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
    animOpacity.duration = 0.35;
    animOpacity.delegate = self;
    [animOpacity setValue:^{
        if (completion) completion();
        
        _animating = NO;
        [self removeFromSuperview];
    } forKey:@"handle"];
    [self.layer addAnimation:animOpacity forKey:@"backgroundColor"];
    
    _viewContent.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void (^handle)() = [anim valueForKey:@"handle"];
    if (handle) {
        handle();
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_animating) {
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(_viewContent.frame, touchPoint)) {
        [self dismiss];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppSetting shareAppSetting].arrSearchEngine.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UICellSearchOption *cell = (UICellSearchOption *)[tableView dequeueReusableCellWithIdentifier:@"UICellSearchOption"];
    if (!cell) {
        cell = [UICellSearchOption viewFromXib];
    }
    
    ModelSearchEngine *modelSearchEngine = [AppSetting shareAppSetting].arrSearchEngine[indexPath.row];
    __unsafe_unretained UIImageView *wImageViewIcon = cell.imageViewIcon;
    [cell.imageViewIcon setImageWithURL:[NSURL URLWithString:modelSearchEngine.icon] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image.scale!=[UIScreen mainScreen].scale) {
            NSData *data = UIImagePNGRepresentation(image);
            wImageViewIcon.image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
        }
    }];
    
    cell.labelTitle.text = modelSearchEngine.name;
    cell.accessoryType = indexPath.row==[AppSetting shareAppSetting].searchIndex?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissWithCompletion:^{
        [AppSetting shareAppSetting].searchIndex = indexPath.row;
        ModelSearchEngine *modelSearchEngine = [AppSetting shareAppSetting].arrSearchEngine[indexPath.row];
        [_delegate viewSearchOption:self didSelectSearchEngine:modelSearchEngine];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
}

@end
