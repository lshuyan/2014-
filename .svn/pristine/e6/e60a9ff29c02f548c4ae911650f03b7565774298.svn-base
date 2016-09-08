//
//  ADOHistory.h
//  ChinaBrowser
//
//  Created by David on 14/11/3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelHistory.h"

@interface ADOHistory : NSObject

/**
 *  判断是否存在
 *
 *  @param link 连接地址/功能模块的地址
 *  @param urlSchemes urlSchemes
 *
 *  @return BOOL
 */
+ (BOOL)isExistWithlink:(NSString *)link userId:(NSInteger)userId;

/**
 *  添加
 *
 *  @param model ModelApp
 *
 *  @return NSInteger  最后添加的id； <= 0，表示错误； > 0 表示添加成功
 */
+ (NSInteger)addModel:(ModelHistory *)model;

/**
 *  根据链接地址查询一条记录
 *
 *  @param link 链接地址
 *
 *  @return ModelHistory
 */
+ (ModelHistory *)queryWithLink:(NSString *)link userId:(NSInteger)userId;

+ (ModelHistory *)queryWithLink:(NSString *)link userId:(NSInteger)userId exceptPkid:(NSInteger)exceptPkid;

+ (ModelHistory *)queryWithPkidServer:(NSInteger)pkidServer userId:(NSInteger)userId;

/**
 *  根据链接和所属用户id查找pkid
 *
 *  @param link   链接地址
 *  @param userId 所属用户id
 *
 *  @return NSInteger 返回pkid，>0 表示存在，否则不存在
 */
+ (NSInteger)queryPkidWithLink:(NSString *)link userId:(NSInteger)userId;

+ (BOOL)updateTitle:(NSString *)title time:(NSInteger)time updateTime:(NSInteger)updateTime withLink:(NSString *)link userId:(NSInteger)userId;
/**
 *  网服务器添加数据后，需要修改服务器id
 *
 *  @param pkidServer pkidServer description
 *  @param pkid       pkid description
 *
 *  @return BOOL
 */
+ (BOOL)updatePkidServer:(NSInteger)pkidServer withPkid:(NSInteger)pkid;

+ (BOOL)updatePkidServer:(NSInteger)pkidServer updateTimeServer:(NSInteger)updateTimeServer withPkid:(NSInteger)pkid;

+ (BOOL)updateModel:(ModelHistory *)model;

/**
 *  查询所有书签及文件夹
 *
 *  @return NSArray 所有
 */
+ (NSArray *)queryAllWithUserId:(NSInteger)userId;

/**
 *  查询最近浏览的指定数量的历史记录
 *
 *  @param number 数量
 *  @param userId 用户id
 *
 *  @return NSArray
 */
+ (NSArray *)queryLastNumber:(NSInteger)number withUserId:(NSInteger)userId;

/**
 *  删除
 *
 *  @param 唯一键
 *
 *  @return BOOL
 */
+ (BOOL)deleteWithPkid:(NSInteger)pkid;

+ (BOOL)deleteWithArrPkidServer:(NSArray *)arrPkidServer userId:(NSInteger)userId;

/**
 *  清空数据表
 *
 *  @return BOOL 是否成功
 */
//+ (BOOL)clear;

+ (BOOL)clearWithUserId:(NSInteger)userId;

@end
