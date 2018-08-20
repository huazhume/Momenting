//
//  MTNotificationManager.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/17.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNotificationManager.h"
#import <UserNotifications/UserNotifications.h>

@interface MTNotificationManager ()


@end

@implementation MTNotificationManager

+ (MTNotificationManager *)shareInstance
{
    static MTNotificationManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MTNotificationManager alloc] init];
        
    });
    return manager;
}

- (void)registNotification
{
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) { //注册成功
            
        
        }
    }];
}

- (void)oneMinutesNotification
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString stringWithFormat:@"小秘密%d",arc4random_uniform(100)];
    content.subtitle = @"柯梵办公室通知";
    // 内容
    content.body = @"柯梵科技是一家以人为本，具有强烈社会责任感的公司。公司的最大愿景就是每个员工都能住上大房子，开上好车，实现逆袭高富帅、白富美的愿望。";
    
   [UIApplication sharedApplication].applicationIconBadgeNumber++;
    // app显示通知数量的角标
    content.badge = @([UIApplication sharedApplication].applicationIconBadgeNumber);
    
    content.sound = [UNNotificationSound defaultSound];
    
    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"xiaokeai" withExtension:@"png"];
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
    
    // 附件 可以是音频、图片、视频 这里是一张图片
    content.attachments = @[attachment];
    // 标识符
    content.categoryIdentifier = @"categoryIndentifier";
    // 2、创建通知触发
    /* 触发器分三种：
     UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
     UNCalendarNotificationTrigger : 在某天某时触发，可重复
     UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
     */
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];
    // 3、创建通知请求
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
    // 4、将请求加入通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"已成功加推送%@",notificationRequest.identifier);
        }
    }];
}

@end
