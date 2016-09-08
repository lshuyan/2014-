//
//  UIControllerCollectAndHistory.h
//  ChinaBrowser
//
//  Created by HHY on 14/11/7.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"
#import "UIViewNav.h"

#import "ADOBookmark.h"
#import "ADOHistory.h"

/**
 *  书签(B)/历史(H) 内容类型
 */
typedef NS_ENUM(NSInteger, BHContentType) {
    /**
     *  书签
     */
    BHContentTypeBookmark,
    /**
     *  历史
     */
    BHContentTypeHistory,
    /**
     *  子文件
     */
    BHContentTypeSubBookmark
};

@protocol UIControllerBookmarkHistoryDelegate;

@interface UIControllerBookmarkHistory: UIControllerBase <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    
    UIViewNav *_viewNav;
    
    IBOutlet UIImageView *_imageNil;
    IBOutlet UILabel *_lableNil;
    IBOutlet UIView *_viewNil;
}

@property (nonatomic, weak) id<UIControllerBookmarkHistoryDelegate> delegate;

@property (nonatomic, assign) BHContentType contentType;
/**
 *  文件夹id
 */
@property (nonatomic, assign) NSInteger parentPkid;

@property (nonatomic, strong) void (^callbackShouldUpdate)();

@end

@protocol UIControllerBookmarkHistoryDelegate <NSObject>

//点击某一书签or历史的 代理方法
- (void)controllerBookmarkHistory:(UIControllerBookmarkHistory *)controllerBookmarkHistory reqLink:(NSString *)link;

@end

