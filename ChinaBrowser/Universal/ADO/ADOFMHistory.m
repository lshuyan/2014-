//
//  ADOFMHistory.m
//  ChinaBrowser
//
//  Created by David on 14/12/3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ADOFMHistory.h"

#import "DBHelper.h"
#import "ModelFMHistory.h"

@implementation ADOFMHistory

+ (BOOL)isExistWithUserId:(NSInteger)userId
{
    return [[DBHelper db] intForQuery:@"select pkid from tab_fm_history where user_id=? and lan=?", @(userId), [LocalizationUtil currLanguage]]>0;
}

+ (NSInteger)addModel:(ModelFMHistory *)modelFMHistory
{
    NSInteger lastPkid = -1;
    BOOL flag = [[DBHelper db] executeUpdate:@"insert into tab_fm_history (user_id, lan, mode_pkid, mode_program_pkid) values (?,?,?,?)", @(modelFMHistory.userid), [LocalizationUtil currLanguage], @(modelFMHistory.modePkid), @(modelFMHistory.modeProgramPkid)];
    if (flag) {
        lastPkid = (NSInteger)[[DBHelper db] lastInsertRowId];
    }
    return lastPkid;
}

+ (BOOL)updateModePkid:(NSInteger)modePkid withUserId:(NSInteger)userId
{
    return [[DBHelper db] executeUpdate:@"update tab_fm_history set mode_pkid=? where user_id=? and lan=?", @(modePkid), @(userId), [LocalizationUtil currLanguage]];
}

+ (BOOL)updateModeProgramPkid:(NSInteger)modeProgramPkid withUserId:(NSInteger)userId
{
    return [[DBHelper db] executeUpdate:@"update tab_fm_history set mode_program_pkid=? where user_id=? and lan=?", @(modeProgramPkid), @(userId), [LocalizationUtil currLanguage]];
}

+ (BOOL)updateModePkid:(NSInteger)modePkid modeProgramPkid:(NSInteger)modeProgramPkid withUserId:(NSInteger)userId
{
    return [[DBHelper db] executeUpdate:@"update tab_fm_history set mode_pkid=?, mode_program_pkid=? where user_id=? and lan=?", @(modePkid), @(modeProgramPkid), @(userId), [LocalizationUtil currLanguage]];
}

+ (BOOL)deleteWithUserId:(NSInteger)userId
{
    return [[DBHelper db] executeUpdate:@"delete from tab_fm_history where user_id=? and lan=?", @(userId), [LocalizationUtil currLanguage]];
}

+ (BOOL)clear
{
    return [[DBHelper db] executeUpdate:@"delete from tab_fm_history where lan=?", [LocalizationUtil currLanguage]];
}

+ (BOOL)clearWithUserId:(NSInteger)userId
{
    return [[DBHelper db] executeUpdate:@"delete from tab_fm_history where lan=? and user_id=?", [LocalizationUtil currLanguage], @(userId)];
}

+ (ModelFMHistory *)queryWithUserId:(NSInteger)userId
{
    ModelFMHistory *model = nil;
    FMResultSet *resultSet = [[DBHelper db] executeQuery:@"select * from tab_fm_history where user_id=? and lan=?", @(userId), [LocalizationUtil currLanguage]];
    while ([resultSet next]) {
        model = [ModelFMHistory modelWithResultSetDict:[resultSet resultDictionary]];
        break;
    }
    return model;
}

+ (ModelFMHistory *)queryWithModePkid:(NSInteger)modePkid
{
    ModelFMHistory *model = nil;
    FMResultSet *resultSet = [[DBHelper db] executeQuery:@"select * from tab_fm_history where mode_pkid=? and lan=?", @(modePkid), [LocalizationUtil currLanguage]];
    while ([resultSet next]) {
        model = [ModelFMHistory modelWithResultSetDict:[resultSet resultDictionary]];
        break;
    }
    return model;
}

@end
