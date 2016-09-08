//
//  UIViewHeader.h
//  KTBrowser
//
//  Created by David on 14-3-6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SKUBorder){
    SKUBorderNone   = 0,
    SKUBorderTop    = 1<<0,
    SKUBorderRight  = 1<<1,
    SKUBorderBottom = 1<<2,
    SKUBorderLeft   = 1<<3,
    SKUBorderAll    = SKUBorderTop|SKUBorderRight|SKUBorderBottom|SKUBorderLeft
};

typedef NS_ENUM(NSInteger, UIViewCorner) {
    UIViewCornerNone    = 1<<0,
    UIViewCornerTL      = 1<<1,
    UIViewCornerTR      = 1<<2,
    UIViewCornerBL      = 1<<3,
    UIViewCornerBR      = 1<<4,
    UIViewCornerAll     = UIViewCornerTL|UIViewCornerTR|UIViewCornerBL|UIViewCornerBR
};

@interface UIViewHeader : UIControl

@property (nonatomic, strong) UIColor *colorNor;
@property (nonatomic, strong) UIColor *colorSelect;
@property (nonatomic, strong) UIColor *colorHighlight;

@property (nonatomic, strong) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelSubTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewAccessory;

- (void)setViewCorner:(UIRectCorner)corner;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

+ (UIViewHeader *)viewHeaderFromXib;

@end
