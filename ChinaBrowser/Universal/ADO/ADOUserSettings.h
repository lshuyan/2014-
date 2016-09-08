//
//  ADOUserSettings.h
//  ChinaBrowser
//
//  Created by David on 14/11/24.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelUserSettings;

@interface ADOUserSettings : NSObject

+ (BOOL)isExistWithUserId:(NSInteger)userId;

+ (NSInteger)addModel:(ModelUserSettings *)model;

+ (BOOL)updateModel:(ModelUserSettings *)model;

+ (ModelUserSettings *)queryWithUserId:(NSInteger)userId;

+ (BOOL)deleteWithUserId:(NSInteger)userId;
+ (BOOL)clear;

@end
