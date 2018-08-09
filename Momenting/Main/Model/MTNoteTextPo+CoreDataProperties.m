//
//  MTNoteTextPo+CoreDataProperties.m
//  
//
//  Created by xiaobai zhang on 2018/8/9.
//
//

#import "MTNoteTextPo+CoreDataProperties.h"

@implementation MTNoteTextPo (CoreDataProperties)

+ (NSFetchRequest<MTNoteTextPo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MTNoteTextPo"];
}

@dynamic fontSize;
@dynamic fontName;
@dynamic text;
@dynamic sortIndex;
@dynamic noteId;

@end
