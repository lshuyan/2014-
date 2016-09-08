//
//  UIScrollViewRecommend.h
//  ChinaBrowser
//
//  Created by David on 14-9-29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppLanguageProtocol.h"

@protocol UIScrollViewRecommendDelegate;

@interface UIScrollViewRecommend : UIScrollView <AppLanguageProtocol>

@property (nonatomic, weak) IBOutlet id<UIScrollViewRecommendDelegate> delegateRecommend;

@end

@protocol UIScrollViewRecommendDelegate <NSObject>

- (void)scrollViewRecommend:(UIScrollViewRecommend *)scrollViewRecommend reqLink:(NSString *)link;
- (void)scrollViewRecommend:(UIScrollViewRecommend *)scrollViewRecommend reqNewsWithCateId:(NSInteger)cateId cateName:(NSString *)cateName;
- (void)scrollViewRecommend:(UIScrollViewRecommend *)scrollViewRecommend reqSubCateWithCateId:(NSInteger)cateId;

@end
