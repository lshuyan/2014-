//
//  UIViewPreviewTab.m
//  Browser-wzdh
//
//  Created by David on 14-5-30.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPreviewTab.h"

#import "BlockUI.h"

#define kSpaceY (5.0f)
#define kTitleHeight (14)
#define kDeleteRate (2/3.0)

@interface UIViewPreviewTab () <UIGestureRecognizerDelegate>

- (void)panGesture:(UIPanGestureRecognizer *)panGesture;

@end

@implementation UIViewPreviewTab
{
    BOOL _isDirectionX;
    CGAffineTransform _tfOrigin;
}

+ (instancetype)viewPreviewTabWithView:(UIView *)view scale:(CGFloat)scale
{
    CGRect rc = CGRectApplyAffineTransform(view.bounds, CGAffineTransformMakeScale(scale, scale));
    view.transform = CGAffineTransformMakeScale(scale, scale);
    view.center = CGPointMake(rc.size.width*0.5, rc.size.height*0.5);
    UIViewPreviewTab *viewPreviewTab = [[UIViewPreviewTab alloc] initWithFrame:rc view:view];
    return viewPreviewTab;
}

+ (instancetype)viewPreviewTabWithView:(UIView *)view
{
    return [UIViewPreviewTab viewPreviewTabWithView:view scale:1];
}

- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view
{
    self = [self initWithFrame:frame];
    if (self) {
        _viewPreview = view;
        _viewPreview.autoresizingMask = UIViewAutoresizingNone;
        
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height+kSpaceY, self.width, kTitleHeight)];
        _labelTitle.backgroundColor = [UIColor clearColor];
        _labelTitle.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        _labelTitle.highlightedTextColor = [UIColor whiteColor];
        _labelTitle.numberOfLines = 1;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont systemFontOfSize:10];
        _labelTitle.hidden = YES;
        _labelTitle.alpha = 0;
        
        [self addSubview:_viewPreview];
        [self addSubview:_labelTitle];
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.7].CGColor;
        self.layer.borderWidth = 0.5;
        
        /*
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOpacity = 0.95;
        self.layer.shadowRadius = 4;
        self.layer.shadowOffset = CGSizeZero;
         */
        
        _viewPreview.userInteractionEnabled = NO;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        
        [self handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            if ([_delegate respondsToSelector:@selector(viewPreviewTabWillSelect:)]) {
                [_delegate viewPreviewTabWillSelect:self];
            }
        }];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_viewPreview) {
        CGFloat scaleX = frame.size.width/_viewPreview.bounds.size.width;
        CGFloat scaleY = frame.size.height/_viewPreview.bounds.size.height;
        CGPoint center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
        _viewPreview.transform = CGAffineTransformMakeScale(scaleX, scaleY);
        _viewPreview.center = center;
    }
    if (_labelTitle) {
        frame.origin.x = 0;
        frame.origin.y = frame.size.height+kSpaceY;
        frame.size.height = _labelTitle.height;
        _labelTitle.frame = frame;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    UIScrollView *superScrollView = (UIScrollView *)self.superview;
    if (UIGestureRecognizerStateBegan==panGesture.state) {
        CGPoint velocity = [panGesture velocityInView:self];
        _isDirectionX = fabsf(velocity.x)>fabsf(velocity.y);
        _tfOrigin = self.transform;
        superScrollView.scrollEnabled = _isDirectionX;
        
        if (!_isDirectionX) {
            [_delegate viewPreviewTabWillBeginDragY:self];
        }
    }
    else if (UIGestureRecognizerStateChanged==panGesture.state) {
        if (!_isDirectionX) {
            self.transform = CGAffineTransformTranslate(self.transform, 0, [panGesture translationInView:self].y);
            [panGesture setTranslation:CGPointZero inView:self];
            
            CGFloat rate = fabsf(self.transform.ty)/(self.frame.size.height*kDeleteRate);
            CGFloat alpha = 1-0.8*MIN(rate, 1);
            self.alpha = alpha;
        }
    }
    else if (UIGestureRecognizerStateEnded==panGesture.state) {
        UIScrollView *superScrollView = (UIScrollView *)self.superview;
        superScrollView.scrollEnabled = YES;
        
        if (!_isDirectionX) {
            CGFloat translate = self.transform.ty;
            
            if (fabsf(translate)>self.frame.size.height*kDeleteRate) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGAffineTransform tf = _tfOrigin;
                    tf.ty = fabsf(translate)/translate*((self.superview.height+self.height)/2+self.layer.shadowRadius*2);
                    self.transform = tf;
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [_delegate viewPreviewTabWillRemove:self];
                    [_delegate viewPreviewTabWillEndDragY:self];
                }];
            }
            else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.transform = CGAffineTransformIdentity;
                    self.alpha = 1;
                } completion:^(BOOL finished) {
                    [_delegate viewPreviewTabWillEndDragY:self];
                }];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
