//
//  UIViewTabBottom.m
//  ChinaBrowser
//
//  Created by David on 14/12/15.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewTabBottom.h"

@implementation UIViewTabBottom
{
    __weak IBOutlet UIButton *_btnNew;
    __weak IBOutlet UIButton *_btnBack;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_btnBack setTitle:LocalizedString(@"fanhui") forState:UIControlStateNormal];
    [_btnNew setTitle:LocalizedString(@"xinjianchuangkou") forState:UIControlStateNormal];
    
    [_btnBack addTarget:self action:@selector(onTouchBack) forControlEvents:UIControlEventTouchUpInside];
    [_btnNew addTarget:self action:@selector(onTouchNew) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnNew setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [_btnNew setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
    [_btnNew setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateDisabled];
    
    [_btnBack setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [_btnBack setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
    [_btnBack setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateDisabled];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldAntialias(context, NO);
    CGFloat lineWidth = 0.5;
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextMoveToPoint(context, self.width/2, lineWidth);
    CGContextAddLineToPoint(context, self.width/2, self.height);
    CGContextMoveToPoint(context, 0, lineWidth);
    CGContextAddLineToPoint(context, self.width, lineWidth);
    CGContextStrokePath(context);
}

- (void)onTouchBack
{
    if (_callbackBack) {
        _callbackBack();
    }
}

- (void)onTouchNew
{
    if (_callbackNewWindow) {
        _callbackNewWindow();
    }
}

- (void)setAllowNew:(BOOL)allowNew
{
    _btnNew.enabled = allowNew;
}

@end
