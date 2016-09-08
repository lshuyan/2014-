//
//  BrightnessUtil.m
//  ChinaBrowser
//
//  Created by David on 14-9-23.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "BrightnessUtil.h"

static BrightnessUtil *brightnessUtil;

@interface BrightnessUtil ()

@end

@implementation BrightnessUtil
{
    UIWindow *_windBrightness;
}

+ (instancetype)shareBrightnessUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        brightnessUtil = [[BrightnessUtil alloc] init];
    });
    return brightnessUtil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setMinBrightness:0.3];
        [self setMaxBrightness:1];
    }
    return self;
}

- (void)setMinBrightness:(CGFloat)minBrightness
{
    _minBrightness = minBrightness;
    
    [self setBrightness:_brightness];
}

- (void)setMaxBrightness:(CGFloat)maxBrightness
{
    _maxBrightness = maxBrightness;
    
    [self setBrightness:_brightness];
}

- (void)setBrightness:(CGFloat)brightness
{
    if (!_windBrightness) {
        _windBrightness = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _windBrightness.windowLevel = UIWindowLevelAlert;
        _windBrightness.backgroundColor = [UIColor blackColor];
        _windBrightness.userInteractionEnabled = NO;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [_windBrightness makeKeyAndVisible];
        [keyWindow makeKeyWindow];
    }
    
    _brightness = brightness;
    CGFloat alpha = 1.0-(_minBrightness+(_maxBrightness-_minBrightness)*_brightness);
    
    _windBrightness.alpha = alpha;
}

@end
