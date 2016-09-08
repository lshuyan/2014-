//
//  FMLocalNotificationManager.h
//  ChinaBrowser
//
//  Created by David on 14/12/5.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelModeProgram;

@interface FMLocalNotificationManager : NSObject

+ (NSInteger)numberOfLocalNotification;

/**
 *  更新本地通知，清除所有本地通知，然后注册指定模式的通知
 */
+ (void)resetNotificationWithModePkid:(NSInteger)modePkid;

/**
 *  添加 一个节目 通知
 *
 *  @param modeProgram ModelModeProgram
 */
+ (void)addNotificationWithModeProgram:(ModelModeProgram *)modeProgram;

/**
 *  添加 一个节目
 *
 *  @param modeProgram    modeProgram description
 *  @param repeatInterval repeatInterval description
 *  @param weekday        weekday description
 */
+ (void)addNotificationWithModeProgram:(ModelModeProgram *)modeProgram repeatInterval:(NSCalendarUnit)repeatInterval weekday:(NSInteger)weekday;

/**
 *  是否启用 某个节目 通知
 *
 *  @param modeProgram modeProgram description
 *  @param enable      enable description
 */
+ (void)updateModeProgram:(ModelModeProgram *)modeProgram enable:(BOOL)enable;

/**
 *  移除 一个节目通知
 *
 *  @param modeProgramPkid modeProgramPkid description
 */
+ (void)removeNotificationWithModeProgramPkid:(NSInteger)modeProgramPkid;

/**
 *  清除所有本地 节目通知
 */
+ (void)clearNotification;

/**
 *  根据指定的一天内的 时间戳，和 重复的星期，计算偏移后的通知的 响应时间
 *
 *  @param time    一天内的时间戳
 *  @param weekday 星期，[1-7], 周日为1，如果为 0，表示不偏移
 *
 *  @return NSDate 通知响应时间
 */
+ (NSDate *)getFireDateWithTime:(NSInteger)time weekday:(NSInteger)weekday;

@end
