//
//  MTUserInfoDefault.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/28.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTUserInfoDefault.h"
#import "MTMeModel.h"
#import "MTMediaFileManager.h"

static NSString *kUserInfoKey = @"userInfoKey";
static NSString *kLanagureKey = @"appLanguage";

@implementation MTUserInfoDefault


+ (void)saveDefaultUserInfo:(MTMeModel *)model
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    if (model.image) {
        [info setObject:model.image forKey:@"image"];
    }
    if (model.name) {
        [info setObject:model.name forKey:@"name"];
    }
    if (model.about) {
        [info setObject:model.about forKey:@"about"];
    }
    NSString *key = kUserInfoKey;
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (MTMeModel *)getUserDefaultMeModel
{
    NSString *key = kUserInfoKey;
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    MTMeModel *meModel = [[MTMeModel alloc] init];
    [meModel setValuesForKeysWithDictionary:info];
    meModel.image = [[MTMediaFileManager sharedManager]getUserImageFilePath];
    return meModel;
    
}

+ (void)saveDefaultLanagure:(BOOL)isChinese
{
    NSString *key = kLanagureKey;
    NSString *string = isChinese ? @"zh-Hans" : @"en";
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getUserDefaultLanagureIsChinese
{
    NSString *key = kLanagureKey;
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return ![string isEqualToString:@"en"];
}

+ (void)saveHomeWebURL:(NSDictionary*)url
{
    NSString *key = @"homeWebURL";
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getHomeWebURL
{
    NSString *key = @"homeWebURL";
    NSDictionary *string = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return string;
}

+ (void)saveAgreeSecretList
{
    NSString *key = @"AgreeSecretList";
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isAgreeSecretList
{
    NSString *key = @"AgreeSecretList";
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


@end
