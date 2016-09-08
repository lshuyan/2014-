//
//  NSStringEx.h
//  ChinaBrowser
//
//  Created by David on 2011-11-11.
//  Copyright 2011 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringEx)

BOOL IsValidMobilePhoneNum(NSString *phoneNum);
BOOL IsValidEmail(NSString *emailStr, BOOL strictFilter);
BOOL IsValidPassword(NSString *phoneNum);

NSString * UnicodeStrToUtf8Str(NSString *unicodeStr);
NSString * Utf8StrToUnicodeStr(NSString *utf8Str);

/**
 *  判断是否url地址
 *
 *  @return BOOL
 */
- (BOOL)isURLString;

+ (NSString *)signWithParams:(NSDictionary *)dic;

+ (NSString *)sha1:(NSString *)str;

- (NSString*)md5;

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval;

- (NSString*)fileNameMD5WithExtension:(NSString*)extension;

@end

