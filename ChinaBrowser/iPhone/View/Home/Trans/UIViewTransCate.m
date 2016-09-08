//
//  UIViewTransCate.m
//  ChinaBrowser
//
//  Created by David on 14-9-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewTransCate.h"

@implementation UIViewTransCate
{
    UIColor *_bgColorNormal;
    UIColor *_bgColorHighlighted;
    
    UIColor *_textColorNormal;
    UIColor *_textColorHighlighted;
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
    
    _bgColorNormal = [UIColor colorWithWhite:0.96 alpha:0];
    _bgColorHighlighted = [UIColor colorWithWhite:0.96 alpha:0.1];
    
    _textColorNormal = [UIColor colorWithWhite:1 alpha:1];
    _textColorHighlighted = [UIColor colorWithWhite:0.7 alpha:1];
    
    _labelTitle.textColor = self.highlighted?_textColorHighlighted:_textColorNormal;
    
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    
//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"highlighted"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"highlighted"]) {
        BOOL highlighted = [change[NSKeyValueChangeNewKey] boolValue];
        if (highlighted) {
            self.backgroundColor = self.highlighted?_bgColorHighlighted:_bgColorNormal;
            _labelTitle.textColor = self.highlighted?_textColorHighlighted:_textColorNormal;
            
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.backgroundColor = _bgColorNormal;
                    _labelTitle.textColor = _textColorNormal;
                }];
            });
        }
    }
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewTransCate" owner:nil options:nil][0];
}

- (void)setBgColorNormal:(UIColor *)normal highlighted:(UIColor *)highlighted
{
    _bgColorNormal = normal;
    _bgColorHighlighted = highlighted;
    
    self.backgroundColor = self.highlighted?_bgColorHighlighted:_bgColorNormal;
}

- (void)setTextColorNormal:(UIColor *)normal highlighted:(UIColor *)highlighted
{
    _textColorNormal = normal;
    _textColorHighlighted = highlighted;
    
    _labelTitle.textColor = self.highlighted?_textColorHighlighted:_textColorNormal;
}

@end
