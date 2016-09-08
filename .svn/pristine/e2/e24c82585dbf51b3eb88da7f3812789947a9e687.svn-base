//
//  ADOMode.h
//  ChinaBrowser
//
//  Created by David on 14/11/22.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelMode;

@interface ADOMode : NSObject

+ (BOOL)isExistWithName:(NSString *)name sysRecommend:(BOOL)sysRecommend userId:(NSInteger)userId;
+ (BOOL)isExistWithPkidServer:(NSInteger)pkidServer;

+ (NSInteger)addModel:(ModelMode *)model;

+ (BOOL)updateName:(NSString *)name withPkid:(NSInteger)pkid;
+ (BOOL)updateName:(NSString *)name withPkidServer:(NSInteger)pkidServer userId:(NSInteger)userId;
+ (BOOL)updatePkidServer:(NSInteger)pkidServer updateTimeServer:(NSInteger)updateTimeServer withPkid:(NSInteger)pkid;
+ (BOOL)updateModel:(ModelMode *)model;

+ (NSInteger)queryModePkidWithModePkidServer:(NSInteger)modePkidServer;
+ (NSInteger)queryModePkidServerWithModePkid:(NSInteger)modePkid;
+ (ModelMode *)queryWithPkid:(NSInteger)pkid;
+ (ModelMode *)queryWithPkidServer:(NSInteger)pkidServer userId:(NSInteger)userId;
+ (ModelMode *)queryWithPkidServer:(NSInteger)pkidServer;
+ (ModelMode *)queryWithName:(NSString *)name sysRecommend:(BOOL)sysRecommend userId:(NSInteger)userId exceptPkid:(NSInteger)exceptPkid;
+ (NSArray *)queryWithUserId:(NSInteger)userId sysRecommend:(BOOL)sysRecommend;
+ (NSArray *)queryWillUpdateWithUserId:(NSInteger)userId;
+ (NSArray *)queryWillAddWithUserId:(NSInteger)userId;

+ (BOOL)deleteWithPkid:(NSInteger)pkid;
+ (BOOL)deleteWithPkidServer:(NSInteger)pkidServer userId:(NSInteger)userId;
+ (BOOL)deleteWithArrPkidServer:(NSArray *)arrPkidServer userId:(NSInteger)userId;
+ (BOOL)deleteWithUserId:(NSInteger)userId;
+ (BOOL)deleteWithSysRecommend:(BOOL)sysRecommend userId:(NSInteger)userId;
+ (BOOL)deleteWithPkidServer:(NSInteger)pkidServer userId:(NSInteger)userId exceptPkid:(NSInteger)exceptPkid;
+ (BOOL)clear;
+ (BOOL)clearWithUserId:(NSInteger)userId;

@end
