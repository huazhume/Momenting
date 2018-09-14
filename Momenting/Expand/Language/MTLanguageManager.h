//
//  MTLanguageManager.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/9/14.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kLanguageNotification = @"MTLanguageViewController";

@interface MTLanguageManager : NSObject

+ (MTLanguageManager *)shareInstance;

- (void)config;

@end
