//
//  UICellNews.h
//  ChinaBrowser
//
//  Created by David on 14-4-28.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellNews : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescr;
@property (weak, nonatomic) IBOutlet UILabel *labelSource;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL hasImage;


+ (instancetype)viewFromXib;

@end
