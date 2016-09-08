//
//  ADOSyncDelete.h
//  ChinaBrowser
//
//  Created by David on 14/12/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
/**
 *  pkid_server>0，否则数据存储失败
 */

#import <Foundation/Foundation.h>

@class ModelSyncDelete;

/**
 *  删除同步数据 记录，下次同步的时候必须先向服务器发出删除指令后再从服务器上下载数据
 *  pkid
 *  sync_data_type  同步的数据类型
 *  pkid_server     同步的数据的服务器id
 *  update_time     本地删除时间
 */
@interface ADOSyncDelete : NSObject

/**
 *  检查是否存在该类型的 服务器id
 *
 *  @param pkidServer   pkidServer description
 *  @param syncDataType syncDataType description
 *  @param userId       userId description
 *
 *  @return BOOL
 */
+ (BOOL)isExistPkidServer:(NSInteger)pkidServer syncDataType:(SyncDataType)syncDataType userId:(NSInteger)userId;

/**
 *  记录删除服务器项
 *
 *  @param model ModelSyncDelete 实体对象
 *
 *  @return 添加成功后的pkid
 */
+ (NSInteger)addModel:(ModelSyncDelete *)model;

/**
 *  删除一条数据
 *
 *  @param pkid pkid description
 *
 *  @return BOOL 是否删除成功
 */
+ (BOOL)deleteWithPkid:(NSInteger)pkid;

+ (BOOL)deleteWithArrPkid:(NSArray *)arrPkid;

/**
 *  删除一条数据
 *
 *  @param pkidServer   服务器数据id
 *  @param syncDateType 同步数据类型
 *  @param userId       用户id
 *
 *  @return BOOL 是否删除成功
 */
+ (BOOL)deleteWithPkidServer:(NSInteger)pkidServer syncDataType:(SyncDataType)syncDateType userId:(NSInteger)userId;

/**
 *  查询指定用户的制定的数据类型 已删除pkidServer 拼接的字符串，多个使用英文逗号隔开
 *
 *  @param syncDateType syncDateType description
 *  @param userId       userId description
 *
 *  @return NSArray [NSString]
 */
+ (NSString *)queryPkidServerStringWithSyncDataType:(SyncDataType)syncDateType userId:(NSInteger)userId;

+ (ModelSyncDelete *)queryWithPKidServer:(NSInteger)pkidServer syncDataType:(SyncDataType)syncDateType userId:(NSInteger)userId;

/**
 *  查询指定用户的制定的数据类型 已删除pkidServer 数组
 *
 *  @param syncDateType syncDateType description
 *  @param userId       userId description
 *
 *  @return NSArray [NSString]
 */
+ (NSArray *)queryPkidServerWithSyncDataType:(SyncDataType)syncDateType userId:(NSInteger)userId;

+ (NSArray *)queryWithSyncDataType:(SyncDataType)syncDateType userId:(NSInteger)userId;

@end
