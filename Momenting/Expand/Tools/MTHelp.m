//
//  MTHelp.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/23.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTHelp.h"

@implementation MTHelp

+ (UINavigationController *)currentNavigation
{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navigation;
    if([rootController isKindOfClass:[UINavigationController class]]){
        navigation = (UINavigationController *)rootController;
    }
    return navigation;
}

@end
