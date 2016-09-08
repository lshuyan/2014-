//
//  ADOSentence.h
//  ChinaBrowser
//
//  Created by David on 14-9-6.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "ModelSentence.h"

@interface ADOSentence : NSObject

+ (BOOL)isExistWithSentence:(NSString *)sentence cid:(NSInteger)cid lan:(NSString *)lan;
+ (NSInteger)addModel:(ModelSentence *)model;
+ (ModelSentence *)queryWithId:(NSInteger)iid;
+ (NSArray *)queryWithCid:(NSInteger)cid lan:(NSString *)lan;

@end
