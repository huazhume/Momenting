//
//  MTNotePo+CoreDataProperties.m
//  
//
//  Created by xiaobai zhang on 2018/8/9.
//
//

#import "MTNotePo+CoreDataProperties.h"

@implementation MTNotePo (CoreDataProperties)

+ (NSFetchRequest<MTNotePo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTNotePo"];
}

@dynamic imagePath;
@dynamic noteId;
@dynamic text;
@dynamic width;
@dynamic height;

@end
