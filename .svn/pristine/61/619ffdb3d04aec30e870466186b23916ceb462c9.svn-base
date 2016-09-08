//
//  UIControllerModeDetail.h
//  ChinaBrowser
//
//  Created by David on 14/11/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

@class ModelMode;

@interface UIControllerModeDetail : UIControllerBase

@property (nonatomic, retain) ModelMode *modelMode;

@property (nonatomic, strong) void (^callbackDidUpdateMode)(NSInteger modePkid);
@property (nonatomic, strong) NSInteger (^callbackGetCurrModePkid)(void);
//@property (nonatomic, strong) void (^callbackDidSync)(NSInteger modePkid);

@end
