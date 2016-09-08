//
//  UIControllerEditNick.h
//  ChinaBrowser
//
//  Created by HHY on 14/11/3.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewNav.h"

#import "UIControllerBase.h"
@protocol UIControllerEdintNickDelegate;

@interface UIControllerEditNick : UIControllerBase<UITabBarDelegate, UITableViewDataSource>
{
    
    IBOutlet UITableView *_tableView;
    UIViewNav *_viewNav;
}

@property (nonatomic ,weak) id<UIControllerEdintNickDelegate> delegate;

@end

@protocol UIControllerEdintNickDelegate<NSObject>

- (void)controller:(UIControllerEditNick *)controller edinNick:(NSString *)nick;

@end