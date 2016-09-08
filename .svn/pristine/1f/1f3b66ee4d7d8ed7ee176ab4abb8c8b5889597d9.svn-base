//
//  UIImage+Ex.m
//  ChinaBrowser
//
//  Created by David on 14-2-14.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIImage+Ex.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Extension)

/**
 *  去bundle里的图片
 *
 *  @param file bundle中文件的相对路径
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithBundleFile:(NSString *)file
{
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file]];
}

/**
 *  截图，有透明度
 *
 *  @param view
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view
{
    return [UIImage imageFromView:view opaque:NO];
}

/**
 *  区域截图，有透明度
 *
 *  @param view
 *  @param rect 截图区域
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect
{
    return [UIImage imageFromView:view rect:rect opaque:NO];
}

/**
 *  截图，指定是否不透明
 *
 *  @param view
 *  @param opaque 是否不透明，YES:JPG, NO:PNG
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view opaque:(BOOL)opaque
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  区域截图，指定是否不透明
 *
 *  @param view
 *  @param rect   截图区域
 *  @param opaque 是否不透明，YES:JPG, NO:PNG
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)view rect:(CGRect)rect opaque:(BOOL)opaque
{
    UIImage *imageOrigent = [UIImage imageFromView:view opaque:opaque];
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageOrigent.CGImage,CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale([UIScreen mainScreen].scale, [UIScreen mainScreen].scale)));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

@end
