//
//  MTNoteTextPo+CoreDataProperties.m
//
//
//  Created by xiaobai zhang on 2019/3/19.
//
//

#import "MTNoteTextPo+CoreDataProperties.h"

@implementation MTNoteTextPo (CoreDataProperties)

+ (NSFetchRequest<MTNoteTextPo *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MTNoteTextPo"];
}

@dynamic fontName;
@dynamic fontSize;
@dynamic noteId;
@dynamic sortIndex;
@dynamic text;
@dynamic fontType;

@end
