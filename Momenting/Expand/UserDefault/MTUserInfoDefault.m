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
static NSString *kLanagureKey = @"lanagureKey";

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

+ (void)saveDefaultLanagure:(NSNumber *)lanagureStatus
{
    NSString *key = kLanagureKey;
    [[NSUserDefaults standardUserDefaults] setObject:lanagureStatus forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getUserDefaultLanagure
{
    NSString *key = kLanagureKey;
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return number.boolValue;
}


@end
