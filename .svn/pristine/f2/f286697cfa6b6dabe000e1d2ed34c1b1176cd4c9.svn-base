//
//  UIViewNews.h
//  ChinaBrowser
//
//  Created by David on 14/11/5.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewNewsDelegate;

@interface UIViewNews : UIView

@property (nonatomic, weak) IBOutlet id<UIViewNewsDelegate> delegate;
@property (nonatomic, assign) NSInteger cateId;
@property (nonatomic, strong) NSString *cateName;

+ (instancetype)viewFromXib;

- (void)refreshData;

@end

@protocol UIViewNewsDelegate <NSObject>

- (void)viewNews:(UIViewNews *)viewNews reqLink:(NSString *)link;

@end
