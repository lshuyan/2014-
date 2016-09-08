//
//  UIViewPopUserAgent.h
//  ChinaBrowser
//
//  Created by David on 14/11/11.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@protocol UIViewPopUserAgentDelegate;

@interface UIViewPopUserAgent : UIViewPopButtomBase

@property (nonatomic, weak) IBOutlet id<UIViewPopUserAgentDelegate> delegate;

@end

@protocol UIViewPopUserAgentDelegate <NSObject>

- (void)viewPopUserAgent:(UIViewPopUserAgent *)viewPopUserAgent selectUserAgentIndex:(NSInteger)userAgentIndex;

@end
