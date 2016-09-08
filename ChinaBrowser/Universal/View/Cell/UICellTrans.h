//
//  UICellTrans.h
//  ChinaBrowser
//
//  Created by David on 14-9-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellTrans : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelSour;
@property (nonatomic, weak) IBOutlet UILabel *labelDest;
@property (nonatomic, weak) IBOutlet UIButton *btnPlaySound;

+ (instancetype)viewFromXib;

@end
