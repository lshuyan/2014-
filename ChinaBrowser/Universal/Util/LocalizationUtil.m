//
//  LocalizationUtil.m
//  ChinaBrowser
//
//  Created by David on 14-9-2.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "LocalizationUtil.h"

NSString * const kNotificationDidChangedAppLan = @"NotificationDidChangedAppLan";
NSString * const kUserInfoCurrLanguage = @"kUserInfoCurrLanguage";
NSString * const kUserInfoFollowSystemLanguage = @"kUserInfoFollowSystemLanguage";

@implementation LocalizationUtil

+ (BOOL)followSysLan
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoFollowSystemLanguage]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:kUserInfoFollowSystemLanguage];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:kDefaultFollowSystem forKey:kUserInfoFollowSystemLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return kDefaultFollowSystem;
    }
}

+ (void)setFollowSysLan:(BOOL)followSysLan
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:followSysLan forKey:kUserInfoFollowSystemLanguage];
    [ud synchronize];
}

+ (NSString *)currLanguage
{
    if ([LocalizationUtil followSysLan]) {
        NSString *lan = [LocalizationUtil sysLanguage];
        if (![LocalizationUtil isAppSupportLan:lan]) {
            lan = kDefaultLanguage;
        }
        return lan;
    }
    else {
        return [LocalizationUtil appLanguage];
    }
}

+ (NSString *)sysLanguage
{
    NSString *lan = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    return lan;
}

+ (NSString *)appLanguage
{
    NSString *lan = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoCurrLanguage];
    if (!lan) {
        lan = kDefaultLanguage;
        [[NSUserDefaults standardUserDefaults] setObject:lan forKey:kUserInfoCurrLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return lan;
}

+ (void)setAppLanguage:(NSString *)appLanguage
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:appLanguage forKey:kUserInfoCurrLanguage];
    [ud synchronize];
}

+ (BOOL)isLocalizedLan:(NSString *)lan
{
    NSString *table = [NSString stringWithFormat:@"%@.lproj/Localizable", lan];
    NSString *file = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@.strings", table];
    return [[NSFileManager defaultManager] fileExistsAtPath:file];
}

+ (BOOL)isAppSupportLan:(NSString *)lan
{
    NSArray *arrLan = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lan_localizable" ofType:@"plist"]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.enable = true and self.lan = %@", lan];
    NSArray *arrSupportLan = [arrLan filteredArrayUsingPredicate:predicate];
    BOOL isSupport = [arrSupportLan filteredArrayUsingPredicate:predicate].count>0?YES:NO;
    return isSupport;
}

+ (NSString *)getTextByKey:(NSString *)key
{
    return [LocalizationUtil getLocalization:key lan:[LocalizationUtil currLanguage]];
}

+ (NSString *)getLocalization:(NSString *)key lan:(NSString *)lan
{
    NSString *table = [NSString stringWithFormat:@"%@.lproj/Localizable", lan];
    NSString *file = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@.strings", table];
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        table = [NSString stringWithFormat:@"%@.lproj/Localizable", kDefaultLanguage];
    }
//    [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@{}];
    return NSLocalizedStringFromTable(key, table, nil);
}

@end



@implementation NSString (Localization)

/**
 *  获取多语言本地化字符串
 *
 *  @return NSString
 */
- (NSString *)localizedString
{
    return [LocalizationUtil getTextByKey:self];
}

@end
