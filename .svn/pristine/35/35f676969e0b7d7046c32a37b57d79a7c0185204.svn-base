//
//  ModelRecommend.h
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

/**
 *  推荐类型
 */
typedef NS_ENUM(NSInteger, RecommendType) {
    /**
     *  新闻分类
     */
    RecommendTypeNewsCate = 1,
    /**
     *  网址(链接)
     */
    RecommendTypeLink = 2,
    /**
     *  推荐子分类
     */
    RecommendTypeSubCate = 3,
    /**
     *  直播流
     */
    RecommendTypeLiveStream = 4
};

/**
 *  推荐分类
 */
@interface ModelRecommend : ModelBase

/**
 *  分类名称
 */
@property (nonatomic, strong) NSString *name;
/**
 *  连接地址
 */
@property (nonatomic, strong) NSString *link;
/**
 *  图标
 */
@property (nonatomic, strong) NSString *icon;
/**
 *  颜色
 */
@property (nonatomic, strong) NSString *color;
/**
 *  分类id
 */
@property (nonatomic, assign) NSInteger catId;
/**
 *  推荐类型
 */
@property (nonatomic, assign) RecommendType type;

@end
