//
//  MTLanguageManager.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/9/14.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTLanguageManager.h"

@implementation MTLanguageManager

+ (MTLanguageManager *)shareInstance
{
    static MTLanguageManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MTLanguageManager alloc] init];
        
    });
    return manager;
}


- (void)config
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        
        if ([language hasPrefix:@"zh-Hans"]) {
            //开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
        }
    }
}

@end
