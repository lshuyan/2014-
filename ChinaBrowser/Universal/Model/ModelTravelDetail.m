//
//  ModelTravelDetail.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelTravelDetail.h"

@implementation ModelTravelDetail

#pragma mark - property
- (void)setName:(NSString *)name
{
    _name = [name isKindOfClass:[NSString class]]?name:nil;
}

- (void)setImage:(NSString *)image
{
    _image = [image isKindOfClass:[NSString class]]?image:nil;
}

- (void)setVideoLink:(NSString *)videoLink
{
    _videoLink = [videoLink isKindOfClass:[NSString class]]?videoLink:nil;
}

- (void)setVideoThumb:(NSString *)videoThumb
{
    _videoThumb = [videoThumb isKindOfClass:[NSString class]]?videoThumb:nil;
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
        self.mediaType = (TravelMediaType)[dict[@"type"] integerValue];
        self.name = dict[@"name"];
        self.image = dict[@"img"];
        self.videoLink = dict[@"video"];
        self.videoThumb = dict[@"video_thumb"];
        self.link = dict[@"link"];
        self.imageSize = CGSizeMake([dict[@"w"] floatValue], [dict[@"h"] floatValue]);
    }
    return self;
}

@end
