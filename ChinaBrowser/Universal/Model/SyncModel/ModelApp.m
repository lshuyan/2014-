//
//  ModelApp.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelApp.h"

@implementation ModelApp

#pragma mark - property
- (void)setTitle:(NSString *)title
{
    _title = [title isKindOfClass:[NSString class]]?title:nil;
}

- (void)setLink:(NSString *)link
{
    _link = [link isKindOfClass:[NSString class]]?link:nil;
}

- (void)setIcon:(NSString *)icon
{
    _icon = [icon isKindOfClass:[NSString class]]?icon:nil;
}

- (void)setUrlSchemes:(NSString *)urlSchemes
{
    _urlSchemes = [urlSchemes isKindOfClass:[NSString class]]?urlSchemes:nil;
}

- (void)setPackage:(NSString *)package
{
    _package = [package isKindOfClass:[NSString class]]?package:nil;
}

- (void)setDownloadLink:(NSString *)downloadLink
{
    _downloadLink = [downloadLink isKindOfClass:[NSString class]]?downloadLink:nil;
}

#pragma mark - instance
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
        NSString *szType = dict[@"type"];
        if ([szType isKindOfClass:[NSString class]]) {
            if ([szType isEqualToString:@"web"]) {
                self.appType = AppTypeWeb;
            }
            else if ([szType isEqualToString:@"app"]) {
                self.appType = AppTypeNative;
            }
            else if ([szType isEqualToString:@"func"]) {
                self.appType = AppTypeFunc;
            }
        }
        self.icon = dict[@"icon"];
        self.title = dict[@"title"];
        self.link = dict[@"link"];
        self.urlSchemes = dict[@"urlschemes"];
        self.downloadLink = dict[@"app_download"];
    }
    return self;
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super initWithResultSetDict:dict];
    if (self) {
        self.appType = [dict[@"app_type"] integerValue];
        self.title = dict[@"name"];
        self.link = dict[@"link"];
        self.icon = dict[@"icon"];
        self.urlSchemes = dict[@"url_schemes"];
        self.package = dict[@"package"];
        self.downloadLink = dict[@"download_link"];
        self.sortIndex = [dict[@"sort_index"] integerValue];
    }
    return self;
}

@end
