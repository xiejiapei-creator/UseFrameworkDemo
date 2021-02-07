//
//  FMDBSimpleDemoViewController.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/10/20.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Model

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *passWord;

@end

#pragma mark - FMDB

@interface FMDBManager : NSObject

@property (nonatomic, copy) NSString *dataBasePath;

// 单例获取对象
+ (FMDBManager *)sharedFMDB;

// 创建表
- (void)createTable;

// 插入记录
- (void)insertUserWithUserName:(NSString *)userName password:(NSString *)password;

// 获取所有记录
- (NSMutableArray *)getAllUser;

// 删除某人所有信息
- (BOOL)deleteUser:(NSInteger)userID;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FMDBSimpleDemoViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
