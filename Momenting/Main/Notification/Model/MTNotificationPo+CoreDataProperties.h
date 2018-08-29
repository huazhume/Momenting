//
//  MTNotificationPo+CoreDataProperties.h
//  
//
//  Created by xiaobai zhang on 2018/8/29.
//
//

#import "MTNotificationPo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTNotificationPo (CoreDataProperties)

+ (NSFetchRequest<MTNotificationPo *> *)fetchRequest;

@property (nonatomic) int64_t state;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *notificationId;
@property (nullable, nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
