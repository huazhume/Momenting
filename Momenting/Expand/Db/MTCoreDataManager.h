//
//  HMCoreDataStackManager.h
//  Momenting
//
//  Created by xiaobai zhang on 2018/8/8.
//  Copyright © 2018年 xiaobai zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

//导入CoreData框架
#import <CoreData/CoreData.h>

#define kMTCoreDataManager [MTCoreDataManager shareInstance]

//kHMCoreDataStackManager

@interface MTCoreDataManager : NSObject

//单利实现
+ (MTCoreDataManager *)shareInstance;

//管理对象上下文
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;

//模型对象
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;


//存储调度器
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;


//保存
- (void)save;

@end
