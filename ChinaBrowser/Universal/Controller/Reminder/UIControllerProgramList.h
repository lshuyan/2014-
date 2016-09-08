//
//  UIControllerProgramList.h
//  ChinaBrowser
//
//  Created by David on 14/11/27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

@class ModelProgram;

@interface UIControllerProgramList : UIControllerBase

@property (nonatomic, strong) void (^callbackSelectProgram)(ModelProgram *);
@property (nonatomic, strong) BOOL (^callbackCheckIsExistTime)(NSInteger);

@property (nonatomic, assign) NSInteger selectProgramServerId;

@end
