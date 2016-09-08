//
//  UIViewBookmarkAction.m
//  ChinaBrowser
//
//  Created by David on 15/1/8.
//  Copyright (c) 2015年 KOTO Inc. All rights reserved.
//

#import "UIViewBookmarkAction.h"

@implementation UIViewBookmarkAction
{
    IBOutlet UIButton *_btnNewFolder;
    IBOutlet UIButton *_btnNewBookmark;
}

#pragma mark - property
- (void)setCanNewFolder:(BOOL)canNewFolder
{
    _canNewFolder = canNewFolder;
    _btnNewFolder.enabled = _canNewFolder;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_btnNewFolder setTitle:LocalizedString(@"xinjianwenjianjia") forState:UIControlStateNormal];
    [_btnNewFolder setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnNewFolder setTitleColor:[[UIColor blueColor] colorByLighteningTo:0.8] forState:UIControlStateHighlighted];
    [_btnNewFolder setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [_btnNewBookmark setTitle:LocalizedString(@"xinjianshuqian") forState:UIControlStateNormal];
    [_btnNewBookmark setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnNewBookmark setTitleColor:[[UIColor blueColor] colorByLighteningTo:0.8] forState:UIControlStateHighlighted];
    [_btnNewBookmark setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:@"UIViewBookmarkAction" owner:nil options:nil][0];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldAntialias(context, NO);
    
    CGFloat lineWidth = 0.5;
    
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    
    CGContextMoveToPoint(context, 0, lineWidth);
    CGContextAddLineToPoint(context, self.width, lineWidth);
    
    CGContextMoveToPoint(context, self.width/2, lineWidth);
    CGContextAddLineToPoint(context, self.width/2, self.height-lineWidth);
    
    CGContextStrokePath(context);
}

- (IBAction)onTouchNewFolder
{
    if (_callbackNewFolder) {
        _callbackNewFolder();
    }
}

- (IBAction)onTouchNewBookmark
{
    if (_callbackNewBookmark) {
        _callbackNewBookmark();
    }
}

@end
