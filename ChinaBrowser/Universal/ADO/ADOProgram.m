//
//  ADOProgram.m
//  ChinaBrowser
//
//  Created by David on 14/11/22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ADOProgram.h"

#import "DBHelper.h"
#import "ModelProgram.h"

@implementation ADOProgram

/**
 *  检查指定条件的数据是否存在
 *
 *  @param pkidServer 服务器id
 *
 *  @return BOOL
 */
+ (BOOL)isExistWithPkidServer:(NSInteger)pkidServer
{
    NSInteger pkid = [[DBHelper shareDBHelper].db intForQuery:@"select pkid from tab_program where pkid_server=? and lan=?", @(pkidServer), [LocalizationUtil currLanguage]];
    return pkid>0;
}

/**
 *  添加一条数据
 *
 *  @param model ModelProgram
 *
 *  @return NSInteger pkid 添加数据的pkid
 */
+ (NSInteger)addModel:(ModelProgram *)model
{
    NSInteger lastInsertId = -1;
    if ([ADOProgram isExistWithPkidServer:model.pkid_server]) {
        return lastInsertId;
    }
    
    BOOL flag = [[DBHelper shareDBHelper].db executeUpdate:@"insert into tab_program (pkid_server, parent_pkid_server, lan, type, time, title, link, fm, recommend_catid) values (?,?,?,?,?,?,?,?,?)", @(model.pkid_server), @(model.parent_pkid_server), [LocalizationUtil currLanguage], @(model.srcType), @(model.time), model.title, model.link, model.fm, @(model.recommendCateId)];
    if (flag) {
        lastInsertId = (NSInteger)[[DBHelper shareDBHelper].db lastInsertRowId];
    }
    return lastInsertId;
}

/**
 *  查找指定的一条数据
 *
 *  @param pkid
 *
 *  @return ModelProgram
 */
+ (ModelProgram *)queryWithPkid:(NSInteger)pkid
{
    ModelProgram *model = nil;
    FMResultSet *set = [[DBHelper shareDBHelper].db executeQuery:@"select * from tab_program where pkid = ?", @(pkid)];
    while ([set next]) {
        model= [ModelProgram modelWithResultSetDict:[set resultDictionary]];
        break;
    }
    return model;
}

/**
 *  查找指定的一条数据
 *
 *  @param pkidServer
 *
 *  @return ModelProgram
 */
+ (ModelProgram *)queryWithPkidServer:(NSInteger)pkidServer
{
    ModelProgram *model = nil;
    FMResultSet *set = [[DBHelper shareDBHelper].db executeQuery:@"select * from tab_program where pkid_server=? and lan=?", @(pkidServer), [LocalizationUtil currLanguage]];
    while ([set next]) {
        model= [ModelProgram modelWithResultSetDict:[set resultDictionary]];
        break;
    }
    return model;
}

/**
 *  查询指定用户的一组数据
 *
 *  @return NSArray
 */
+ (NSArray *)queryAll
{
    NSMutableArray *arrResult = [NSMutableArray array];
    FMResultSet *set = [[DBHelper shareDBHelper].db executeQuery:@"select * from tab_program and lan=?", [LocalizationUtil currLanguage]];
    while ([set next]) {
        ModelProgram *model = [ModelProgram modelWithResultSetDict:[set resultDictionary]];
        [arrResult addObject:model];
    }
    return arrResult;
}

/**
 *  删除一条数据
 *
 *  @param pkid
 *
 *  @return BOOL
 */
+ (BOOL)deleteWithPkid:(NSInteger)pkid
{
    return [[DBHelper shareDBHelper].db executeUpdate:@"delete from tab_program where pkid=?", @(pkid)];
}

/**
 *  删除一条数据
 *
 *  @param pkidServer
 *
 *  @return BOOL
 */
+ (BOOL)deleteWithPkidServer:(NSInteger)pkidServer
{
    return [[DBHelper shareDBHelper].db executeUpdate:@"delete from tab_program where pkid_server=? and lan=?", @(pkidServer), [LocalizationUtil currLanguage]];
}

/**
 *  清空数据表
 *
 *  @return BOOL
 */
+ (BOOL)clear
{
    return [[DBHelper shareDBHelper].db executeUpdate:@"delete from tab_program where lan=?", [LocalizationUtil currLanguage]];
}

+ (BOOL)updateParentPkidServer:(NSInteger)parentPkidServer withPkidServer:(NSInteger)pkidServer
{
    return [[DBHelper shareDBHelper].db executeUpdate:@"update tab_program set parent_pkid_server=? where pkid_server=? and lan=?", @(parentPkidServer), @(pkidServer), [LocalizationUtil currLanguage]];
}

@end