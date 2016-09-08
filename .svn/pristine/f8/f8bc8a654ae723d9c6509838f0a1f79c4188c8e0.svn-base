//
//  ADOUserPassword.m
//  ChinaBrowser
//
//  Created by huyan on 14/12/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ADOUserPassword.h"

#import "DBHelper.h"

#import <AGCommon/NSString+Common.h>

@implementation ADOUserPassword

/**
 *  判断是否存在
 *
 *  @param UserName 用户名
 *
 *  @return BOOL
 */
+ (BOOL)isExistWithUserName:(NSString *)userName
{
    
    NSInteger pkid = [[DBHelper shareDBHelper].db intForQuery:@"select pkid from tab_user_password where user_name=? and lan=? ", userName?:@"", [LocalizationUtil currLanguage]];
    return pkid>0;
}

/**
 *  添加
 *
 *  @param userName 用户名
 *  @param password 密码
 *
 *  @return NSInteger  最后添加的id； <= 0，表示错误； > 0 表示添加成功
 */
+ (NSInteger)addUserName:(NSString *)userName password:(NSString *)password
{
    //密码加密
    NSString *encodePassword = [password base64Encode:NSUTF32StringEncoding];

    NSInteger lastInsertId = -1;
    
    BOOL flag = [[DBHelper shareDBHelper].db executeUpdate:@"insert into tab_user_password (user_name, password, lan) values (?,?,?)", userName?:@"", encodePassword?:@"", [LocalizationUtil currLanguage]];
    if (flag) {
        lastInsertId = (NSInteger)[[DBHelper shareDBHelper].db lastInsertRowId];
    }
    return lastInsertId;
}

/**
 *  通过用户名,更新密码
 *
 *  @param password 需要更新的密码
 *
 *  @param username 用户名
 *
 *  @return BOOL
 */
+ (BOOL)updatePassword:(NSString *)password withUserName:(NSString *)userName
{
    //密码加密
    NSString *encodePassword = [password base64Encode:NSUTF32StringEncoding];
    
    return [[DBHelper shareDBHelper].db executeUpdate:@"update tab_user_password set password=? where user_name=? and lan=?", encodePassword, userName, [LocalizationUtil currLanguage]];
}

/**
 *  按用户名查询数据
 *
 *  @param 用户名
 *
 *  @return
 */
+ (ModelUserPassword *)queryWithUserName:(NSString *)userName
{
    ModelUserPassword *model = nil;
    FMResultSet *set = [[DBHelper shareDBHelper].db executeQuery:@"select * from tab_user_password where user_name=? and lan=?", userName, [LocalizationUtil currLanguage]];
    while ([set next]) {
        model= [ModelUserPassword modelWithResultSetDict:[set resultDictionary]];
        break;
    }
    return model;
}

/**
 *  删除
 *
 *  @param username 用户名
 *
 *  @return BOOL
 */
+ (BOOL)deleteWithUserName:(NSString *)userName
{
    return [[DBHelper shareDBHelper].db executeUpdate:@"delete from tab_user_password where user_name=? and lan=?", userName, [LocalizationUtil currLanguage]];
}

/**
 *  清除用户密码
 *
 *  @return BOOL
 */
+ (BOOL)clear
{
    return [[DBHelper shareDBHelper].db executeUpdate:@"delete from tab_user_password where lan=?", [LocalizationUtil currLanguage]];
}

@end
