//
//  CheckVersion.h
//  ChinaBrowser
//
//  Created by David on 14-4-4.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSString * const API_CheckVersioniTunes;

@interface CheckVersion : NSObject

/**
 *  检查app的更新
 *
 *  @param atLaunch 是否在启动时检查更新
 */
+ (void)checkVersionAtLaunch:(BOOL)atLaunch;

@end
