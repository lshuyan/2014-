//
//  UIScrollViewTrans.h
//  ChinaBrowser
//
//  Created by David on 14-9-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADOSentenceCate.h"
#import "AppLanguageProtocol.h"

@protocol UIScrollViewTransDelegate;

@interface UIScrollViewTrans : UIScrollView <AppLanguageProtocol>

@property (nonatomic, weak) IBOutlet id<UIScrollViewTransDelegate>  delegateTrans;

@property (nonatomic, assign) CGFloat itemW, itemH;
@property (nonatomic, assign) CGFloat minPaddingLR, paddingTB;
@property (nonatomic, assign) CGFloat spaceX, spaceY;

@end

@protocol UIScrollViewTransDelegate <NSObject>

- (void)scrollViewTrans:(UIScrollViewTrans *)scrollViewTrans onTouchCate:(ModelSentenceCate *)modelCate;
- (void)scrollViewTrans:(UIScrollViewTrans *)scrollViewTrans reqLink:(NSString *)link;

@end
