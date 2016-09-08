//
//  UICellModeProgram.h
//  ChinaBrowser
//
//  Created by David on 14/11/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellModeProgram : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelTime;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelRepeat;

+ (instancetype)cellFromXib;

@end
