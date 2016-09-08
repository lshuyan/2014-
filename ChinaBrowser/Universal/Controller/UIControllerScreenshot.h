//
//  UIControllerScreenshot.h
//  ChinaBrowser
//
//  Created by David on 14-10-8.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

#import "UIViewCapture.h"

//typedef NS_ENUM(NSInteger, ScreenshotType) {
//    //没有预览功能
//    ScreenshotDraw,
//    ScreenshotSkin,
//    //框只能是正方形
//    ScreenshotIcon
//};

@protocol UIControllerScreenshotDelegate;

@interface UIControllerScreenshot : UIControllerBase

@property (nonatomic, weak) id<UIControllerScreenshotDelegate> delegate;
@property (nonatomic, strong) UIImage *imageOriginal;
@property (nonatomic, assign) ScreenshotType screenshotType;
@end

@protocol UIControllerScreenshotDelegate <NSObject>

- (void)controller:(UIControllerScreenshot *)controller didCaptureImage:(UIImage *)image;

@end
