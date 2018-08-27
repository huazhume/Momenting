//
//  NSDateFormatter+Category.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/27.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "NSDateFormatter+Category.h"

@implementation NSDateFormatter (Category)

+ (NSDateFormatter *)sharedFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
    });
    return formatter;
}

+ (NSDateFormatter *)my_getHHmmFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"HH:mm"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_gethhmmFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"hh:mm"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getDefaultFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"yyyy/MM/dd"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getMMddHHmmssFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"MM-dd HH:mm:ss"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getMMddHHmmFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"MM-dd HH:mm"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getYYMMddHHmmFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [NSDateFormatter sharedFormatter];
}


+ (NSDateFormatter *)my_getHHmmssFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"HH:mm:ss"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getOralMMddHHmmFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"MM月dd日 HH:mm"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getSegmentMMddHHmmFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"MM/dd HH:mm"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getYYMMddFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"yyyy-MM-dd"];
    return [NSDateFormatter sharedFormatter];
}

+ (NSDateFormatter *)my_getDDFormatter
{
    [[NSDateFormatter sharedFormatter] setDateFormat:@"dd"];
    return [NSDateFormatter sharedFormatter];
}

@end
