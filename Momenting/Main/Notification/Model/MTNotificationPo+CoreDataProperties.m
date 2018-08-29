//
//  MTNotificationPo+CoreDataProperties.m
//  
//
//  Created by xiaobai zhang on 2018/8/29.
//
//

#import "MTNotificationPo+CoreDataProperties.h"

@implementation MTNotificationPo (CoreDataProperties)

+ (NSFetchRequest<MTNotificationPo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTNotificationPo"];
}

@dynamic state;
@dynamic content;
@dynamic notificationId;
@dynamic time;

@end
