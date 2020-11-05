//
//  FMDBViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/10/10.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "FMDBViewController.h"
#import <FMDB.h>

@interface CreateDatabase ()

@property (nonatomic, strong, readwrite) FMDatabase *db;// 数据库
@property (nonatomic, strong, readwrite) FMDatabaseQueue *queue;// 任务队列

@end

@implementation CreateDatabase

// 初始化
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [documentPath stringByAppendingString:@"/xiejiapei.db"];
        NSURL *url = [NSURL URLWithString:path];
        
        NSLog(@"数据库地址为：%@", url);
        
        // 创建数据库和任务队列
        _queue = [FMDatabaseQueue databaseQueueWithURL:url];
        _db = [FMDatabase databaseWithURL:url];
        
        if (![_db open]) {
            NSLog(@"打开数据库失败");
        }
    }
    return self;
}

// 创建表单
- (BOOL)createTable
{
    // 打开数据库
    [_db open];
    
    // 创建表单的SQL语句
    NSString *sql = @"CREATE TABLE IF NOT EXISTS Image (remote_url text PRIMARY KEY NOT NULL, image_url text NOT NULL)";
    
    // 执行SQL语句
    BOOL success = [_db executeUpdate:sql];
    if (!success || [_db hadError])// 创建表单失败
    {
        // 关闭数据库
        [_db close];
        return NO;
    }
    else
    {
        // 关闭数据库
        [_db close];
        return YES;
    }
}

// 查询数据库
- (NSString *)selectData:(NSString *)remoteUrl
{
    // 打开数据库
    [_db open];
    
    // 查询SQL语句
    FMResultSet *userResult = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM image where remote_url = '%@';", remoteUrl]];
    
    // 获取查询结果
    NSString *imageUrl = [[NSString alloc] init];
    while ([userResult next])
    {
        imageUrl = [userResult stringForColumn:@"image_url"];
    }
    
    // 关闭数据库
    [_db close];
    
    return imageUrl;
}

// 删除数据
- (BOOL)deleteData:(NSString *)remoteUrl
{
    // 打开数据库
    [_db open];
    
    // 删除数据的SQL语句
    BOOL success = [_db executeUpdate:@"delete from image where image_url = ?", remoteUrl];
    
    if (!success || [_db hadError])// 删除数据失败
    {
        // 关闭数据库
        [_db close];
        return NO;
    }
    else
    {
        // 关闭数据库
        [_db close];
        return YES;
    }
}

// 添加数据
- (BOOL)addData:(NSString *)imageUrl remoteUrl:(NSString *)remoteUrl
{
    // 打开数据库
    [_db open];
    
    // 添加数据的SQL语句
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        [_db executeUpdate:@"INSERT INTO image ('image_url','remote_url') VALUES (?,?);", imageUrl ,remoteUrl];
    }];
    
    if ([_db hadError])// 添加数据失败
    {
        // 关闭数据库
        [_db close];
        return NO;
    }
    else
    {
        // 关闭数据库
        [_db close];
        return YES;
    }
}

@end

@interface FMDBViewController ()

// 获取得到的图片
@property (nonatomic,assign) UIImage *image;
// 图片缓存字典
@property (nonatomic, strong) NSMutableDictionary *imageCacheDict;
// 数据库
@property (nonatomic, strong) CreateDatabase *dataBase;
// 图像
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FMDBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubviews];
}

- (void)createSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(100, 100, 150, 150);
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    self.imageCacheDict = [[NSMutableDictionary alloc] init];
    self.dataBase = [[CreateDatabase alloc] init];
    [self.dataBase createTable];
    
    [self showImageWithURLString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1602901210&di=ce8b81d6dd50cf12263f36843f7bccd4&imgtype=jpg&er=1&src=http%3A%2F%2Fpics4.baidu.com%2Ffeed%2F3801213fb80e7bec1f568379f76a1e3e9a506b61.png%3Ftoken%3D84b2fa3895a800155fdf9802d26ca6c5"];
}

#pragma mark - 显示图片

- (void)showImageWithURLString:(NSString *)imageURL
{
    // 根据imageURL查询数据库后将URL保存到图片缓存字典，imageURL作为key
    self.imageCacheDict[imageURL] = [NSURL URLWithString:[self.dataBase selectData:[imageURL lastPathComponent]]];
    // 获取刚才保存的URL
    NSURL *cachedImageURL = self.imageCacheDict[imageURL];
    
    // 有效期为一天，过期删除
    NSArray *timeArray = [[cachedImageURL.path lastPathComponent] componentsSeparatedByString:@"+"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    BOOL isValid = (time - [timeArray[1] integerValue]) < 24 *3600;
    
    // 获取图片
    UITableViewCell *cell;
    if (cachedImageURL && isValid)// 缓存图片存在且有效
    {
        // 从URL中读取图片并显示
        self.imageView.image = [self imageForURL:cachedImageURL];
    }
    else if (cachedImageURL && !isValid)// 缓存图片存在但是无效
    {
        // 从字典和数据库中移除缓存图片
        [self.imageCacheDict removeObjectForKey:imageURL];
        [self.dataBase deleteData:[imageURL lastPathComponent]];
        
        // 下载新的图片并显示
        [self downloadImage:imageURL forCell:cell];
    }
    else// 缓存图片不存在
    {
        // 下载新的图片并显示
        [self downloadImage:imageURL forCell:cell];
    }
}

// 从URL中读取图片
- (UIImage *)imageForURL:(NSURL *)imageURL
{
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

#pragma mark - 下载（异步加载）

- (void)downloadImage:(NSString *)imageURL forCell:(UITableViewCell *)cell
{
    // 下载远端图片数据
    __weak FMDBViewController *weakself = self;

    NSURL *downloadURL = [NSURL URLWithString:imageURL];
    NSURLSession *URLSession = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [URLSession downloadTaskWithURL:downloadURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 获取图片的URL
        NSURL *cachedImageURL = [self writeImageToCacheFromLocation:location forDownloadURL:downloadURL];
        // 在主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 保存到图片缓存字典
            weakself.imageCacheDict[imageURL] = cachedImageURL;
            // 保存到数据库
            [weakself.dataBase addData:[NSString stringWithFormat:@"%@", cachedImageURL] remoteUrl:[NSString stringWithFormat:@"%@", [imageURL lastPathComponent]]];
            // 更新UI
            weakself.imageView.image = [self imageForURL:cachedImageURL];
        });
    }];
    [task resume];
}

#pragma mark - 写入缓存

- (NSURL *)writeImageToCacheFromLocation:(NSURL *)location forDownloadURL:(NSURL *)downloadURL
{
    // 创建缓存图片目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applocationSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *imageDirPath = [applocationSupportURL.path stringByAppendingPathComponent:@"image"];
    if (![fileManager fileExistsAtPath:imageDirPath])
    {
        [fileManager createDirectoryAtPath:imageDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 给路径传一个有效时间
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *fileName = [downloadURL.path lastPathComponent];
    NSString *imagePath = [imageDirPath stringByAppendingPathComponent:fileName];
    NSString *imagePathWithTime = [imagePath stringByAppendingString:[NSString stringWithFormat:@"%@%f",@"+" , time]];
    
    // 拷贝下载的图片到目标路径
    NSURL *imageURL = [NSURL fileURLWithPath:imagePathWithTime];
    [fileManager copyItemAtURL:location toURL:imageURL error:nil];
    return imageURL;
}

@end
