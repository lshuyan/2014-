//
//  ModelSyncBase.h
//  ChinaBrowser
//
//  Created by David on 14/11/21.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

/**
 *  同步实体基类
 */
@interface ModelSyncBase : ModelBase

/**
 *  本地数据库 pkid
 */
@property (nonatomic, assign) NSInteger pkid;
/**
 *  服务器数据库 pkid
 */
@property (nonatomic, assign) NSInteger pkid_server;
/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger userid;
/**
 *  语言环境
 */
@property (nonatomic, strong) NSString *lan;

/**
 *  最后的更新时间
 */
@property (nonatomic, assign) NSInteger updateTime;
/**
 *  最后的更新时间，服务器上的
 */
@property (nonatomic, assign) NSInteger updateTimeServer;

@end
