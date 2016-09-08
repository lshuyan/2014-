//
//  ModelSyncDelete.h
//  ChinaBrowser
//
//  Created by David on 14/12/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelSyncBase.h"

@interface ModelSyncDelete : ModelSyncBase

@property (nonatomic, assign) SyncDataType syncDataType;

+ (instancetype)modelWithPkidServer:(NSInteger)pkidServer syncDataType:(SyncDataType)syncDataType userId:(NSInteger)userId;

@end
