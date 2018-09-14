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
#import "MTNotificationVo.h"
#import "MTNotificationPo+CoreDataProperties.h"

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


- (BOOL)insertNotificationDatas:(NSArray *)datas
{
    [datas enumerateObjectsUsingBlock:^(MTNotificationVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNotificationPo *po = [NSEntityDescription insertNewObjectForEntityForName:@"MTNotificationPo" inManagedObjectContext:[[MTCoreDataManager shareInstance] managedObjectContext]];
        po.notificationId = obj.notificationId;
        po.content = obj.content;
        po.time = obj.time;
        po.state = obj.state.integerValue;
    }];

    NSError *error = nil;
    if ([[[MTCoreDataManager shareInstance] managedObjectContext] save:&error]) {
        NSLog(@"数据插入到数据库成功");
        return YES;
    }else{
        NSLog(@"数据插入到数据库失败");
        return NO;
    }
}

- (NSArray *)getNotifications
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MTNotificationPo"];
    NSArray *array = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:request error:nil];
    NSMutableArray *muArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(MTNotificationPo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MTNotificationVo *po = [MTNotificationVo new];
        po.notificationId = obj.notificationId;
        po.content = obj.content;
        po.time = obj.time;
        po.state = [NSNumber numberWithInteger:obj.state];
        if (muArray.count == 0) {
            [muArray addObject:po];
        } else {
            [muArray insertObject:po atIndex:0];
        }
    }];
    return muArray;
}


- (BOOL)deleteNotificationWithContent:(NSString *)content
{
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"content=%@",content];
    {
        NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MTNotificationPo"];
        deleRequest.predicate = predicate;
        NSArray *deleArray = [[[MTCoreDataManager shareInstance] managedObjectContext] executeFetchRequest:deleRequest error:nil];
        for (MTNotePo *stu in deleArray) {
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


- (void)config
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"contentConfig"]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"info" forKey:@"contentConfig"];
    MTNoteTextVo *vo1 = [MTNoteTextVo new];
    vo1.noteId = @"note_01";
    vo1.text = @"今夕何夕兮搴洲中流。今日何日兮得与王子同舟。蒙羞被好兮不訾诟耻。心几烦而不绝兮得知王子。山有木兮木有枝。心悦君兮君不知。";
    
    MTNoteTextVo *vo2 = [MTNoteTextVo new];
    vo2.noteId = @"note_02";
    vo2.text = @"我想和你结婚，做炙热的亲吻，我想和在这开始私定终身。";
    
    MTNoteTextVo *vo3 = [MTNoteTextVo new];
    vo3.noteId = @"note_03";
    vo3.text = @"我想我爱你，不是三言两语，不是甜言蜜语，就能轻松地说明，想你也不必说个不停，每看你一眼都是清新，我们要一起数遍所有星星，看腻每个美景再重新，让我来填饱你的生活日记。";
    
    
    MTNoteTextVo *vo4 = [MTNoteTextVo new];
    vo4.noteId = @"note_04";
    vo4.text = @"知道吗？这里的雨季只有一两天，白昼很长 也很短，夜晚有三年，知道吗 今天的消息，说一号公路上 那座桥断了，我们还去吗，要不再说呢，会修一年吧，一年能等吗";
    
    
    MTNoteTextVo *vo5 = [MTNoteTextVo new];
    vo5.noteId = @"note_05";
    vo5.text = @"我真的好想你 在每一个雨季，你选择遗忘的 是我最不舍的，纸短情长啊 道不尽太多涟漪，我的故事都是关于你呀";
    
    MTNoteTextVo *vo6 = [MTNoteTextVo new];
    vo6.noteId = @"note_06";
    vo6.text = @"一棹春风一叶舟，一纶茧缕一轻钩。花满渚，酒满瓯，万顷波中得自由";
    
    MTNoteTextVo *vo7 = [MTNoteTextVo new];
    vo7.noteId = @"note_07";
    vo7.text =  @"樱桃落尽春将困，秋千架下归时。漏暗斜月迟迟，在花枝。彻晓纱窗下，待来君不知。";
    
    MTNoteTextVo *vo8 = [MTNoteTextVo new];
    vo8.noteId = @"note_08";
    vo8.text =  @"南风知我意，吹梦到西洲..";
    
    
    NSArray *selfArray = @[vo1,vo2,vo3,vo4,vo5,vo6,vo7,vo8];
    long time = (long)[[NSDate date]timeIntervalSince1970];
    [selfArray enumerateObjectsUsingBlock:^(MTNoteTextVo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.noteId = [NSString stringWithFormat:@"%ld",time + 60 * idx];
        [self insertDatas:@[obj] withType:MTCoreDataContentTypeNoteContent];
        MTNoteModel *po = [MTNoteModel new];
        po.noteId = obj.noteId;
        po.text = obj.text;
        [self insertDatas:@[po] withType:MTCoreDataContentTypeNoteSelf];
        
    }];
    
}

+ (MTCoreDataDao *)shareInstance
{
    static MTCoreDataDao *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MTCoreDataDao alloc] init];
        
    });
    
    return manager;
}


@end
