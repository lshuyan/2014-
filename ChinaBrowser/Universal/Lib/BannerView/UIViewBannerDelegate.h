//
//  UIViewBannerDelegate.h
//  DailyHeadlines
//
//  Created by David on 2011-12-16.
//  Copyright 2011年 com.veryapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIViewBannerDelegate <NSObject>

@optional
-(void)viewBannerDidSelect:(NSInteger)index;
-(void)viewBannerDidClick:(NSInteger)index;

- (void)viewBannerWillDismiss;

@end