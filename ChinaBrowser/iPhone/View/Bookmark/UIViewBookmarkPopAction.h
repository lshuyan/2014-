//
//  UIViewBookmarkPopAction.h
//  ChinaBrowser
//
//  Created by David on 14-9-25.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  书签弹出操作
 */
typedef NS_ENUM(NSInteger, BookmarkPopAction) {
    /**
     *  未知
     */
    BookmarkPopActionUnknow,
    /**
     *  添加书签
     */
    BookmarkPopActionAddBookmark,
    /**
     *  移除书签
     */
    BookmarkPopActionRemoveBookmark,
    /**
     *  添加到首页应用屏
     */
    BookmarkPopActionAddHomeApp,
    /**
     *  从首页移除
     */
    BookmarkPopActionRemoveHome
};

@protocol UIViewBookmarkPopActionDelegate;

@interface UIViewBookmarkPopAction : UIView

@property (nonatomic, weak) id<UIViewBookmarkPopActionDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *btnBookmark;
@property (nonatomic, weak) IBOutlet UIButton *btnHomeIcon;

@property (nonatomic, assign) BOOL bookmarkIsExist;
@property (nonatomic, assign) BOOL homeAppIsExist;

+ (instancetype)viewFromXib;

- (void)showInView:(UIView *)view centerOfDock:(CGPoint)centerOfDock;
- (void)dismiss;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end

@protocol UIViewBookmarkPopActionDelegate <NSObject>

- (void)viewBookmarkPopAction:(UIViewBookmarkPopAction *)viewBookmarkPopAction bookmarkPopAction:(BookmarkPopAction)bookmarkPopAction;

@end
