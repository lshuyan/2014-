//
//  UIViewPopUrlOpenStyle.h
//  ChinaBrowser
//
//  Created by David on 14/11/10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@protocol UIViewPopUrlOpenStyleDelegate;

@interface UIViewPopUrlOpenStyle : UIViewPopButtomBase

@property (nonatomic, weak) IBOutlet id<UIViewPopUrlOpenStyleDelegate> delegate;

@end

@protocol UIViewPopUrlOpenStyleDelegate <NSObject>

- (void)viewPopUrlOpenStyle:(UIViewPopUrlOpenStyle *)viewPopUrlOpenStyle selectUrlOpenStyle:(UrlOpenStyle)urlOpenStyle;

@end
