//
//  FilePathUtil.h
//
//  Created by David on 2011-12-19.
//  Copyright 2011年 KOTO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 单个文件的大小，返回单位M
 */
long long FileSizeAtPath(NSString *filePath);

/**
 * 遍历文件夹获得文件夹大小，返回单位M
 */
float FolderSizeAtPath(NSString *folderPath);

NSString * GetDocumentDir();

void CreateDirAtPath(NSString *dirPath);

NSString * GetTemporaryDirectory();

NSString * GetDocumentDirAppend(NSString *dirName);

NSString * GetCacheDir();

NSString * GetCacheImageDir();

NSString * GetCacheDataDir();

NSString * GetCacheDirAppend(NSString *dirName);

NSString * GetDBPathWithName(NSString *dbName);
