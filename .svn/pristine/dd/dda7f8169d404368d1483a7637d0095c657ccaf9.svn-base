//
//  UIViewCapture.h
//  ChinaBrowser
//
//  Created by David on 14-10-8.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScreenshotType) {
    //没有预览功能
    ScreenshotDraw,
    ScreenshotSkin,
    //框只能是正方形
    ScreenshotIcon
};

@interface UIViewCapture : UIView

@property (nonatomic, assign) CGRect captureFrame;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) ScreenshotType screenshotType;

@end
