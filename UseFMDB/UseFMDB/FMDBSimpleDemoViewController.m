//
//  FMDBSimpleDemoViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/10/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "FMDBSimpleDemoViewController.h"
#import <FMDB.h>

#pragma mark - Model

@implementation UserModel

@end

#pragma mark - FMDBManager

@interface FMDBManager()
{
    NSString *_dataBasePath;// 数据库的路径
    FMDatabase *_fmdbDataBase;// 数据库对象
    BOOL _isFMDBopen;// 是否打开了数据库
}
@end

static FMDBManager *_sharedFMDB = nil;// 单例

@implementation FMDBManager

// 共享实例
+ (FMDBManager *)sharedFMDB
{
    
    if (_sharedFMDB == nil)
    {
        _sharedFMDB = [[FMDBManager alloc] init];
    }
    return _sharedFMDB;
}

// 初始化
- (id)init
{
    self = [super init];
    if (self)
    {
        // 打开数据库
        [self openDataBase];
    }
    return self;
}

// 打开数据库
- (void)openDataBase
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:@"FMDBDemo.sqlite"];
    _dataBasePath = dataBasePath;
    self.dataBasePath = dataBasePath;
    
    // 创建数据库
    if (_dataBasePath.length > 0)
    {
        _fmdbDataBase = [FMDatabase databaseWithPath:dataBasePath];
    }
    
    // 成功打开了数据库
    if ([_fmdbDataBase open])
    {
        _isFMDBopen = YES;
    }
    else
    {
        _isFMDBopen = NO;
        NSLog(@"打开数据库发生了错误");
    }
}

// 判断数据库中是否存在某张表
- (BOOL)isExistTable:(NSString *)tableName
{
    // 执行查询表的语句
    FMResultSet *resultSet = [_fmdbDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    
    while ([resultSet next])
    {
        // 表数
        NSInteger count = [resultSet intForColumn:@"count"];
        
        if (0 == count)
        {
            NSLog(@"表不存在");
            return NO;
        }
        else
        {
            NSLog(@"表已存在");
            return YES;
        }
    }
    
    return NO;
}

// 创建表
- (void)createTable
{
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE 'LuckCoffeeUser' ('userID' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'userName' text, 'passWord' text)"];
    
    // 不存在瑞幸咖啡用户这张表格则进行创建
    if (![self isExistTable:@"LuckCoffeeUser"])
    {
        BOOL isSuccess = [_fmdbDataBase executeUpdate:createTableSQL];
        if (!isSuccess)
        {
            NSLog(@"当创建瑞幸咖啡用户表的时候发生了错误");
        }
        else
        {
            NSLog(@"成功创建了瑞幸咖啡用户表");
        }
    }
}

// 插入数据
- (void)insertUserWithUserName:(NSString *)userName password:(NSString *)password
{
    NSString *insertUserSQL = [NSString stringWithFormat:@"insert into LuckCoffeeUser (userName, passWord) values(?, ?) "];
    BOOL isSuccess = [_fmdbDataBase executeUpdate:insertUserSQL,userName,password];
    
    if (!isSuccess)
    {
        NSLog(@"插入数据到瑞幸咖啡用户表的时候发生了错误");
    }
    else
    {
        NSLog(@"成功插入数据到瑞幸咖啡用户表");
    }
}

// 获取所有记录
- (NSMutableArray *)getAllUser
{
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    
    NSString *queryAllUserSQL = [NSString stringWithFormat:@"select * from LuckCoffeeUser"];
    FMResultSet *resultSet = [_fmdbDataBase executeQuery:queryAllUserSQL];
    
    while ([resultSet next])
    {
        UserModel *user = [[UserModel alloc] init];
        user.userId = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"userID"]];
        user.userName = [resultSet stringForColumn:@"userName"];
        user.passWord = [resultSet stringForColumn:@"passWord"];
        [userList addObject:user];
    }
    
    return userList;
}

// 删除某一条记录
- (BOOL)deleteUser:(NSInteger)userID
{
    NSString *deleteUserSQL = [NSString stringWithFormat:@"delete from LuckCoffeeUser where userID=%ld",(long)userID];
    return [_fmdbDataBase executeUpdate:deleteUserSQL];
}

// 在事务中处理操作
- (void)handleTransaction
{
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE 'LuckCoffeeUserTransaction' ('userID' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'userName' text, 'passWord' text)"];
    
    // 不存在瑞幸咖啡用户这张表格则进行创建
    if (![self isExistTable:@"LuckCoffeeUserTransaction"])
    {
        BOOL isSuccess = [_fmdbDataBase executeUpdate:createTableSQL];
        if (!isSuccess)
        {
            NSLog(@"当创建瑞幸咖啡用户表的时候发生了错误");
        }
        else
        {
            NSLog(@"成功创建了瑞幸咖啡用户表");
        }
    }
    
    // 开始执行事务
    [_fmdbDataBase beginTransaction];
    
    NSDate *begin = [NSDate date];// 开始时间
    BOOL rollBack = NO;// 是否执行回滚操作
    
    @try
    {
        for (int i= 0; i< 1000; i++)
        {
            NSString *insertUserSQL = [NSString stringWithFormat:@"insert into LuckCoffeeUserTransaction (userName, passWord) values(?, ?) "];
            BOOL isSuccess = [_fmdbDataBase executeUpdate:insertUserSQL,@"XieJiaPei",@"1525122040"];
            
            if (!isSuccess)
            {
                NSLog(@"插入数据到瑞幸咖啡用户表的时候发生了错误");
                rollBack = YES;// 只要有一次插入失败就执行回滚操作
                return;
            }
        }
    }
    @catch (NSException *exception)
    {
        rollBack = YES;
    }
    @finally
    {
        if (!rollBack)
        {
            // 不需要回滚就提交事务并执行
            [_fmdbDataBase commit];
        }
        else
        {
            // 否则进行回滚
            [_fmdbDataBase rollback];
        }
    }
    
    NSDate * end = [NSDate date];// 结束时间
    NSTimeInterval time = [end timeIntervalSinceDate:begin];
    NSLog(@"在事务中执行插入任务所需时间 === %f",time);
}

- (void)handleNoTransaction
{
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE 'LuckCoffeeUserNoTransaction' ('userID' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'userName' text, 'passWord' text)"];
    
    // 不存在瑞幸咖啡用户这张表格则进行创建
    if (![self isExistTable:@"LuckCoffeeUserNoTransaction"])
    {
        BOOL isSuccess = [_fmdbDataBase executeUpdate:createTableSQL];
        if (!isSuccess)
        {
            NSLog(@"当创建瑞幸咖啡用户表的时候发生了错误");
        }
        else
        {
            NSLog(@"成功创建了瑞幸咖啡用户表");
        }
    }
    
    NSDate * begin = [NSDate date];
    for (int i= 0; i< 1000; i++)
    {
        NSString *insertUserSQL = [NSString stringWithFormat:@"insert into LuckCoffeeUserNoTransaction (userName, passWord) values(?, ?) "];
        BOOL isSuccess = [_fmdbDataBase executeUpdate:insertUserSQL,@"XieJiaPei",@"1525122040"];
        
        if (!isSuccess)
        {
            NSLog(@"插入数据到瑞幸咖啡用户表的时候发生了错误");
        }
    }
    NSDate * end = [NSDate date];
    NSTimeInterval  time = [end timeIntervalSinceDate:begin];
    NSLog(@"不在事务中执行插入任务所需时间===%f",time);
}

- (void)buildDatabaseNotWithFMDatabaseQueue
{
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE 'LuckCoffeeUserNoFMDatabaseQueue' ('userID' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'userName' text, 'passWord' text)"];
    
    // 不存在瑞幸咖啡用户这张表格则进行创建
    if (![self isExistTable:@"LuckCoffeeUserNoFMDatabaseQueue"])
    {
        BOOL isSuccess = [_fmdbDataBase executeUpdate:createTableSQL];
        if (!isSuccess)
        {
            NSLog(@"当创建瑞幸咖啡用户表的时候发生了错误");
        }
        else
        {
            NSLog(@"成功创建了瑞幸咖啡用户表");
        }
    }
    
    dispatch_queue_t queue = dispatch_queue_create("queuet1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"当前线程为：%@",[NSThread currentThread]);
        
        for (int i= 0; i< 1000; i++)
        {
            NSString *insertUserSQL = [NSString stringWithFormat:@"insert into LuckCoffeeUserNoFMDatabaseQueue (userName, passWord) values(?, ?) "];
            BOOL isSuccess = [self->_fmdbDataBase executeUpdate:insertUserSQL,@"XieJiaPei",@"1525122040"];
            
            if (!isSuccess)
            {
                NSLog(@"插入数据到瑞幸咖啡用户表的时候发生了错误");
            }
        }
    });
}

- (void)buildDatabaseWithFMDatabaseQueue
{
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE 'LuckCoffeeUserFMDatabaseQueue' ('userID' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, 'userName' text, 'passWord' text)"];
    
    // 不存在瑞幸咖啡用户这张表格则进行创建
    if (![self isExistTable:@"LuckCoffeeUserFMDatabaseQueue"])
    {
        BOOL isSuccess = [_fmdbDataBase executeUpdate:createTableSQL];
        if (!isSuccess)
        {
            NSLog(@"当创建瑞幸咖啡用户表的时候发生了错误");
        }
        else
        {
            NSLog(@"成功创建了瑞幸咖啡用户表");
        }
    }
    
    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[FMDBManager sharedFMDB].dataBasePath];
    dispatch_queue_t queue = dispatch_queue_create("queuet1", DISPATCH_QUEUE_CONCURRENT);
    // 多个任务并发地添加进来了
    dispatch_async(queue, ^{
        NSLog(@"当前线程为：%@",[NSThread currentThread]);
        
        for (int i = 0; i < 50; i ++)
        {
            // 但是经过inDatabase处理后这些任务执行的顺序是顺序执行的
            [databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
                NSString *insertUserSQL = [NSString stringWithFormat:@"insert into LuckCoffeeUserFMDatabaseQueue (userName, passWord) values(?, ?) "];
                BOOL isSuccess = [self->_fmdbDataBase executeUpdate:insertUserSQL,@"XieJiaPei",@"1525122040"];
                
                if (!isSuccess)
                {
                    NSLog(@"插入数据到瑞幸咖啡用户表的时候发生了错误");
                }
            }];
        }
    });
}

@end

@interface FMDBSimpleDemoViewController ()

@end

@implementation FMDBSimpleDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self useFMDB];
    //[self handleTransaction];
    [self useFMDatabaseQueue];
}

- (void)useFMDB
{
    [[FMDBManager sharedFMDB] createTable];// 创建表
    // 插入
    [[FMDBManager sharedFMDB] insertUserWithUserName:@"XieJiaPei" password:@"1525122040"];
    [[FMDBManager sharedFMDB] insertUserWithUserName:@"BaiLuoMei" password:@"1625122040"];
    [[FMDBManager sharedFMDB] insertUserWithUserName:@"FanYiCheng" password:@"1725122040"];
    [[FMDBManager sharedFMDB] insertUserWithUserName:@"SunWuKong" password:@"1825122040"];
    [[FMDBManager sharedFMDB] insertUserWithUserName:@"LinFengMian" password:@"1925122040"];

    // 看看插入后的表格情况
    NSArray *userListAfterInsert = [[FMDBManager sharedFMDB] getAllUser];
    for (UserModel *user in userListAfterInsert)
    {
        NSLog(@"用户ID：%@，用户名称：%@，用户密码：%@",user.userId,user.userName,user.passWord);
    }
    
    [[FMDBManager sharedFMDB] deleteUser:2];
    
    // 看看删除后的表格情况
    NSArray *userListAfterDelete = [[FMDBManager sharedFMDB] getAllUser];
    for (UserModel *user in userListAfterDelete)
    {
        NSLog(@"用户ID：%@，用户名称：%@，用户密码：%@",user.userId,user.userName,user.passWord);
    }
}

- (void)handleTransaction
{
    [[FMDBManager sharedFMDB] openDataBase];
    
    [[FMDBManager sharedFMDB] handleTransaction];
    [[FMDBManager sharedFMDB] handleNoTransaction];
}

- (void)useFMDatabaseQueue
{
    [[FMDBManager sharedFMDB] openDataBase];
    
    //[[FMDBManager sharedFMDB] buildDatabaseNotWithFMDatabaseQueue];
    [[FMDBManager sharedFMDB] buildDatabaseWithFMDatabaseQueue];
}

@end

 




