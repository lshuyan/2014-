//
//  UICellProgram.h
//  ChinaBrowser
//
//  Created by David on 14/11/27.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellProgram : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *labelTitle;

+ (instancetype)cellFromXib;

@end
