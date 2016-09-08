//
//  ModelUserPassword.h
//  ChinaBrowser
//
//  Created by huyan on 14/12/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

@interface ModelUserPassword : ModelBase
/**
 *  唯一主键
 */
@property (nonatomic, assign) NSInteger pkid;
/**
 *  用户名
 */
@property (nonatomic, strong) NSString *userName;
/**
 *  密码
 */
@property (nonatomic, strong) NSString *password;
/**
 *  语言类型
 */
@property (nonatomic, strong) NSString *lan;
@end
