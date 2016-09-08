//
//  UICellGroup.h
//  ChinaBrowser
//
//  Created by HHY on 14/12/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UICellGroup : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageViewL;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelNumber;

+ (instancetype)cellFromXib;

- (void)bind:(ALAssetsGroup *)assetsGroup;

@end
