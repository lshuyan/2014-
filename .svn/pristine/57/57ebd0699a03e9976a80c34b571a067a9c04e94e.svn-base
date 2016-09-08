//
//  UIImage+circleImage.m
//  MengChongZhi
//
//  Created by arBao on 7/8/13.
//  Copyright (c) 2013 arBao. All rights reserved.
//

#import "UIImage+circleImage.h"

@implementation UIImage (circleImage)

+ (UIImage *)circleImage:(UIImage *)image
{

    float min = MIN(image.size.width, image.size.height);

    
    if(UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 1);
    } else {
        UIGraphicsBeginImageContext(image.size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);

    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height );

    CGContextAddArc(context, image.size.width/2, image.size.height/2, min/2, 0, 2 *M_PI, 0);
    CGContextClip(context);
    
    [image drawInRect:rect];
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddArc(context, image.size.width/2, image.size.height/2, min/2, 0, 2 *M_PI, 0);
    CGContextStrokePath(context);

    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
