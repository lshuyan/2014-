//
//  UIViewPopGender.h
//  ChinaBrowser
//
//  Created by David on 14/11/18.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIViewPopButtomBase.h"

@protocol UIViewPopGenderDelegate;

@interface UIViewPopGender : UIViewPopButtomBase

@property (nonatomic, weak) IBOutlet id<UIViewPopGenderDelegate> delegate;

@end

@protocol UIViewPopGenderDelegate <NSObject>

- (void)viewPopGender:(UIViewPopGender *)viewPopGender selectedGender:(NSInteger)gender;

@end
