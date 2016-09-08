//
//  LocalizationUtil.h
//  ChinaBrowser
//
//  Created by David on 14-9-2.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultLanguage @"zh-Hans"
#define kDefaultFollowSystem (YES)

extern NSString * const kNotificationDidChangedAppLan;
extern NSString * const kUserInfoCurrLanguage;
extern NSString * const kUserInfoFollowSystemLanguage;

/**
 *  本地化支持，支持App内多语言设置，
 */
@interface LocalizationUtil : NSObject

/**
 *  是否跟随系统语言
 *
 *  @return BOOL
 */
+ (BOOL)followSysLan;
/**
 *  设置是否跟随系统
 *
 *  @param followSysLan YES|NO
 */
+ (void)setFollowSysLan:(BOOL)followSysLan;

/**
 *  当前的语言环境
 *
 *  @return NSString 当前语言
 */
+ (NSString *)currLanguage;
/**
 *  系统语言环境
 *
 *  @return NSString 系统语言
 */
+ (NSString *)sysLanguage;
/**
 *  App 内设语言环境
 *
 *  @return NSString App内设语言
 */
+ (NSString *)appLanguage;
/**
 *  设置App内设语言环境
 *
 *  @param appLanguage 内设语言
 */
+ (void)setAppLanguage:(NSString *)appLanguage;

/**
 *  检查App是否本地化该语言
 *
 *  @param lan 需要检查语言
 *
 *  @return BOOL
 */
+ (BOOL)isLocalizedLan:(NSString *)lan;
/**
 *  检查App是否支持该语言
 *
 *  @param lan 需要检查语言
 *
 *  @return BOOL
 */
+ (BOOL)isAppSupportLan:(NSString *)lan;

/**
 *  根据key得到App本地化的字符串
 *
 *  @param key NSString
 *
 *  @return NSString
 */
+ (NSString *)getTextByKey:(NSString *)key;

/**
 *  获取本地化的字符串
 *
 *  @param key key
 *  @param lan 语言环境
 *
 *  @return NSString
 */
+ (NSString *)getLocalization:(NSString *)key lan:(NSString *)lan;

@end

@interface NSString (Localization)

/**
 *  获取多语言本地化字符串
 *
 *  @return NSString
 */
- (NSString *)localizedString;

@end
