//
//  UIViewFMHeader.m
//  ChinaBrowser
//
//  Created by David on 14/11/27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewFMHeader.h"

@implementation UIViewFMHeader
{
    IBOutlet UIImageView *_imageViewAccessory;
}

#pragma mark - super methods
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected];
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (selected) {
                _imageViewAccessory.transform = CGAffineTransformMakeRotation(M_PI);
            }
            else {
                _imageViewAccessory.transform = CGAffineTransformIdentity;
            }
            
        } completion:nil];
    }
    else {
        if (selected) {
            _imageViewAccessory.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else {
            _imageViewAccessory.transform = CGAffineTransformIdentity;
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (void)dealloc
{
    [_btnRadio removeObserver:self forKeyPath:@"selected"];
    [self removeObserver:self forKeyPath:@"highlighted"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _imageViewAccessory.image = [UIImage imageWithBundleFile:@"iPhone/FM/expansion_2.png"];
    [_btnRadio setImage:[UIImage imageWithBundleFile:@"iPhone/FM/fm_0.png"] forState:UIControlStateNormal];
    [_btnRadio setImage:[UIImage imageWithBundleFile:@"iPhone/FM/fm_2.png"] forState:UIControlStateSelected];
    [_btnRadio setImage:[UIImage imageWithBundleFile:@"iPhone/FM/fm_2.png"] forState:UIControlStateHighlighted];
    
    _labelTitle.shadowColor = [UIColor grayColor];
    _labelTitle.shadowOffset = CGSizeMake(0, 0);
    
    [_btnRadio addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
//    [_btnRadio addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object==self) {
        if ([keyPath isEqualToString:@"highlighted"]) {
            [UIView animateWithDuration:self.highlighted?0:0.3 animations:^{
                self.backgroundColor = self.highlighted?[UIColor colorWithWhite:0.9 alpha:1]:[UIColor colorWithWhite:1 alpha:1];
            }];
        }
    }
    else if (object==_btnRadio) {
        if ([keyPath isEqualToString:@"selected"]) {
            _labelTitle.textColor = _btnRadio.selected?[UIColor colorWithRed:0.235 green:0.612 blue:0.984 alpha:1.000]:[UIColor blackColor];
        }
//        else if ([keyPath isEqualToString:@"highlighted"]) {
//            if (self.selected) {
//                _labelTitle.textColor = _btnRadio.highlighted?[UIColor colorWithRed:0.235 green:0.612 blue:0.984 alpha:1.000]:[UIColor blackColor];
//            }
//        }
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat lineWidth = 0.5f;
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldAntialias(context, NO);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite:0.8 alpha:1] CGColor]);
//    CGFloat dash[] = {5, 0.5};//第一个是实线的长度，第2个是空格的长度
//    CGContextSetLineDash(context, 1, dash, 2); //给虚线设置下类型，其中2是dash数组大小，如果想设置个性化的虚线 可以将dash数组扩展下即可
    
    // 横线
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    
//    // 横线
//    CGContextMoveToPoint(context, 0, lineWidth);
//    CGContextAddLineToPoint(context, self.bounds.size.width, lineWidth);
    
    // 竖线
    CGContextMoveToPoint(context, _btnRadio.right, 0);
    CGContextAddLineToPoint(context, _btnRadio.right, self.height);
    
    CGContextStrokePath(context);
}

@end
