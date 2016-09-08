//
//  ModelBase.m
//  ChinaBrowser
//
//  Created by David on 14/10/29.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "ModelBase.h"

#import <objc/runtime.h>

@implementation ModelBase

#pragma mark - super methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (!aDecoder) {
            return self;
        }
        
        Class clazz = [self class];
        u_int count;
        
        objc_property_t *properties    = class_copyPropertyList(clazz, &count);
        NSMutableArray  *propertyArray = [NSMutableArray arrayWithCapacity:count];
        for (int i=0; i<count; i++) {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        for (NSString *name in propertyArray) {
            id value = [aDecoder decodeObjectForKey:name];
            if (value) {
                [self setValue:value forKey:name];
            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    Class clazz = [self class];
    u_int count;
    
    objc_property_t *properties     = class_copyPropertyList(clazz, &count);
    NSMutableArray  *propertyArray  = [NSMutableArray arrayWithCapacity:count];
    for (int i=0; i<count; i++) {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    for (NSString *name in propertyArray) {
        id value = [self valueForKey:name];
        if (value) {
            [aCoder encodeObject:value forKey:name];
        }
    }
}

#pragma mark - public methods
+ (instancetype)model
{
    return [[[self class] alloc] init];
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    if (dict) {
        return [[[self class] alloc] initWithDict:dict];
    }
    else {
        return nil;
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)modelWithResultSetDict:(NSDictionary *)dict
{
    if (dict) {
        return [[[self class] alloc] initWithResultSetDict:dict];
    }
    else {
        return nil;
    }
}

- (instancetype)initWithResultSetDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSData *)dataWithModel:(ModelBase *)model
{
    return [NSKeyedArchiver archivedDataWithRootObject:model];
}

+ (instancetype)modelWithData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
