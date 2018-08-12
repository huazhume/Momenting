//
//  MTNoteImagePo+CoreDataProperties.h
//  
//
//  Created by xiaobai zhang on 2018/8/9.
//
//

#import "MTNoteImagePo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTNoteImagePo (CoreDataProperties)

+ (NSFetchRequest<MTNoteImagePo *> *)fetchRequest;

@property (nonatomic) int64_t width;
@property (nonatomic) int64_t height;
@property (nullable, nonatomic, copy) NSString *path;
@property (nonatomic) int64_t sortIndex;
@property (nullable, nonatomic, copy) NSString *noteId;

@end

NS_ASSUME_NONNULL_END
