//
//  MTNotePo+CoreDataProperties.h
//  
//
//  Created by xiaobai zhang on 2018/8/9.
//
//

#import "MTNotePo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MTNotePo (CoreDataProperties)

+ (NSFetchRequest<MTNotePo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imagePath;
@property (nullable, nonatomic, copy) NSString *noteId;
@property (nullable, nonatomic, copy) NSString *text;
@property (nonatomic) int64_t width;
@property (nonatomic) int64_t height;

@end

NS_ASSUME_NONNULL_END
