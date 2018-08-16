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
                po.sortIndex = idx;
                
            } else {
                MTNoteImageVo *vo = (MTNoteImageVo *)obj;
                MTNoteImagePo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNoteImagePo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
                po.path = vo.path;
                po.width = vo.width;
                po.height = vo.height;
                po.noteId = vo.noteId;
                po.sortIndex = idx;
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

- (NSArray *)getNoteDetailList:(NSString *)noteId
{
    NSFetchRequest *textRequest=[NSFetchRequest fetchRequestWithEntityName:@"MTNoteTextPo"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    textRequest.predicate = predicate;
    NSArray *textArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:textRequest error:nil];
    
    NSFetchRequest *imageRequest=[NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
    NSPredicate *imagePredicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    imageRequest.predicate=imagePredicate;
    NSArray *imageArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:imageRequest error:nil];
    
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithArray:textArray];
    [muArray addObjectsFromArray:imageArray];
    NSMutableArray *muVoArray = [NSMutableArray array];
    [muArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MTNoteTextPo class]]) {
            MTNoteTextVo *vo = [MTNoteTextVo new];
            MTNoteTextPo *po = (MTNoteTextPo *)obj;
            vo.text = po.text;
            vo.fontName = po.fontName;
            vo.fontSize = po.fontSize;
            vo.noteId = po.noteId;
            vo.sortIndex = po.sortIndex;
            [muVoArray addObject:vo];
            
        } else {
            MTNoteImageVo *vo = [MTNoteImageVo new];
            MTNoteImagePo *po = (MTNoteImagePo *)obj;
            vo.path = po.path;
            vo.width = po.width;
            vo.height = po.height;
            vo.noteId = po.noteId;
            vo.sortIndex = po.sortIndex;
            [muVoArray addObject:vo];
        }
    }];
    [muVoArray sortUsingComparator:^NSComparisonResult(MTNoteBaseVo *obj1, MTNoteBaseVo *obj2) {
        return obj1.sortIndex > obj2.sortIndex;
    }];

    return muVoArray;
}


- (BOOL)deleteNoteWithNoteId:(NSString *)noteId
{
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"noteId=%@",noteId];
    {
        NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNotePo"];
        deleRequest.predicate = predicate;
        NSArray *deleArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:deleRequest error:nil];
        for (MTNotePo *stu in deleArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    {
        NSFetchRequest *imageDeleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
        
        imageDeleRequest.predicate = predicate;
        NSArray *deleImageArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:imageDeleRequest error:nil];
        for (MTNoteImagePo *stu in deleImageArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    {
        NSFetchRequest *textDeleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNoteImagePo"];
        textDeleRequest.predicate = predicate;
        NSArray *deleTextArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:textDeleRequest error:nil];
        for (MTNoteTextPo *stu in deleTextArray) {
            [[[MTCoreDataManager shareInstance] managedObjectContext] deleteObject:stu];
        }
    }
    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        return YES;
    }else{
        return NO;
    }
}


@end
