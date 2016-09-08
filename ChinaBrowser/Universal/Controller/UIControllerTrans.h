//
//  UIControllerTrans.h
//  ChinaBrowser
//
//  Created by David on 14-9-10.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "UIControllerBase.h"

#import "ModelSentenceCate.h"
#import "ADOSentenceCate.h"
#import "ADOSentence.h"

#import "AppLanguageProtocol.h"

@interface UIControllerTrans : UIControllerBase <AppLanguageProtocol>

@property (nonatomic, strong) ModelSentenceCate *modelCate;

@end