//
//  MTCoreDataDao.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/9.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MTCoreDataContentTypeNoteSelf,
    MTCoreDataContentTypeNoteContent,
} MTCoreDataContentType;

@interface MTCoreDataDao : NSObject

- (BOOL)insertDatas:(NSArray *)datas withType:(MTCoreDataContentType)type;

- (NSArray *)getNoteSelf;

- (NSArray *)getNoteDetailList:(NSString *)noteId;

- (BOOL)deleteNoteWithNoteId:(NSString *)noteId;

@end
