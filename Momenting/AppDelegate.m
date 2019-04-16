//
//  AppDelegate.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MTMediaFileManager.h"
#import <UserNotifications/UserNotifications.h>
#import "MTNotificationManager.h"
#import "MTLanguageManager.h"
#import "MTLocalDataManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MTHomeWebModel.h"
#import "FLBaseWebViewController.h"
#import "ViewController.h"
#import "MTUserInfoDefault.h"
#import "MTLaunchController.h"
#import <JPUSHService.h>
#import <AdSupport/AdSupport.h>


@interface AppDelegate ()
<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) MTHomeWebModel *webModel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for cus∫tomization after application launch.
    
//    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
//    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    [[MTMediaFileManager sharedManager] config];
    [[MTLocalDataManager shareInstance] config];
    [[MTNotificationManager shareInstance] config];
    [[MTLanguageManager shareInstance] config];    
    self.webModel = [[MTHomeWebModel alloc] init];
    [self.webModel setValuesForKeysWithDictionary:[MTUserInfoDefault getHomeWebURL]];
    
    if (self.webModel.ShowWeb) {
        FLBaseWebViewController *webVC = [[FLBaseWebViewController alloc] initWithUrl:self.webModel.Url];
        self.window.rootViewController = webVC;
    }
    
    
    
    NSString *time = [[NSDateFormatter my_getDefaultFormatter] stringFromDate:[NSDate date]];
    NSLog(@"___________%@",time);
    
//    if (!([time isEqualToString:@"2019/04/11"] || [time isEqualToString:@"2019/04/10"])) {
    
        [[AppDelegate sharedInstance] GET:nil parameters:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            self.webModel = [[MTHomeWebModel alloc] init];
            [self.webModel setValuesForKeysWithDictionary:responseObject];
            [MTUserInfoDefault saveHomeWebURL:responseObject];
        }];
//    }
    
    //JPush
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"7464dff7eb8a11548201db98"
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    
    return YES;
}

+ (AppDelegate *)sharedInstance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                   completion:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))completion
{
    
    NSString *deviceId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (!deviceId || deviceId.length < 1) {
        deviceId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    }
    deviceId = @"1459074913";
    [[AFHTTPSessionManager manager].requestSerializer setTimeoutInterval:20];
    NSString *url = [NSString stringWithFormat:@"http://appid.985-985.com:8088/getAppConfig.php?appid=%@",deviceId];
    NSURLSessionDataTask *dataTask = [[AFHTTPSessionManager manager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(task, responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(task, nil, error);
    }];
    return dataTask;
}

#pragma mark - notification

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //本地通知
    [[MTNotificationManager shareInstance] showPushViewWithUserinfo:notification.userInfo];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
