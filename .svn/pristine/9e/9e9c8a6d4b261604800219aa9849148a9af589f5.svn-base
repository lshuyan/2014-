//
//  UIControllerTravelDetail.h
//  ChinaBrowser
//
//  Created by David on 14-10-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

@protocol UIControllerTravelDetailDelegate;

@interface UIControllerTravelDetail : UIControllerBase

@property (nonatomic, weak) id<UIControllerTravelDetailDelegate> delegate;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) CGSize imageSize;

@end

@protocol UIControllerTravelDetailDelegate <NSObject>

- (void)controllerTravelDetail:(UIControllerTravelDetail *)controllerTravelDetail reqLink:(NSString *)link;

@end

