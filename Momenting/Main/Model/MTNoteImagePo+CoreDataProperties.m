//
//  MTNoteImagePo+CoreDataProperties.m
//  
//
//  Created by xiaobai zhang on 2018/8/9.
//
//

#import "MTNoteImagePo+CoreDataProperties.h"

@implementation MTNoteImagePo (CoreDataProperties)

+ (NSFetchRequest<MTNoteImagePo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTNoteImagePo"];
}

@dynamic width;
@dynamic height;
@dynamic path;
@dynamic sortIndex;
@dynamic noteId;

@end
