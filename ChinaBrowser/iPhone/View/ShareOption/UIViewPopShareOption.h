//
//  UIViewPopShareOption.h
//  ChinaBrowser
//
//  Created by David on 14/11/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

#import <ShareSDK/ShareSDKTypeDef.h>

/**
 *  分享选项样式
 */
typedef NS_ENUM(NSInteger, ShareOptionStyle) {
    /**
     *  默认样式
     */
    ShareOptionStyleDefault,
    /**
     *  截图样式
     */
    ShareOptionStyleScreenshot
};

@interface UIViewPopShareOption : UIViewPopButtomBase

+ (instancetype)viewFromXibWithStyle:(ShareOptionStyle)style;

@property (nonatomic, copy) void (^callbackSelectShareType)(ShareType);
@property (nonatomic, copy) void (^callbackSelectSaveImage)();

@end
