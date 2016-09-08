//
//  UIViewPanelBase.m
//  ChinaBrowser
//
//  Created by David on 14-9-25.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPanelBase.h"

@implementation UIViewPanelBase
{
    UIView *_viewContent;
    
    BOOL _animating;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissWillRotate) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 *  显示面板
 *
 *  @param view         显示在哪个目标视图上
 *  @param contentView  内容视图
 *  @param centerOfDock 停靠的边栏中点
 *  @param dockDirection 停靠的边栏方向
 */
- (void)showInView:(UIView *)view contentView:(UIView *)contentView centerOfDock:(CGPoint)centerOfDock dockDirection:(DockDirection)dockDirection
{
    _animating = YES;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _viewContent = contentView;
    self.frame = view.bounds;
    [self addSubview:_viewContent];
    [view addSubview:self];
    
    CGRect rc = _viewContent.frame;
    switch (dockDirection) {
        case DockDirectionTop:
        {
            rc.origin.y = centerOfDock.y;
            rc.origin.x = centerOfDock.x-rc.size.width/2;
            if (rc.origin.x+rc.size.width>self.width) {
                rc.origin.x = self.width-rc.size.width;
            }
            else if (rc.origin.x<0) {
                rc.origin.x = 0;
            }
            _viewContent.frame = CGRectIntegral(rc);
            
            _viewContent.layer.anchorPoint = CGPointMake((centerOfDock.x-_viewContent.left)/_viewContent.width, 0);
            _viewContent.layer.position = centerOfDock;
        }break;
        case DockDirectionRight:
        {
            rc.origin.x = self.width-rc.size.width-centerOfDock.x;
            rc.origin.y = centerOfDock.y;
            if (rc.origin.y+rc.size.height>self.height) {
                rc.origin.y = self.height-rc.size.height;
            }
            else if (rc.origin.y<0) {
                rc.origin.y = 0;
            }
            _viewContent.frame = CGRectIntegral(rc);
            
            _viewContent.layer.anchorPoint = CGPointMake(1, (centerOfDock.y-_viewContent.top)/_viewContent.height);
            _viewContent.layer.position = centerOfDock;
        }break;
        case DockDirectionBottom:
        {
            rc.origin.y = centerOfDock.y-rc.size.height;
            rc.origin.x = centerOfDock.x-rc.size.width/2;
            if (rc.origin.x+rc.size.width>self.width) {
                rc.origin.x = self.width-rc.size.width;
            }
            else if (rc.origin.x<0) {
                rc.origin.x = 0;
            }
            _viewContent.frame = CGRectIntegral(rc);
            
            _viewContent.layer.anchorPoint = CGPointMake((centerOfDock.x-_viewContent.left)/_viewContent.width, 1);
            _viewContent.layer.position = centerOfDock;
        }break;
        case DockDirectionLeft:
        {
            rc.origin.x = centerOfDock.x;
            rc.origin.y = centerOfDock.y;
            if (rc.origin.y+rc.size.height>self.height) {
                rc.origin.y = self.height-rc.size.height;
            }
            else if (rc.origin.y<0) {
                rc.origin.y = 0;
            }
            _viewContent.frame = CGRectIntegral(rc);
            
            _viewContent.layer.anchorPoint = CGPointMake(0, (centerOfDock.y-_viewContent.top)/_viewContent.height);
            _viewContent.layer.position = centerOfDock;
        }break;
            
        default:
            break;
    }
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    anim.keyTimes = @[@(0), @(0.85), @(1)];
    anim.duration = 0.5;
    anim.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [_viewContent.layer addAnimation:anim forKey:@"transform"];
    
    CABasicAnimation *animOpacity = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animOpacity.fromValue = (id)[UIColor clearColor].CGColor;
    animOpacity.toValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
    animOpacity.duration = 0.5;
    animOpacity.delegate = self;
    [animOpacity setValue:^{
        _animating = NO;
    } forKey:@"handle"];
    [self.layer addAnimation:animOpacity forKey:@"backgroundColor"];
    
    _viewContent.layer.transform = CATransform3DMakeScale(1, 1, 1);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
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

/**
 *  消失
 */
- (void)dismiss
{
    // self dismisss
    
    _animating = YES;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1)]];
    anim.keyTimes = @[@(0), @(0.2), @(1)];
    anim.duration = 0.5;
    anim.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [_viewContent.layer addAnimation:anim forKey:@"transform"];
    
    CABasicAnimation *animOpacity = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animOpacity.toValue = (id)[UIColor clearColor].CGColor;
    animOpacity.fromValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
    animOpacity.duration = 0.5;
    animOpacity.delegate = self;
    [animOpacity setValue:^{
        _animating = NO;
        [self removeFromSuperview];
    } forKey:@"handle"];
    [self.layer addAnimation:animOpacity forKey:@"backgroundColor"];
    
    _viewContent.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
}

- (void)dismissWillRotate
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
        return;
        _animating = YES;
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1)]];
        anim.duration = 0.5;
        anim.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [_viewContent.layer addAnimation:anim forKey:@"transform"];
        
        CABasicAnimation *animOpacity = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        animOpacity.toValue = (id)[UIColor clearColor].CGColor;
        animOpacity.fromValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
        animOpacity.duration = 0.5;
        animOpacity.delegate = self;
        [animOpacity setValue:^{
            _animating = NO;
            [self removeFromSuperview];
        } forKey:@"handle"];
        [self.layer addAnimation:animOpacity forKey:@"backgroundColor"];
        
        _viewContent.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    });
}

@end
