//
//  MTNotificationManager.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/17.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import "MTCoreDataDao.h"
#import "MTNotificationVo.h"

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


- (void)registNotifications
{
    NSArray *notifications = [[MTCoreDataDao new]getNotifications];
    [notifications enumerateObjectsUsingBlock:^(MTNotificationVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addNotificationWithVo:obj];
    }];
}

- (void)AddMinutesNotification
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"你会想我吗？";
//    content.subtitle = @"你会想我吗？";
    // 内容
    content.body = @"你会想我吗？你会想我吗？你会想我吗？你会想我吗？你会想我吗？你会想我吗？你会想我吗？";
    
   [UIApplication sharedApplication].applicationIconBadgeNumber++;
    // app显示通知数量的角标
    content.badge = @([UIApplication sharedApplication].applicationIconBadgeNumber);
    
    content.sound = [UNNotificationSound defaultSound];
    
    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"xiaokeai" withExtension:@"png"];
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
    
    // 附件 可以是音频、图片、视频 这里是一张图片
//    content.attachments = @[attachment];
    // 标识符
    content.categoryIdentifier = @"categoryIndentifier";
    // 2、创建通知触发
    /* 触发器分三种：
     UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
     UNCalendarNotificationTrigger : 在某天某时触发，可重复
     UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
     */
//    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 16;
    components.minute = 48;
    UNCalendarNotificationTrigger *dayTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    // 3、创建通知请求
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:dayTrigger];
    // 4、将请求加入通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"已成功加推送%@",notificationRequest.identifier);
        }
    }];
}

- (void)addNotificationWithVo:(MTNotificationVo *)vo
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"你的小秘密";
    content.body = vo.content;
    content.categoryIdentifier = [NSString stringWithFormat:@"category%d",arc4random_uniform(10000)];
    content.sound = [UNNotificationSound defaultSound];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSArray *times = [vo.time componentsSeparatedByString:@":"];
    if (times.count < 2) {
        return;
    }
    NSString *hour = times[0];
    NSString *minute = times[1];
    components.hour = hour.intValue;
    components.minute = minute.intValue;
    UNCalendarNotificationTrigger *dayTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier: [NSString stringWithFormat:@"Notification%d",arc4random_uniform(10000)] content:content trigger:dayTrigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"已成功加推送%@",notificationRequest.identifier);
        }
    }];
}

@end
