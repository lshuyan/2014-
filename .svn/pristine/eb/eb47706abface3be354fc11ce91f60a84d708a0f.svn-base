//
//  UIScrollViewTravel.h
//  ChinaBrowser
//
//  Created by David on 14-9-18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppLanguageProtocol.h"
#import "ModelTravelProvince.h"

@protocol UIScrollViewTravelDelegate;

@interface UIScrollViewTravel : UIScrollView <AppLanguageProtocol>

@property (nonatomic, weak) IBOutlet id<UIScrollViewTravelDelegate> delegateTravel;

@property (nonatomic, assign) CGFloat paddingLR, paddingTB;
@property (nonatomic, assign) CGFloat spacex, spacey;

@end

@protocol UIScrollViewTravelDelegate <NSObject>

- (void)scrollViewTravel:(UIScrollViewTravel *)scrollViewTravel reqLink:(NSString *)link;
- (void)scrollViewTravel:(UIScrollViewTravel *)scrollViewTravel selectProvince:(ModelTravelProvince *)province;

@end
