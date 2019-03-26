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


@interface AppDelegate ()
<UNUserNotificationCenterDelegate>

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
    
//    if (self.webModel.ShowWeb) {
//        FLBaseWebViewController *webVC = [[FLBaseWebViewController alloc] initWithUrl:self.webModel.Url];
//        self.window.rootViewController = webVC;
//    }
    [[AppDelegate sharedInstance] GET:nil parameters:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        self.webModel = [[MTHomeWebModel alloc] init];
        [self.webModel setValuesForKeysWithDictionary:responseObject];
        [MTUserInfoDefault saveHomeWebURL:responseObject];
       
    }];
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
    [[AFHTTPSessionManager manager].requestSerializer setTimeoutInterval:3];
    NSString *url = @"http://appid.985-985.com:8088/getAppConfig.php?appid=iosapptest";
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


@end
