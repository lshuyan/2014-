//
//  UICellRecommend.h
//  ChinaBrowser
//
//  Created by David on 14/11/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellRecommend : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnPlay;

@property (nonatomic, assign) BOOL playing;

+ (instancetype)viewFromXib;

@end
