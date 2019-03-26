//
//  MTNoteTextPo+CoreDataProperties.h
//  
//
//  Created by xiaobai zhang on 2018/8/9.
//
//

#import "MTNoteTextPo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTNoteTextPo (CoreDataProperties)

+ (NSFetchRequest<MTNoteTextPo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fontName;
@property (nonatomic) int64_t fontSize;
@property (nullable, nonatomic, copy) NSString *noteId;
@property (nonatomic) int64_t sortIndex;
@property (nullable, nonatomic, copy) NSString *text;
@property (nonatomic) int64_t fontType;

@end

NS_ASSUME_NONNULL_END
