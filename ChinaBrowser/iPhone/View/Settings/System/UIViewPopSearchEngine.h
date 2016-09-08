//
//  UIViewPopSearchEngine.h
//  ChinaBrowser
//
//  Created by David on 14/11/10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@protocol UIViewPopSearchEngineDelegate;

@interface UIViewPopSearchEngine : UIViewPopButtomBase

@property (nonatomic, weak) IBOutlet id<UIViewPopSearchEngineDelegate> deletate;

@end

@protocol UIViewPopSearchEngineDelegate <NSObject>

- (void)viewPopSearchEngine:(UIViewPopSearchEngine *)viewPopSearchEngine selectSearchIndex:(NSInteger)searchIndex;

@end
