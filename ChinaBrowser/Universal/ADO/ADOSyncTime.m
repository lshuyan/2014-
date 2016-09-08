//
//  ADOSyncTime.m
//  ChinaBrowser
//
//  Created by David on 15/1/8.
//  Copyright (c) 2015年 KOTO Inc. All rights reserved.
//

#import "ADOSyncTime.h"

#import "DBHelper.h"

@implementation ADOSyncTime

+ (BOOL)setSyncTime:(NSInteger)syncTime withUserId:(NSInteger)userId
{
    if ([ADOSyncTime isExistWithUserId:userId]) {
        return [ADOSyncTime updateSyncTime:syncTime withUserId:userId];
    }
    else {
        return [ADOSyncTime addSyncTime:syncTime userId:userId]>0;
    }
}

+ (NSInteger)getSyncTimeWithUserId:(NSInteger)userId
{
    return [[DBHelper db] intForQuery:@"select sync_time from tab_sync_time where user_id=? and lan=?", @(userId), [LocalizationUtil currLanguage]];
}

// ----------------
+ (NSInteger)isExistWithUserId:(NSInteger)userId
{
    return [[DBHelper db] intForQuery:@"select pkid from tab_sync_time where user_id=? and lan=?", @(userId), [LocalizationUtil currLanguage]]>0;
}

+ (NSInteger)addSyncTime:(NSInteger)syncTime userId:(NSInteger)userId
{
    NSInteger pkid = -1;
    if ([ADOSyncTime isExistWithUserId:userId]) {
        return pkid;
    }
    
    if ([[DBHelper db] executeUpdate:@"insert into tab_sync_time (user_id, lan, sync_time) values (?,?,?)", @(userId), [LocalizationUtil currLanguage], @(syncTime)]) {
        pkid = (NSInteger)[[DBHelper db] lastInsertRowId];
    }
    
    return pkid;
}

+ (BOOL)updateSyncTime:(NSInteger)syncTime withUserId:(NSInteger)userId
{
    return [[DBHelper db] executeUpdate:@"update tab_sync_time set sync_time=? where user_id=? and lan=?", @(syncTime), @(userId), [LocalizationUtil currLanguage]];
}

@end
