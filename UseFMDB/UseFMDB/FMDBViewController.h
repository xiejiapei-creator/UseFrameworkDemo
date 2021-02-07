//
//  FMDBViewController.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/10/10.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 用来缓存网络图片的数据库 */
@interface CreateDatabase : NSObject

/** 创建表单 */
- (BOOL)createTable;
/** 查询数据 */
- (NSString *)selectData:(NSString *)remoteUrl;
/** 删除数据 */
- (BOOL)deleteData:(NSString *)remoteUrl;
/** 添加数据 */
- (BOOL)addData:(NSString *)imageUrl remoteUrl:(NSString *)remoteUrl;

@end

@interface FMDBViewController : UIViewController



@end
 
