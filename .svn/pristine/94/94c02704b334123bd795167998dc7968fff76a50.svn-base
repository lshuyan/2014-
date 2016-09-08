//
//  ADOLinkIcon.m
//  ChinaBrowser
//
//  Created by David on 14/12/17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ADOLinkIcon.h"

#import "DBHelper.h"

@implementation ADOLinkIcon

+ (BOOL)isExistWithLink:(NSString *)link
{
    return [[DBHelper db] intForQuery:@"select pkid from tab_link_icon where link=?", link]>0;
}

+ (BOOL)addLink:(NSString *)link icon:(NSString *)icon
{
    return [[DBHelper db] executeUpdate:@"insert into tab_link_icon (link, icon) values (?,?)", link?:@"", icon?:@""];
}

+ (BOOL)updateWithLink:(NSString *)link icon:(NSString *)icon
{
    return [[DBHelper db] executeUpdate:@"update tab_link_icon set icon=? where link=?", icon?:@"", link?:@""];
}

+ (NSString *)queryWithLink:(NSString *)link
{
    return [[DBHelper db] stringForQuery:@"select icon from tab_link_icon where link=?", link?:@""];
}

@end
