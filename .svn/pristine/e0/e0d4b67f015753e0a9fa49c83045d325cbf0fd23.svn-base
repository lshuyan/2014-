//
//  AppDelegate.m
//  ChinaBrowser
//
//  Created by David on 14-8-30.
//  Copyright (c) 2014年 KOTO Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "CheckVersion.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "APService.h"

#import "CBAudioPlayer.h"
#import "ModelProgram.h"
#import "ModelPlayItem.h"

#import "BlockUI.h"

#import "FMLocalNotificationManager.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate
{
    BOOL _receiveLocalNotificationFromBackground;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.keyWindow.backgroundColor = [UIColor whiteColor];
    [application setApplicationIconBadgeNumber:0];
    
    // 获取本地通知启动
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        ModelProgram *model = [ModelProgram model];
        model.title = localNotification.userInfo[FMUserInfoKeyTitle];
        model.link = localNotification.userInfo[FMUserInfoKeyLink];
        model.fm = localNotification.userInfo[FMUserInfoKeyFM];
        model.srcType = [localNotification.userInfo[FMUserInfoKeySrcType] integerValue];
        model.recommendCateId = [localNotification.userInfo[FMUserInfoKeyCateId] integerValue];
        /**
         *  设置启动的节目，在相关模块
         */
        [AppLaunchUtil shareAppLaunch].program = model;
    }
    
    // 获取远程通知启动信息
    NSDictionary *remoteNotificationInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    [AppLaunchUtil shareAppLaunch].dictRemoteNotificationInfo = remoteNotificationInfo;
    
    [APService setupWithOption:launchOptions];
    
    [self setup];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    _receiveLocalNotificationFromBackground = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginReceivingRemoteControlEvents];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application endReceivingRemoteControlEvents];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    _receiveLocalNotificationFromBackground = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// ------------------------ 远程通知处理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    [APService setTags:[NSSet setWithObjects:[[LocalizationUtil currLanguage] stringByReplacingOccurrencesOfString:@"-" withString:@""], nil]
      callbackSelector:nil
                object:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    [self handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self handleRemoteNotification:userInfo];
}

/**
 *  远程通知处理函数；App已启动的前提下，从后台进入App则直接处理通知，App非后台运行收到通知需要提醒用户是否处理App,否则会打断用户操作
 *
 *  @param userInfo 通知内容
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    [AppLaunchUtil shareAppLaunch].dictRemoteNotificationInfo = userInfo;
    if (_receiveLocalNotificationFromBackground) {
        NSString *link = userInfo[@"link"];
        if (link) {
            [self backRootController];
            [[AppLaunchUtil shareAppLaunch].delegate appLaunchOpenLink:link];
        }
    } else {
        [AppLaunchUtil shareAppLaunch].dictRemoteNotificationInfo = userInfo;
        NSString *link = userInfo[@"link"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:userInfo[@"aps"][@"alert"] delegate:nil cancelButtonTitle:LocalizedString(@"guanbi") otherButtonTitles:link?LocalizedString(@"dakai"):nil, nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (alert.cancelButtonIndex==buttonIndex) {
                return;
            }
            // 打开
            [self backRootController];
            [[AppLaunchUtil shareAppLaunch].delegate appLaunchOpenLink:link];
        }];
    }
}

// ------------------------ 收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)localNotification
{
    ModelProgram *modelProgram = [ModelProgram model];
    modelProgram.title = localNotification.userInfo[FMUserInfoKeyTitle];
    modelProgram.link = localNotification.userInfo[FMUserInfoKeyLink];
    modelProgram.fm = localNotification.userInfo[FMUserInfoKeyFM];
    modelProgram.srcType = [localNotification.userInfo[FMUserInfoKeySrcType] integerValue];
    modelProgram.recommendCateId = [localNotification.userInfo[FMUserInfoKeyCateId] integerValue];
    
    /**
     *  设置启动的节目，在相关模块
     */
    [AppLaunchUtil shareAppLaunch].program = modelProgram;
    
    if (_receiveLocalNotificationFromBackground) {
        switch (modelProgram.srcType) {
            case ProgramSrcTypeFM:
            {
                /**
                 *  实时更新下一个节目
                 */
                [[CBAudioPlayer player].playerDelegate showNextPlayItemAfterNow];
                [CBAudioPlayer playWithItem:[ModelPlayItem modelWithTitle:modelProgram.title
                                                                     link:modelProgram.link
                                                                       fm:modelProgram.fm
                                                                     icon:nil]];
            }break;
            case ProgramSrcTypeRecommendCate:
            {
                [self backRootController];
                
                [[AppLaunchUtil shareAppLaunch].delegate appLaunchOpenRecommendCateId:[AppLaunchUtil shareAppLaunch].program.recommendCateId
                                                                             cateName:[AppLaunchUtil shareAppLaunch].program.title];
            }break;
            case ProgramSrcTypeWeb:
            {
                [self backRootController];
                
                [[AppLaunchUtil shareAppLaunch].delegate appLaunchOpenLink:[AppLaunchUtil shareAppLaunch].program.link];
            }break;
            default:
                break;
        }
    }
    else {
        if (ProgramSrcTypeFM==modelProgram.srcType) {
            /**
             *  实时更新下一个节目
             */
            [[CBAudioPlayer player].playerDelegate showNextPlayItemAfterNow];
            
            if (![CBAudioPlayer isPlaying]) {
                [CBAudioPlayer player].playItem = [ModelPlayItem modelWithTitle:modelProgram.title
                                                                           link:modelProgram.link
                                                                             fm:modelProgram.fm
                                                                           icon:nil];
                [[CBAudioPlayer player].playerDelegate updatePlayState];
            }
        }
        
        // 到点提醒 是否收听 电台，阅读新闻，或 访问网站
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:localNotification.alertBody
                                                                 delegate:nil
                                                        cancelButtonTitle:LocalizedString(@"quxiao")
                                                   destructiveButtonTitle:localNotification.alertAction
                                                        otherButtonTitles:nil];
        UIView *showView = self.window.rootViewController.view;
        [actionSheet showInView:showView withCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex==actionSheet.cancelButtonIndex) {
                return;
            }
            
            switch (modelProgram.srcType) {
                case ProgramSrcTypeFM:
                {
                    /**
                     *  实时更新下一个节目
                     */
                    [[CBAudioPlayer player].playerDelegate showNextPlayItemAfterNow];
                    [CBAudioPlayer playWithItem:[ModelPlayItem modelWithTitle:modelProgram.title
                                                                         link:modelProgram.link
                                                                           fm:modelProgram.fm
                                                                         icon:nil]];
                }break;
                case ProgramSrcTypeRecommendCate:
                {
                    [self backRootController];
                    
                    [[AppLaunchUtil shareAppLaunch].delegate appLaunchOpenRecommendCateId:[AppLaunchUtil shareAppLaunch].program.recommendCateId
                                                                                 cateName:[AppLaunchUtil shareAppLaunch].program.title];
                }break;
                case ProgramSrcTypeWeb:
                {
                    [self backRootController];
                    
                    [[AppLaunchUtil shareAppLaunch].delegate appLaunchOpenLink:[AppLaunchUtil shareAppLaunch].program.link];
                }break;
                default:
                    break;
            }
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kReminderActionDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 超过规定时间还没做出选择，App 会关掉提醒视图
            [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
        });
    }
}

- (void)backRootController
{
    UINavigationController *rootController = (UINavigationController *)self.window.rootViewController;
    if (rootController.presentedViewController) {
        [rootController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        if (rootController.viewControllers.count>1) {
            [rootController popToRootViewControllerAnimated:NO];
        }
    }
    else if (((UIViewController *)rootController.viewControllers[0]).presentedViewController) {
        [((UIViewController *)rootController.viewControllers[0]).presentedViewController dismissViewControllerAnimated:NO completion:nil];
        if (rootController.viewControllers.count>1) {
            [rootController popToRootViewControllerAnimated:NO];
        }
    }
    else if (rootController.viewControllers.count>1) {
        [rootController popToRootViewControllerAnimated:YES];
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([RotateUtil shareRotateUtil].rotateLock) {
        return [RotateUtil shareRotateUtil].interfaceOrientationMask;
    }
    else {
        return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

// ---------------------- 后台接受播放控制事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    
    if(event.type== UIEventTypeRemoteControl)  {
        NSLog(@"Remote Control Type: %ld", (long)event.subtype);
        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            {
                if ([CBAudioPlayer isPlaying]) {
                    [CBAudioPlayer pause];
                }
                else {
                    [CBAudioPlayer play];
                }
            }break;
            case UIEventSubtypeRemoteControlStop:
            {
                [CBAudioPlayer stop];
            }break;
            case UIEventSubtypeRemoteControlNextTrack:
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                break;
            default:
                break;
        }
    }
}

#pragma mark - WXApiDelegate
-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}

- (void)setup
{
    // -------------- 设置AFN
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:
                                                       @"application/json",
                                                       @"text/json",
                                                       @"text/html",
                                                       nil]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:NO];
    
    // -------------- 设置SVProgressHUD样式
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.95]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    // -------------- 启动检查更新
    [CheckVersion checkVersionAtLaunch:YES];
    
    // -------------- 设置ShareSDK
    [ShareSDK registerApp:SSK_AppId_ShareSDK];
    // 导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    // 导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];
    // 导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    // 导入Google+
    [ShareSDK importGooglePlusClass:[GPPSignIn class]
                         shareClass:[GPPShare class]];
    [ShareSDK connectWhatsApp];
    [ShareSDK connectCopy];
    [ShareSDK connectMail];
    [ShareSDK connectSMS];
    [ShareSDK waitAppSettingComplete:^{
        _DEBUG_LOG(@"------:ShareSDK AppSettingComplete");
    }];
    
    // ------------- 设置百度统计
    /*
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
#if _DEBUG
    statTracker.enableDebugOn = YES; //调试的时候打开，会有log打印，发布时候关闭
#endif
    [statTracker startWithAppId:kBaiduMobAppKey];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
     */
    
    
    // ------------- 如果语言环境变了，那得清除上一个语言环境下的所有 电台节目 通知
    if (![[AppSetting shareAppSetting].lastSelectedLan isEqualToString:[LocalizationUtil currLanguage]]) {
        [FMLocalNotificationManager clearNotification];
        [AppSetting shareAppSetting].lastSelectedLan = [LocalizationUtil currLanguage];
    }
    
    // ------------- 设置屏幕亮度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BrightnessUtil shareBrightnessUtil] setBrightness:[AppSetting shareAppSetting].brightness];
    });
}

@end
