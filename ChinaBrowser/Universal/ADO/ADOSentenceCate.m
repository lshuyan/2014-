//
//  ADOSentenceCate.m
//  ChinaBrowser
//
//  Created by David on 14-9-6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ADOSentenceCate.h"

@implementation ADOSentenceCate

static int QueryCallback (void *result, int colCount, char **data, char **colName)
{
    NSMutableArray *arrResult = (__bridge NSMutableArray *)result;
    ModelSentenceCate *model = [ModelSentenceCate model];
    model.cid = atoi(data[0]);
    model.pcid = atoi(data[1]);
    char *
    value = data[2];
    if (value) model.name = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    [arrResult addObject:model];
    return 0;
}

+ (BOOL)isExistWithName:(NSString *)name pcid:(NSInteger)pcid
{
    const char *filename = [TRANS_DBPATH UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_sentence_cate where name=\"%@\" and pcid = %ld", name, (long)pcid] UTF8String];
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, callback, (__bridge void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult.count>0;
}

+ (NSInteger)addModel:(ModelSentenceCate *)model
{
    if ([ADOSentenceCate isExistWithName:model.name pcid:model.pcid]) {
        return 0;
    }
    NSInteger lastInsertId = 0;
    const char *filename = [TRANS_DBPATH UTF8String];
    sqlite3 *db;
    const char *sql = [[NSString stringWithFormat:@"insert into tab_sentence_cate (pcid, name) values (%ld, \"%@\")", (long)model.pcid, model.name?:@""] UTF8String];
    char *msg=nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, nil, nil, &msg)) {
            break;
        }
    } while (NO);
    
    lastInsertId = (NSInteger)sqlite3_last_insert_rowid(db);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return lastInsertId;
}

+ (NSArray *)queryAll
{
    const char *filename = [TRANS_DBPATH UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_sentence_cate order by cid"] UTF8String];
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, callback, (__bridge void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult;
}

+ (NSArray *)queryWithPcid:(NSInteger)pcid
{
    const char *filename = [TRANS_DBPATH UTF8String];
    sqlite3 *db = nil ;
    const char *sql = [[NSString stringWithFormat:@"select * from tab_sentence_cate where pcid=%ld order by cid", (long)pcid] UTF8String];
    sqlite3_callback callback = QueryCallback;
    NSMutableArray *arrResult = [NSMutableArray array];
    char *msg = nil;
    do {
        if (SQLITE_OK!=sqlite3_open(filename, &db))
            break;
        if (SQLITE_OK!=sqlite3_exec(db, sql, callback, (__bridge void*)arrResult, &msg))
            break;
    } while (NO);
    
    if (msg) sqlite3_free(msg);
    if (db) sqlite3_close(db);
    
    return arrResult;
}

@end
