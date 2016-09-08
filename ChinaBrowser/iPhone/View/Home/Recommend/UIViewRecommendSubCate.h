//
//  UIViewRecommendSubCate.h
//  ChinaBrowser
//
//  Created by David on 14/11/5.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewRecommendSubCateDelegate;

@interface UIViewRecommendSubCate : UIView

@property (nonatomic, weak) IBOutlet id<UIViewRecommendSubCateDelegate> delegate;
@property (nonatomic, assign) NSInteger cateId;

+ (instancetype)viewFromXib;

- (void)refreshData;

@end

@protocol UIViewRecommendSubCateDelegate <NSObject>

- (void)viewRecommendSubCate:(UIViewRecommendSubCate *)viewRecommendSubCate reqLink:(NSString *)link;

@end
