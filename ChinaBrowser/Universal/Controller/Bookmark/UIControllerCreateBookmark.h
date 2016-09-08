//
//  UIControllerCreateBookmark.h
//  ChinaBrowser
//
//  Created by HHY on 14/11/10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

/**
 *  新建书签or收藏夹
 */
typedef NS_ENUM(NSInteger, BookmarkActionType) {
    /**
     *  新建书签
     */
    BookmarkActionTypeNewBookmark,
    /**
     *  新建文件
     */
    BookmarkActionTypeNewFolder,
    /**
     *  编辑书签
     */
    BookmarkActionTypeEditBookmark,
    /**
     *  编辑书签文件夹
     */
    BookmarkActionTypeEditFolder
};

@class ModelBookmark;

@interface UIControllerCreateBookmark : UIControllerBase<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BookmarkActionType type;

/**
 *  新建书签/新建书签文件夹 一定要设置
 */
@property (nonatomic, assign) NSInteger parentPkidOfNew;

/**
 *  编辑书签/编辑书签文件夹 一定要设置
 */
@property (nonatomic, strong) ModelBookmark *modelEdit;

@property (nonatomic, strong) void (^callbackDidNewBookmark)(ModelBookmark *);
@property (nonatomic, strong) void (^callbackDidEditBookmark)(ModelBookmark *);

@end