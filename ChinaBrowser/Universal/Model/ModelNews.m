//
//  ModelNews.m
//  ChinaBrowser
//
//  Created by David on 14-4-30.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelNews.h"

@implementation ModelNews

#pragma mark - property
- (void)setTitle:(NSString *)title
{
    _title = [title isKindOfClass:[NSString class]]?title:nil;
}

- (void)setDescr:(NSString *)descr
{
    _descr = [descr isKindOfClass:[NSString class]]?descr:nil;
}

- (void)setRefinfo:(NSString *)refinfo
{
    _refinfo = [refinfo isKindOfClass:[NSString class]]?refinfo:nil;
}

- (void)setImage:(NSString *)image
{
    _image = [image isKindOfClass:[NSString class]]?image:nil;
}

- (void)setTime:(NSString *)time
{
    _time = [time isKindOfClass:[NSString class]]?time:nil;
}

- (void)setLink:(NSString *)link
{
    _link = [link isKindOfClass:[NSString class]]?link:nil;
}

#pragma mark - instance
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.newsId = [dict[@"id"] integerValue];
        self.title = dict[@"title"];
        self.descr = dict[@"descr"];
        self.link = dict[@"link"];
        self.refinfo = dict[@"refinfo"];
        self.image = dict[@"thumb"];
        self.time = dict[@"time"];
    }
    return self;
}

@end
