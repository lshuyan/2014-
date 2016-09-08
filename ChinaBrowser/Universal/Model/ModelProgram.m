//
//  ModelProgram.m
//  ChinaBrowser
//
//  Created by David on 14/11/22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelProgram.h"

@implementation ModelProgram

#pragma mark - property
- (void)setTitle:(NSString *)title
{
    _title = [title isKindOfClass:[NSString class]]?title:nil;
}

- (void)setFm:(NSString *)fm
{
    _fm = [fm isKindOfClass:[NSString class]]?fm:nil;
}

- (void)setLink:(NSString *)link
{
    _link = [link isKindOfClass:[NSString class]]?link:nil;
}

#pragma mark - instance
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lan = [LocalizationUtil currLanguage];
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        self.pkid_server = [dict[@"pid"] integerValue];
        self.parent_pkid_server = [dict[@"p_pkid"] integerValue];
        self.lan = [LocalizationUtil currLanguage];
        
        self.srcType = [dict[@"type"] integerValue];
        self.title = dict[@"title"];
        self.link = dict[@"link"];
        self.fm = dict[@"fm"];
        self.time = [dict[@"time"] integerValue];
        self.recommendCateId = [dict[@"recommend_catid"] integerValue];
        
        NSArray *arrSubProgram = dict[@"plist"];
        
        if ([arrSubProgram isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrItem = [NSMutableArray arrayWithCapacity:arrSubProgram.count];
            for (NSDictionary *dictItem in arrSubProgram) {
                ModelProgram *model = [ModelProgram modelWithDict:dictItem];
                model.parent_pkid_server = _pkid_server;
                model.link = _link;
                model.srcType = _srcType;
                model.fm = _fm;
                [arrItem addObject:model];
            }
            _arrSubProgram = arrItem;
        }
        else {
            _arrSubProgram = nil;
        }
    }
    return self;
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super initWithResultSetDict:dict];
    if (self) {
        self.pkid = [dict[@"pkid"] integerValue];
        self.pkid_server = [dict[@"pkid_server"] integerValue];
        self.parent_pkid_server = [dict[@"parent_pkid_server"] integerValue];
        self.lan = dict[@"lan"];
        
        self.srcType = [dict[@"type"] integerValue];
        self.title = dict[@"title"];
        self.link = dict[@"link"];
        self.fm = dict[@"fm"];
        self.time = [dict[@"time"] integerValue];
        self.recommendCateId = [dict[@"recommend_catid"] integerValue];
        
    }
    return self;
}

@end