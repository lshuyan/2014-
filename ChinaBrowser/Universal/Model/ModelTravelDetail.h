//
//  ModelTravelDetail.h
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

/**
 *  旅游模块多媒体类型
 */
typedef NS_ENUM(NSInteger, TravelMediaType) {
    /**
     *  视频
     */
    TravelMediaTypeVideo = 1,
    /**
     *  图片
     */
    TravelMediaTypeImage = 2
};

/**
 *  旅游详细
 */
@interface ModelTravelDetail : ModelBase

@property (nonatomic, assign) TravelMediaType mediaType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *videoLink;
@property (nonatomic, strong) NSString *videoThumb;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) CGSize imageSize;

@end
