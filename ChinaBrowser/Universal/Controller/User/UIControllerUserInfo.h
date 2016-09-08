//
//  UIControllerUserInfo.h
//  ChinaBrowser
//
//  Created by HHY on 14/10/31.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

#import "UIViewNav.h"
#import "ModelUser.h"

@interface UIControllerUserInfo : UIControllerBase<UITabBarDelegate, UITableViewDataSource>
{
    UIViewNav *_viewNav;
    IBOutlet UITableView *_tableView;
}

@property (nonatomic, assign) FromController fromController;

//第三方登录type , 用于注销第三方登录
@property (nonatomic, assign) ShareType type;

@end
