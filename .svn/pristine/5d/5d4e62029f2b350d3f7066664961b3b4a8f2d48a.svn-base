//
//  ModelSyncDelete.m
//  ChinaBrowser
//
//  Created by David on 14/12/20.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelSyncDelete.h"
#import "ADOSyncDelete.h"

@implementation ModelSyncDelete

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lan = [LocalizationUtil currLanguage];
    }
    return self;
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super initWithResultSetDict:dict];
    if (self) {
        self.syncDataType = [dict[@"sync_data_type"] integerValue];
    }
    return self;
}

+ (instancetype)modelWithPkidServer:(NSInteger)pkidServer syncDataType:(SyncDataType)syncDataType userId:(NSInteger)userId
{
    ModelSyncDelete *model = [ModelSyncDelete model];
    model.pkid_server = pkidServer;
    model.lan = [LocalizationUtil currLanguage];
    model.userid = userId;
    model.syncDataType = syncDataType;
    model.updateTime = [[NSDate date] timeIntervalSince1970];
    
    return model;
}

@end
