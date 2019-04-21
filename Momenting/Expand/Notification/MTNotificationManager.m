//
//  MTNotificationManager.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/17.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import "MTLocalDataManager.h"
#import "MTNotificationVo.h"
#import "MTForegroundPushView.h"
#import "EBCustomBannerView.h"

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
    NSArray *notifications = [[MTLocalDataManager shareInstance]getNotifications];
    [notifications enumerateObjectsUsingBlock:^(MTNotificationVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addNotificationWithVo:obj];
    }];
}


- (void)AddMinutesNotification
{
    /* 触发器分三种：
     UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
     UNCalendarNotificationTrigger : 在某天某时触发，可重复
     UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
     */
}

- (void)addNotificationWithVo:(MTNotificationVo *)vo
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"你的小秘密";
    content.body = vo.content;
    content.categoryIdentifier = [NSString stringWithFormat:@"category%d",arc4random_uniform(10000)];
    content.sound = [UNNotificationSound defaultSound];
    if (vo.content) {
        content.userInfo = @{@"content" : vo.content};
    }
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
    if (!vo.notificationId) {
        return;
    }
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier: vo.notificationId content:content trigger:dayTrigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"已成功加推送%@",notificationRequest.identifier);
        }
    }];
    
//    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[]];
//    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[]];
}

- (void)showPushViewWithUserinfo:(NSDictionary *)userinfo
{
    MTNotificationVo *foreModel = [MTNotificationVo new];
    foreModel.content = userinfo[@"content"];
    MTForegroundPushView *pushView = [[MTForegroundPushView alloc] init];
    pushView.callback = ^{
    };
    pushView.model = foreModel;
    EBCustomBannerView *cb = [EBCustomBannerView showCustomView:pushView block:^(EBCustomBannerViewMaker *make) {
        make.portraitFrame = CGRectMake(0, 0, SCREEN_WIDTH, [MTForegroundPushView heightForViewWithContent:foreModel.content]);
        make.portraitMode = EBCustomViewAppearModeTop;
        make.soundID = 1312;
        make.stayDuration = 10.0;
    }];
    pushView.customView = cb;
}

- (void)config
{
    NSMutableArray *notificationMuArray = [NSMutableArray array];
    NSDictionary *dayDicOne = @{@"time" : @"9:00",@"content" : @"弃捐勿复道，努力加餐饭。早安",@"id" : @"one"};
    NSDictionary *dayDicTwo = @{@"time" : @"12:00",@"content" : @"且食勿踟蹰，南风吹作竹。午安" ,@"id" : @"two"};
    NSDictionary *dayDicThree = @{@"time" : @"13:00",@"content" : @"午窗春日影悠悠，一觉清眠万事休。该睡觉啦",@"id" : @"three"};
    NSDictionary *dayDicForth = @{@"time" : @"14:00",@"content" : @"路曼曼其修远兮，吾将上下而求索。好好工作",@"id" : @"four"};
    NSDictionary *dayDicFirth = @{@"time" : @"18:50",@"content" : @"黄昏潮落南沙明，月光涵沙秋雪清。要下班啦，注意安全",@"id" : @"fice"};
    NSDictionary *dayDicSix = @{@"time" : @"22:00",@"content" : @"南风知我意，吹梦到西洲。我想你，晚安",@"id" : @"six"};
    [notificationMuArray addObject:dayDicOne];
    [notificationMuArray addObject:dayDicTwo];
    [notificationMuArray addObject:dayDicThree];
    [notificationMuArray addObject:dayDicForth];
    [notificationMuArray addObject:dayDicFirth];
    [notificationMuArray addObject:dayDicSix];
    
//    [notificationMuArray enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        MTNotificationVo *vo = [MTNotificationVo new];
//        vo.content = obj[@"content"];
//        vo.notificationId = obj[@"id"];
//        vo.time = obj[@"time"];
//        [self addNotificationWithVo:vo];
//    }];
    
}

@end
