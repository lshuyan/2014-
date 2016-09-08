//
//  UIViewSetSkinItem.m
//  ChinaBrowser
//
//  Created by David on 14-3-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewSetSkinItem.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIViewSetSkinItem

- (UIImage *)delImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    [[UIColor redColor] setFill];
    [[UIColor whiteColor] setStroke];
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, size.width, size.height));
    CGContextFillPath(ctx);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, 5, size.height/2);
    CGContextAddLineToPoint(ctx, size.width-5, size.height/2);
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (void)setEdit:(BOOL)edit
{
    _edit = edit;
    if (_edit) {
        _btnDel.transform = CGAffineTransformIdentity;
        CGRect rc = _btnDel.frame;
        rc.origin.x = self.frame.origin.x-rc.size.width/2;
        rc.origin.y = self.frame.origin.y-rc.size.height/2;
        _btnDel.frame = rc;
        
        [self.superview addSubview:_btnDel];
        _btnDel.transform = CGAffineTransformMakeScale(0.001, 0.001);
        
        [UIView animateWithDuration:0.2 animations:^{
            _btnDel.transform = CGAffineTransformIdentity;
        }];
    }
    else {
        [UIView animateWithDuration:0.2  animations:^{
            _btnDel.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            [_btnDel removeFromSuperview];
            _btnDel.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _imageViewSelectMark.hidden = !selected;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect rc = _btnDel.frame;
    rc.origin.x = self.frame.origin.x-rc.size.width/2;
    rc.origin.y = self.frame.origin.y-rc.size.height/2;
    _btnDel.frame = rc;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (UIViewSetSkinItem *)viewSetSkinItemFromXib
{
    UIViewSetSkinItem *viewSetSkinItem = [[NSBundle mainBundle] loadNibNamed:@"UIViewSetSkinItem" owner:nil options:nil][0];
    return viewSetSkinItem;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_btnDel removeFromSuperview];
    _btnDel.bounds = CGRectMake(0, 0, 24, 24);
    [_btnDel setImage:[self delImageWithSize:_btnDel.bounds.size] forState:UIControlStateNormal];
    
    _viewContent.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    _viewContent.layer.borderWidth = 0.4;
    _viewContent.layer.cornerRadius = 4;
    _imageViewMask.image = [UIImage imageWithBundleFile:@"iPhone/Settings//SetSkin/bg_pifu_1.png"];
    _imageViewSelectMark.image = [UIImage imageWithBundleFile:@"iPhone/Settings//SetSkin/bg_pifu_2.png"];
    
    for (UIView *subView in self.subviews) {
        subView.userInteractionEnabled = subView==_btnDel;
    }
    
//    _labelTitle.textColor = [UIColor grayColor];r
//    _labelTitle.font = [UIFont font]
    
    
//    _labelTitle.hidden = YES;
    
}

@end
