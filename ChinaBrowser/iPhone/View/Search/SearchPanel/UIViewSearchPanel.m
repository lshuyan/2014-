//
//  UIViewSearchPanel.m
//  ChinaBrowser
//
//  Created by David on 14/10/27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSearchPanel.h"

@implementation UIViewSearchPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewSearchPanel" owner:nil options:nil][0];
}

- (void)showInView:(UIView *)view completion:(void(^)(void))completion
{
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

- (void)dismiss
{
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(viewSearchPanelWillDismiss:)])
        [_delegate viewSearchPanelWillDismiss:self];
}

@end
