//
//  ViewController.m
//  LarryCoreData
//
//  Created by hd on 2018/4/16.
//  Copyright © 2018年 LarryTwoFly. All rights reserved.
//

#import "ViewController.h"

#import <CoreData/CoreData.h>
#import "CoreDataModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self look];
    [self insert];
    [self look];
    [self update];
    [self look];
}
//创建MOC
-(NSManagedObjectContext *)createMOV{
    // 创建上下文对象，并发队列设置为主队列
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

    // 创建托管对象模型，并使用Company.momd路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"Company" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];

    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"Company"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];

    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;
    return context;
}

//插入操作
-(void)insert{
    NSManagedObjectContext *context = [self createMOV];
    // 创建托管对象，并指明创建的托管对象所属实体名
    CoreDataModel *emp = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataModel" inManagedObjectContext:context];
    emp.num0 = 0;
    emp.num1 = 11;
    emp.str0 = @"str0";

    // 通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (context.hasChanges) {
        [context save:&error];
    }

    // 错误处理
    if (error) {
        NSLog(@"CoreData Insert Data Error : %@", error);
    }
}
//更新数据
-(void)update{
    NSManagedObjectContext *context = [self createMOV];
    // 建立获取数据的请求对象，并指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CoreDataModel"];

    // 创建谓词对象，设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"lxz"];
    request.predicate = predicate;

    // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray<CoreDataModel *> *CoreDataModels = [context executeFetchRequest:request error:&error];
    [CoreDataModels enumerateObjectsUsingBlock:^(CoreDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.num0 = 10;
    }];

    // 将上面的修改进行存储
    if (context.hasChanges) {
        [context save:nil];
    }

    // 错误处理
    if (error) {
        NSLog(@"CoreData Update Data Error : %@", error);
    }
}
//查看数据
-(void)look{
    NSManagedObjectContext *context = [self createMOV];
    // 建立获取数据的请求对象，并指明操作的实体为Employee
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CoreDataModel"];

    // 创建谓词对象，设置过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"lxz"];
    request.predicate = predicate;

    // 执行获取请求，获取到符合要求的托管对象
    NSError *error = nil;
    NSArray<CoreDataModel *> *CoreDataModels = [context executeFetchRequest:request error:&error];
    [CoreDataModels enumerateObjectsUsingBlock:^(CoreDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"num0=%ld\n num1=%ld\n str0=%@\n str1=%@\n",obj.num0,obj.num1,obj.str0,obj.str1);
    }];

    // 将上面的修改进行存储
    if (context.hasChanges) {
        [context save:nil];
    }

    // 错误处理
    if (error) {
        NSLog(@"CoreData Update Data Error : %@", error);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
