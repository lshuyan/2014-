//
//  UIViewPopSetFontSize.h
//  ChinaBrowser
//
//  Created by David on 14/11/11.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@protocol UIViewPopSetFontSizeDelegate;

@interface UIViewPopSetFontSize : UIViewPopButtomBase

@property (nonatomic, weak) IBOutlet id<UIViewPopSetFontSizeDelegate> delegate;

@end

@protocol UIViewPopSetFontSizeDelegate <NSObject>

- (void)viewPopSetFontSize:(UIViewPopSetFontSize *)viewPopSetFontSize selectFontSize:(CGFloat)fontSize;

@end
