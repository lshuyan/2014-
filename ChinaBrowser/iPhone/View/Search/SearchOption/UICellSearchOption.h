//
//  UICellSearchOption.h
//  ChinaBrowser
//
//  Created by David on 14-9-26.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellSearchOption : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageViewIcon;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;

+ (instancetype)viewFromXib;

@end
