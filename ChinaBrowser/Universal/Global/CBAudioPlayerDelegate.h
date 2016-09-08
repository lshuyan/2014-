//
//  CBAudioPlayerDelegate.h
//  ChinaBrowser
//
//  Created by David on 14/12/6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CBAudioPlayerDelegate <NSObject>

/**
 *  根据现在的时间时间查找 下一个节目（节目预告）
 *
 */
- (void)showNextPlayItemAfterNow;

/**
 *  更新播放状态: 标题、FM、播放按钮、声波图
 */
- (void)updatePlayState;

@end
