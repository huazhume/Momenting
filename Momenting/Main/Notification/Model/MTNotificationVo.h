//
//  MTNotificationVo.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/29.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTNotificationVo : NSObject

@property (copy, nonatomic) NSString *notificationId;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *time;

@property (strong, nonatomic) NSNumber *state;

@end
