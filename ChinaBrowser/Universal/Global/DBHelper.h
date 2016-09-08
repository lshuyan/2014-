//
//  DBHelper.h
//  ChinaBrowser
//
//  Created by David on 14/11/24.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

@interface DBHelper : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareDBHelper;
+ (FMDatabase *)db;

@end
