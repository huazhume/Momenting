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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for cus∫tomization after application launch.
    
    [[MTMediaFileManager sharedManager] createMediaFileWithSanboxType:SANBOX_DOCUMNET_TYPE AndWithMediaType:FILE_IMAGE_TYPE];
    [[MTMediaFileManager sharedManager] createMediaFileWithSanboxType:SANBOX_DOCUMNET_TYPE AndWithMediaType:FILE_DB_TYPE];
    [[MTMediaFileManager sharedManager] createMediaFileWithSanboxType:SANBOX_DOCUMNET_TYPE AndWithMediaType: FILE_IMAGEBATE_TYPE];
    [self requestAuthor];
    return YES;
}

- (void)requestAuthor
{
    // 申请通知权限
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        // A Boolean value indicating whether authorization was granted. The value of this parameter is YES when authorization for the requested options was granted. The value is NO when authorization for one or more of the options is denied.
        if (granted) {
            
            // 1、创建通知内容，注：这里得用可变类型的UNMutableNotificationContent，否则内容的属性是只读的
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            // 标题
            content.title = [NSString stringWithFormat:@"小秘密",arc4random_uniform(100)];
            // 次标题
            content.subtitle = @"我好爱你啊";
            // 内容
            content.body = @"我好爱你啊我好爱你啊我好爱你啊我好爱你啊我好爱你啊我好爱你啊我好爱你啊我好爱你啊我好爱你啊我好爱你啊。";
            // [UIApplication sharedApplication].applicationIconBadgeNumber++;
            // app显示通知数量的角标
            // content.badge = @([UIApplication sharedApplication].applicationIconBadgeNumber);
            // 通知的提示声音，这里用的默认的声音
            content.sound = [UNNotificationSound defaultSound];
            NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"xiaokeai" withExtension:@"png"];
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
            // 附件 可以是音频、图片、视频 这里是一张图片
            // content.attachments = @[attachment];
            // 标识符
            content.categoryIdentifier = @"categoryIndentifier";
            // 2、创建通知触发
            /* 触发器分三种：
             UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
             UNCalendarNotificationTrigger : 在某天某时触发，可重复
             UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
             */
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:120 repeats:YES];
            // 3、创建通知请求
            UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
            // 4、将请求加入通知中心
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    NSLog(@"已成功加推送%@",notificationRequest.identifier);
                }
            }];
        }
        
    }];
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
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
