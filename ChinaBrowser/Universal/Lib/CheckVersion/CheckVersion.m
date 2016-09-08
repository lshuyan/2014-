//
//  CheckVersion.m
//  ChinaBrowser
//
//  Created by David on 14-4-4.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "CheckVersion.h"

#import "BlockUI.h"

//NSString * const API_CheckVersioniTunes = @"http://itunes.apple.com/lookup?id=";
#define kNeverCheckVersion @"kNeverCheckVersionStr"

AFJSONRequestOperation *afJsonReq;

@implementation CheckVersion

/**
 *  检查app的更新
 *
 *  @param atLaunch 是否在启动时检查更新
 */

+ (void)checkVersionAtLaunch:(BOOL)atLaunch {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (atLaunch) {
        NSString *noCheckVersion = [ud objectForKey:kNeverCheckVersion];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        if (noCheckVersion) {
            if ([version compare:noCheckVersion]==NSOrderedDescending) {
                // 当前版本 > 不再提示的版本，表示App升级过，升级过后再次启用 启动更新
                [ud removeObjectForKey:kNeverCheckVersion];
                [ud synchronize];
            }
            else {
                return;
            }
        }
    }
    
    [afJsonReq cancel];
    
    NSString *device = IsiPad?@"ipad":@"iphone";
    NSDictionary *dicParam = @{@"device":device};
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@""]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:GetApiWithName(API_CheckVersion) parameters:dicParam];
    NSString *filepath = [GetCacheDataDir() stringByAppendingPathComponent:[req.URL.absoluteString fileNameMD5WithExtension:@"json"]];
    
    BOOL (^completion)(NSDictionary *dicResult) = ^(NSDictionary *dicResult){
        NSDictionary *dicInfo = dicResult[@"data"];
        if (dicInfo && [dicInfo isKindOfClass:[NSDictionary class]]) {
            
            NSString *lastVersion = dicInfo[@"versionName"];
            NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
            if ([lastVersion compare:version]==NSOrderedDescending) {
                NSString *descr = dicInfo[@"descr"];
                if (atLaunch) {
                    // 启动是检查
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"jianchayouxinbanben") message:descr delegate:nil cancelButtonTitle:LocalizedString(@"quxiao") otherButtonTitles:LocalizedString(@"buzaitishi"), LocalizedString(@"lijishengji"), nil];
                    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                        if (2==buttonIndex) {
                            // 下载
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dicInfo[@"url"]]];
                        }
                        else if (1==buttonIndex) {
                            [ud setObject:version forKey:kNeverCheckVersion];
                            [ud synchronize];
                        }
                    }];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"jianchayouxinbanben") message:descr delegate:nil cancelButtonTitle:LocalizedString(@"bushengji") otherButtonTitles:LocalizedString(@"lijishengji"), nil];
                    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                        if (alert.cancelButtonIndex!=buttonIndex) {
                            // 下载
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dicInfo[@"url"]]];
                        }
                    }];
                }
            }
            else if (!atLaunch) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"tishi") message:LocalizedString(@"wuxushengji") delegate:nil cancelButtonTitle:LocalizedString(@"hao") otherButtonTitles: nil];
                [alert show];
            }
            return YES;
        }
        else if (!atLaunch) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"tishi")
                                                            message:LocalizedString(@"weizhaodaoapp")
                                                           delegate:nil
                                                  cancelButtonTitle:LocalizedString(@"guanbi")
                                                  otherButtonTitles: nil];
            [alert show];
        }
        
        return NO;
    };
    
    afJsonReq = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (completion(JSON)) {
            [afJsonReq.responseData writeToFile:filepath atomically:YES];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data) {
            completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]);
        }
        _DEBUG_LOG(@"%s:%@", __FUNCTION__, error);
    }];
    [afJsonReq start];
}

@end
