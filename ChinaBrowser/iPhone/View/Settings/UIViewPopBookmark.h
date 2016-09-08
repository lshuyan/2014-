//
//  UIViewPopBookmark.h
//  ChinaBrowser
//
//  Created by David on 14/12/10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@interface UIViewPopBookmark : UIViewPopButtomBase

@property (nonatomic, strong) void (^callbackWillAddToBookmark)(void);
@property (nonatomic, strong) void (^callbackWillAddToHomeApp)(void);

@end
