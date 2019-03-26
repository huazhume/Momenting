//
//  AppDelegate.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/7.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstance;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                   completion:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))completion;


@end

