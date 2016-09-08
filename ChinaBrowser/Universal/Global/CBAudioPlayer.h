//
//  CBAudioPlayer.h
//  ChinaBrowser
//
//  Created by David on 14/11/17.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MPMoviePlayerController.h>

#import "CBAudioPlayerDelegate.h"

@class ModelPlayItem;

@interface CBAudioPlayer : MPMoviePlayerController

@property (nonatomic, weak) id<CBAudioPlayerDelegate> playerDelegate;

@property (nonatomic, strong) ModelPlayItem *playItem;

+ (instancetype)player;

+ (void)playWithItem:(ModelPlayItem *)playItem;
+ (void)play;
+ (void)pause;
+ (void)stop;
+ (void)reset;

+ (BOOL)isPlaying;

@end