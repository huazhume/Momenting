//
//  MTNotePo+CoreDataProperties.m
//
//
//  Created by xiaobai zhang on 2019/3/26.
//
//

#import "MTNotePo+CoreDataProperties.h"

@implementation MTNotePo (CoreDataProperties)

+ (NSFetchRequest<MTNotePo *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MTNotePo"];
}

@dynamic height;
@dynamic imagePath;
@dynamic noteId;
@dynamic text;
@dynamic width;
@dynamic weather;

@end
