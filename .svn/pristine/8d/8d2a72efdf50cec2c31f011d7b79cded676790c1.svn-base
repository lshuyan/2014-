//
//  UIViewFMPlayer.h
//  ChinaBrowser
//
//  Created by David on 14/11/19.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppLanguageProtocol.h"
#import "CBAudioPlayerDelegate.h"

@class ModelPlayItem;

@interface UIViewFMPlayer : UIView <AppLanguageProtocol, CBAudioPlayerDelegate>

@property (nonatomic, strong) void(^callbackWillAdd)();
@property (nonatomic, assign) NSInteger modePkid;

/**
 *  更新节目列表，当 modePkid = _modePkid 有效，否则无法更新列表
 *
 *  @param modePkid
 */
- (void)updatePListIfNeedWithModePkid:(NSInteger)modePkid;

+ (instancetype)viewFromXib;

@end
