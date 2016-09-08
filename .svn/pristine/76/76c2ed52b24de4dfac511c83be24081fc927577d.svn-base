//
//  UIScrollViewTravelDetail.h
//  ChinaBrowser
//
//  Created by David on 14-10-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIScrollViewTravelDetailDelegate;

@interface UIScrollViewTravelDetail : UIScrollView

@property (nonatomic, weak) IBOutlet id<UIScrollViewTravelDetailDelegate> delegateTravelDetail;
@property (nonatomic, assign) CGFloat paddingLR, paddingTB;
@property (nonatomic, assign) CGFloat spacex, spacey;

- (void)setImageUrl:(NSString *)imageUrl imageSize:(CGSize)imageSize;
- (void)reqVideoWithProvinceId:(NSInteger)provinceId;

@end

@protocol UIScrollViewTravelDetailDelegate <NSObject>

- (void)scrollViewTravelDetail:(UIScrollViewTravelDetail *)scrollViewTravelDetail
               willPlayWithUrl:(NSString *)url
                         title:(NSString *)title
                         thumb:(NSString *)thumb;

- (void)scrollViewTravelDetail:(UIScrollViewTravelDetail *)scrollViewTravelDetail reqLink:(NSString *)link;

@end
