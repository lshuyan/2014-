//
//  UIScrollViewAppItemList.h
//  ChinaBrowser
//
//  Created by 石显军 on 14/11/17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelApp;

@interface UIScrollViewAppItemList : UIScrollView

@property (nonatomic, strong) NSMutableArray *appList;

@property (nonatomic, strong) void (^callbackAddApp)(ModelApp *);
@property (nonatomic, strong) BOOL (^callbackIsExistApp)(ModelApp *);
@property (nonatomic, strong) BOOL (^callbackCanAddApp)();
@property (nonatomic, strong) void (^callbackOpen)(ModelApp *);

- (void)layoutScrollViewSubviews;

@end
