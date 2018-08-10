//
//  MTCoreDataDao.m
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/9.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import "MTCoreDataDao.h"
#import "MTCoreDataManager.h"
#import "MTNoteModel.h"
#import "MTNotePo+CoreDataProperties.h"
#import "MTNoteTextPo+CoreDataProperties.h"
#import "MTNoteImagePo+CoreDataProperties.h"

@implementation MTCoreDataDao

- (BOOL)insertDatas:(NSArray *)datas withType:(MTCoreDataContentType)type
{
    if (type == MTCoreDataContentTypeNoteSelf) {
        [datas enumerateObjectsUsingBlock:^(MTNoteModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MTNotePo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNotePo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
            po.noteId = obj.noteId;
            po.imagePath = obj.imagePath;
            po.text = obj.text;
            po.width = obj.width;
            po.height = obj.height;
        }];
    } else {
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MTNoteTextVo class]]) {
                MTNoteTextVo *vo = (MTNoteTextVo *)obj;
                MTNoteTextPo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNoteTextPo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
                po.text = vo.text;
                po.fontName = vo.fontName;
                po.fontSize = vo.fontSize;
                po.noteId = vo.noteId;
                po.sortIndex = vo.sortIndex;
                
            } else {
                MTNoteImageVo *vo = (MTNoteImageVo *)obj;
                MTNoteImagePo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNoteImagePo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
                po.path = vo.path;
                po.width = vo.width;
                po.height = vo.height;
                po.noteId = vo.noteId;
                po.sortIndex = vo.sortIndex;
            }
        }];
    }
    
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"数据插入到数据库成功");
        return YES;
    }else{
        NSLog(@"数据插入到数据库失败");
        return NO;
    }
}

- (NSArray *)getNoteSelf
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MTNotePo"];
    NSArray *array = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *muArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MTNotePo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNoteModel *model = [MTNoteModel new];
        model.noteId = obj.noteId;
        model.imagePath = obj.imagePath;
        model.text = obj.text;
        model.width = obj.width;
        model.height = obj.height;
        if (muArray.count == 0) {
            [muArray addObject:model];
        } else {
            [muArray insertObject:model atIndex:0];
        }
    }];
    return muArray;
}

@end
