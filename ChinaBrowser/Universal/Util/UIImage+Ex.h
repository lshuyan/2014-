//
//  UIImage+Ex.h
//  ChinaBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  去bundle里的图片
 *
 *  @param file bundle中文件的相对路径
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithBundleFile:(NSString *)file;

/**
 *  截图，有透明度
 *
 *  @param view
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view;

/**
 *  区域截图，有透明度
 *
 *  @param view
 *  @param rect 截图区域
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect;

/**
 *  截图，指定是否不透明
 *
 *  @param view
 *  @param opaque 是否不透明，YES:JPG, NO:PNG
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view opaque:(BOOL)opaque;

/**
 *  区域截图，指定是否不透明
 *
 *  @param view
 *  @param rect   截图区域
 *  @param opaque 是否不透明，YES:JPG, NO:PNG
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect opaque:(BOOL)opaque;

@end
