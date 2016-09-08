//
//  UIViewPopSyncStyle.h
//  ChinaBrowser
//
//  Created by David on 14/11/24.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@interface UIViewPopSyncStyle : UIViewPopButtomBase

@property (nonatomic, copy) void(^callbackDidSelectSyncStyle)(SyncStyle syncStyle);

@end
