//
//  ADOLinkIcon.h
//  ChinaBrowser
//
//  Created by David on 14/12/17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADOLinkIcon : NSObject

+ (BOOL)isExistWithLink:(NSString *)link;
+ (BOOL)addLink:(NSString *)link icon:(NSString *)icon;

+ (BOOL)updateWithLink:(NSString *)link icon:(NSString *)icon;
+ (NSString *)queryWithLink:(NSString *)link;

@end
