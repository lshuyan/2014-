//
//  ModelNews.h
//  ChinaBrowser
//
//  Created by David on 14-4-30.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

@interface ModelNews : ModelBase

@property (nonatomic, assign) NSInteger pkid;
@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *refinfo;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *link;

@end
