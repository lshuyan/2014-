//
//  UIControlItem.m
//  ChinaBrowser
//
//  Created by David on 14/10/28.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControlItem.h"

@implementation UIControlItem

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
    
    self.highlighted = NO;
    _bgColorNormal = [UIColor colorWithWhite:0.96 alpha:0];
    _bgColorHighlighted = [UIColor colorWithWhite:0.96 alpha:0.1];
    self.backgroundColor = self.highlighted?_bgColorHighlighted:_bgColorNormal;
    
    _textColorNormal = [UIColor colorWithWhite:1 alpha:1];
    _textColorHiglighted = [UIColor colorWithWhite:0.7 alpha:1];
    
//    _labelTitle.highlighted = YES;
    
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
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
            self.backgroundColor = _bgColorHighlighted;
            if (self.selected) {
                if (_imageNormal) {
                    _imageViewIcon.image = _imageNormal;
                }
                
                if (_textColorNormal) {
                    _labelTitle.textColor = _textColorNormal;
                }
            }
            else {
                if (_imageHighlighted) {
                    _imageViewIcon.image = _imageHighlighted;
                }
                
                if (_textColorHiglighted) {
                    _labelTitle.textColor = _textColorHiglighted;
                }
            }
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.backgroundColor = _bgColorNormal;
                }];
                
                if (self.selected) {
                    if (_imageSelected) {
                        _imageViewIcon.image = _imageSelected;
                    }
                    
                    if (_textColorSelected) {
                        _labelTitle.textColor = _textColorSelected;
                    }
                }
                else {
                    if (_imageNormal) {
                        _imageViewIcon.image = _imageNormal;
                    }
                    
                    if (_textColorNormal) {
                        _labelTitle.textColor = _textColorNormal;
                    }
                }
            });
        }
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    self.alpha = enabled?1:0.2;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.selected) {
        if (_imageSelected) {
            _imageViewIcon.image = _imageSelected;
        }
        
        if (_textColorSelected) {
            _labelTitle.textColor = _textColorSelected;
        }
    }
    else {
        if (_imageNormal) {
            _imageViewIcon.image = _imageNormal;
        }
        
        if (_textColorNormal) {
            _labelTitle.textColor = _textColorNormal;
        }
    }
}

+ (instancetype)viewFromXibWithType:(ControlItemType)controlItemType
{
    NSString *xib = nil;
    switch (controlItemType) {
        case ControlItemTypeMenu:
        {
            xib = @"UIControlItemMenu";
        }break;
        case ControlItemTypeShare:
        {
            xib = @"UIControlItemShare";
        }break;
        case ControlItemTypeTrans:
        {
            xib = @"UIControlItemTrans";
        }break;
        case ControlItemTypeRecommendCate:
        {
            xib = @"UIControlItemRecommendCate";
        }break;
        case ControlItemTypeApp:
        {
            xib = @"UIControlItemApp";
        }break;
        case ControlItemTypeAppAdd:
        {
            xib = @"UIControlItemAppAdd";
        }break;
        case ControlItemTypeScreenshot:
        {
            xib = @"UIControlItemTypeScreenshot";
        }break;
        default:
            break;
    }
    if (xib)
        return [[NSBundle mainBundle] loadNibNamed:xib owner:nil options:nil][0];
    else
        return nil;
}

- (void)setBgColorNormal:(UIColor *)normal highlighted:(UIColor *)highlighted
{
    _bgColorNormal = normal;
    _bgColorHighlighted = highlighted;
    
    self.backgroundColor = self.highlighted?_bgColorHighlighted:_bgColorNormal;
}

- (void)setImageNormal:(UIImage *)normal highlighted:(UIImage *)highlighted selected:(UIImage *)selected
{
    _imageNormal = normal;
    _imageSelected = selected?:normal;
    _imageHighlighted = highlighted?:normal;
    
    if (self.selected) {
        if (_imageSelected) {
            _imageViewIcon.image = _imageSelected;
        }
    }
    else if (self.highlighted) {
        if (_imageHighlighted) {
            _imageViewIcon.image = _imageHighlighted;
        }
    }
    else {
        if (_imageNormal) {
            _imageViewIcon.image = _imageNormal;
        }
    }
}

- (void)setTextColorNormal:(UIColor *)normal highlighted:(UIColor *)highlighted
{
    [self setTextColorNormal:normal highlighted:highlighted selected:nil];
}

- (void)setTextColorNormal:(UIColor *)normal highlighted:(UIColor *)highlighted selected:(UIColor *)selected
{
    _textColorNormal = normal;
    _textColorSelected = selected?:normal;
    _textColorHiglighted = highlighted?:normal;
    
    if (self.selected) {
        if (_textColorSelected) {
            _labelTitle.textColor = _textColorSelected;
        }
    }
    else if (self.highlighted) {
        if (_textColorHiglighted) {
            _labelTitle.textColor = _textColorHiglighted;
        }
    }
    else {
        if (_textColorNormal) {
            _labelTitle.textColor = _textColorNormal;
        }
    }
}

@end
