//
//  ModelSkin.h
//  ChinaBrowser
//
//  Created by David on 14-3-17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

typedef NS_ENUM(NSInteger, SkinType) {
    SkinTypeUnknow = 0,
//    SkinTypeSysDay,
//    SkinTypeSysNight,
//    SkinTypeCustomDay,
//    SkinTypeCustomNight,
    SkinTypeSys,
    SkinTypeCustom,
};

/**
 *  皮肤
 */
@interface ModelSkin : ModelBase

@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, assign) SkinType  skinType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thumbPath;
@property (nonatomic, strong) NSString *imagePath;

@end
