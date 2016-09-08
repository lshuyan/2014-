//
//  ModelUser.h
//  ChinaBrowser
//
//  Created by David on 13-10-18.
//  Copyright (c) 2013年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

@class ModelUserSettings;

/**
 *  用户实体
 */
@interface ModelUser : ModelBase

/**
 *  服务器 primary key
 */
@property (nonatomic, assign) NSInteger uid;
/**
 *  用户token，向服务器提交请求的认证凭证
 */
@property (nonatomic, copy) NSString *token;
/**
 *  用户名：登录名
 */
@property (nonatomic, strong) NSString *username;
/**
 *  Email：登录名
 */
@property (nonatomic, strong) NSString *email;
/**
 *  昵称
 */
@property (nonatomic, strong) NSString *nickname;
/**
 *  头像路径
 */
@property (nonatomic, strong) NSString *avatar;
/**
 *  性别 1：男 2：女 3：保密
 */
@property (nonatomic, assign) UserGender gender;
/**
 *  密码
 */
@property (nonatomic, strong) NSString *pwd;
/**
 *  是否第三平台自动生成的账号
 */
@property (nonatomic, assign, getter = isAutoCreate) BOOL autoCreate;

/**
 *  用户设置
 */
@property (nonatomic, strong) ModelUserSettings *settings;

/**
 *  同步时间
 */
@property (nonatomic , assign) NSInteger syncTime;

@end
