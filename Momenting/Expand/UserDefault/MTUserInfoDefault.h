//
//  MTUserInfoDefault.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/28.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTMeModel;

@interface MTUserInfoDefault : NSObject

+ (void)saveDefaultUserInfo:(MTMeModel *)model;

+ (MTMeModel *)getUserDefaultMeModel;

+ (void)saveDefaultLanagure:(BOOL)isChinese;

+ (BOOL)getUserDefaultLanagureIsChinese;

+ (void)saveHomeWebURL:(NSDictionary *)url;

+ (NSDictionary *)getHomeWebURL;

+ (void)saveAgreeSecretList;

+ (BOOL)isAgreeSecretList;

@end
