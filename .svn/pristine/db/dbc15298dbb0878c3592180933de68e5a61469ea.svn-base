//
//  ADOSentenceCate.h
//  ChinaBrowser
//
//  Created by David on 14-9-6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "ModelSentenceCate.h"

@interface ADOSentenceCate : NSObject

+ (BOOL)isExistWithName:(NSString *)name pcid:(NSInteger)pcid;
+ (NSInteger)addModel:(ModelSentenceCate *)model;
+ (NSArray *)queryAll;
+ (NSArray *)queryWithPcid:(NSInteger)pcid;

@end
