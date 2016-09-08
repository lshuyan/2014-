//
//  UIControllerImageGroup.h
//  ChinaBrowser
//
//  Created by HHY on 14/12/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//  获取相册

#import "UIControllerBase.h"

#import "UIViewNav.h"

#import <AssetsLibrary/AssetsLibrary.h>

@protocol UIControllerImageAssetsDelegate;

@interface UIControllerImageGroup : UIControllerBase<UITabBarDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    
    UIViewNav *_viewNav;
}
@property(nonatomic ,weak)id<UIControllerImageAssetsDelegate> controller;

+ (ALAssetsLibrary *)defaultAssetsLibrary;
@end
