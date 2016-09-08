//
//  ModelProgram.h
//  ChinaBrowser
//
//  Created by David on 14/11/22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

@interface ModelProgram : ModelBase


/**
 *  语言环境
 */
@property (nonatomic, copy) NSString *lan;

/**
 *  pkid
 */
@property (nonatomic, assign) NSInteger pkid;
/**
 *  服务器pkid
 */
@property (nonatomic, assign) NSInteger pkid_server;
/**
 *  父级 pkid_server
 */
@property (nonatomic, assign) NSInteger parent_pkid_server;
/**
 *  节目资源类型
 */
@property (nonatomic, assign) ProgramSrcType srcType;
/**
 *  节目播放时间
 */
@property (nonatomic, assign) NSInteger time;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  链接地址
 */
@property (nonatomic, copy) NSString *link;
/**
 *  电台频道名 eg：FM89.1
 */
@property (nonatomic, copy) NSString *fm;
/**
 *  推荐分类
 */
@property (nonatomic, assign) NSInteger recommendCateId;

/**
 *  子节目
 */
@property (nonatomic, strong) NSArray *arrSubProgram;


@end
