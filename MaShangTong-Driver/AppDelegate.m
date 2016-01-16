//
//  AppDelegate.m
//  MaShangTong-Driver
//
//  Created by jeaner on 15/11/11.
//  Copyright © 2015年 jeaner. All rights reserved.
//


#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <iflyMSC/iflyMSC.h>

#import "AppDelegate.h"
#import "DriverRegisViewController.h"
#import "HomeDriverViewController.h"

#import "ModefiedViewController.h"
#import "WaitForPayViewController.h"
#import "NYDiscoverViewController.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设备常亮
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // 极光推送
    // Required
//    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//            //categories
//            [APService
//             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                 UIUserNotificationTypeSound |
//                                                 UIUserNotificationTypeAlert)
//             categories:nil];
//        } else {
//            //categories nil
//            [APService
//             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                 
//                                                 
//                                                 UIRemoteNotificationTypeSound |
//                                                 UIRemoteNotificationTypeAlert)
//#else
//             //categories nil
//             categories:nil];
//            [APService
//             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                 UIRemoteNotificationTypeSound |
//                                                 UIRemoteNotificationTypeAlert)
//#endif
//             // Required
//             categories:nil];
//        }
//    [APService setupWithOption:launchOptions];
    
    // 禁用缓存
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    // 友盟分享
    [UMSocialData setAppKey:(NSString *)UMSocialAppKey];
    [UMSocialQQHandler setQQWithAppId:@"1105033522" appKey:@"REaQLYFREilVdVxY" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialWechatHandler setWXAppId:@"wx4a394bc7ef225c8a" appSecret:@"fadd64686a32f7acefff137faa0cce3a" url:@"http://www.umeng.com/social"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3461785701" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    // 高德地图
    [AMapNaviServices sharedServices].apiKey = AMap_ApiKey;
    [MAMapServices sharedServices].apiKey = AMap_ApiKey;
    [AMapSearchServices sharedServices].apiKey = AMap_ApiKey;
    
    // 科大讯飞语音
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_NONE];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSString *cachePath = [CachePath objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:[[NSString alloc] initWithFormat:@"appid=%@",APPID_IFly]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[USER_DEFAULT objectForKey:@"isLogin"] isEqualToString:@"1"]) {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeDriverViewController alloc] init]];
    } else {
        DriverRegisViewController *regisDriver = [[DriverRegisViewController alloc] init];
        UINavigationController *regisDriverNavi = [[UINavigationController alloc] initWithRootViewController:regisDriver];
        self.window.rootViewController = regisDriverNavi;
    }

//    self.window.rootViewController = [[NYDiscoverViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -----------分享-------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
        
    }
    return result;
}

//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    // Required
//    [APService registerDeviceToken:deviceToken];
//}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    // Required
//    [APService handleRemoteNotification:userInfo];
//}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:(void
//                        (^)(UIBackgroundFetchResult))completionHandler {
//    // IOS 7 Support Required
//    
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
