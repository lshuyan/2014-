//
//  ADOProgram.h
//  ChinaBrowser
//
//  Created by David on 14/11/22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelProgram;

@interface ADOProgram : NSObject

/**
 *  检查指定条件的数据是否存在
 *
 *  @param pkidServer 服务器id
 *
 *  @return BOOL
 */
+ (BOOL)isExistWithPkidServer:(NSInteger)pkidServer;

/**
 *  添加一条数据
 *
 *  @param model ModelProgram
 *
 *  @return NSInteger pkid 添加数据的pkid
 */
+ (NSInteger)addModel:(ModelProgram *)model;

/**
 *  查找指定的一条数据
 *
 *  @param pkid
 *
 *  @return ModelProgram
 */
+ (ModelProgram *)queryWithPkid:(NSInteger)pkid;

/**
 *  查找指定的一条数据
 *
 *  @param pkidServer
 *
 *  @return ModelProgram
 */
+ (ModelProgram *)queryWithPkidServer:(NSInteger)pkidServer;

/**
 *  查询指定用户的一组数据
 *
 *  @return NSArray
 */
+ (NSArray *)queryAll;

/**
 *  删除一条数据
 *
 *  @param pkid
 *
 *  @return BOOL
 */
+ (BOOL)deleteWithPkid:(NSInteger)pkid;

/**
 *  删除一条数据
 *
 *  @param pkidServer
 *
 *  @return BOOL
 */
+ (BOOL)deleteWithPkidServer:(NSInteger)pkidServer;

/**
 *  清空数据表
 *
 *  @return BOOL
 */
+ (BOOL)clear;

+ (BOOL)updateParentPkidServer:(NSInteger)parentPkidServer withPkidServer:(NSInteger)pkidServer;

@end