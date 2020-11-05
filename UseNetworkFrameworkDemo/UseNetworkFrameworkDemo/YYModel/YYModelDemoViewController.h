//
//  YYModelDemoViewController.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/9/15.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYModel.h>

#pragma mark - JSON转换为模型，或者模型转换为JSON

/** JSON
{
    accountId = "<null>";
    avatarUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/sqicFCgiaheqCFbjrYgTmwXUQOB5l5Iyo47cVVp2cLlHARck6XgXscqicJ2ZVibicCbGH4iaVcQz8ptXqbV6n9ic5iaL9g/132";
    unionId = o2t87wKAR1pNRZR0cnReBT608mok;
    userid = 11703346;
    wxNickName = "\U90a3\U5496";
}
*/

@interface FansModel : NSObject

// Model
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *wxNickName;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *userid;

@end

@interface FansViewModel : NSObject

@end

#pragma mark - 手动创建的模型和服务端返回的模型属性名称不一致

/** JSON
 { "merchantId" = "<null>";
   "avatar" = "http://thirdwx.qlogo.cn/mmopen/vi_32/sqicFCgiaheqCFbjrYgTmwXUQOB5l5Iyo47cVVp2cLlHARck6XgXscqicJ2ZVibicCbGH4iaVcQz8ptXqbV6n9ic5iaL9g/132";
   "unionID" = "o2t87wKAR1pNRZR0cnReBT608mok";
   "userID" = "11703346";
   "userName" = "谢佳培";
 }
 */

@interface StarModel : NSObject <YYModel>

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *wxNickName;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *userid;

@end

@interface StarViewModel : NSObject

@end

#pragma mark - 模型套模型

/** JSON
 {
     citys =   (
                 {
             area = "<null>";
             areaId = "<null>";
             areas =             (
                                 {
                     area = "\U4e1c\U57ce\U533a";
                     cityid = 110100;
                     id = 110101;
                     status = 1;
                 },
                                 {
                     area = "\U5e73\U8c37\U533a";
                     cityid = 110100;
                     id = 110117;
                     status = 1;
                 }
             );
             city = "\U5e02\U8f96\U533a";
             cityId = "<null>";
             id = 110100;
             province = "<null>";
             provinceid = 110000;
             status = 1;
         },
                 {
             area = "<null>";
             areaId = "<null>";
             areas =             (
                                 {
                     area = "\U5bc6\U4e91\U53bf";
                     cityid = 110200;
                     id = 110228;
                     status = 1;
                 },
                                 {
                     area = "\U5ef6\U5e86\U53bf";
                     cityid = 110200;
                     id = 110229;
                     status = 1;
                 }
             );
             city = "\U53bf";
             cityId = "<null>";
             id = 110200;
             province = "<null>";
             provinceid = 110000;
             status = 1;
         }
     );
     id = 110000;
     province = "\U5317\U4eac\U5e02";
     status = 1;
 }
 */

// BaseModel 只是为了将 id 映射为 _id
@interface BaseModel : NSObject <YYModel>

// id 映射为 _id
@property (nonatomic, copy) NSString *_id;

@end

// 地区
@interface AreaModel : BaseModel

@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *status;

@end

// 城市
@interface CityModel : BaseModel

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *provinceid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray *areas;

@end

// 省份
@interface ProvinceModel : BaseModel

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSArray *citys;

@end

@interface MapViewModel : NSObject

@end

#pragma mark - 数组里面存放字典类型转换为模型

/**
 //JSON
 (
 {
 "accountId" = "<null>";
 "avatarUrl" = "http://thirdwx.qlogo.cn/mmopen/vi_32/sqicFCgiaheqCFbjrYgTmwXUQOB5l5Iyo47cVVp2cLlHARck6XgXscqicJ2ZVibicCbGH4iaVcQz8ptXqbV6n9ic5iaL9g/132";
 "unionId" = "o2t87wKAR1pNRZR0cnReBT608mok";
 "userid" = "11703346",
 "wxNickName" = "谢佳培"
 },
 {
 "accountId" = "<null>";
 "avatarUrl" = "http://thirdwx.qlogo.cn/mmopen/vi_32/sqicFCgiaheqCFbjrYgTmwXUQOB5l5Iyo47cVVp2cLlHARck6XgXscqicJ2ZVibicCbGH4iaVcQz8ptXqbV6n9ic5iaL9g/132";
 "unionId" = "o2t87wKAR1pNRZR0cnReBT608mok";
 "userid" = "11293020";
 "wxNickName" = "兔子";
 }
 );
 */

// Model
@interface RabbitModel : NSObject

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *wxNickName;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *userid;

@end

@interface RabbitViewModel : NSObject

@end

#pragma mark - 容器类属性

/** JSON
 {
 "schoolName" = "厦门大学";
 "teachers" =  (
       {"teacherName"= "Sndday","teacherAge" = 50};
       {"teacherName" = "Ssasas","teacherAge" = 70};
       {"teacherName" = "Snddasa","teacherAge"= 30)}
       );
 };
 */

// 学校
@interface SchoolModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSArray *teachers;

@end

// 老师
@interface TeacherModel : NSObject

@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, assign) NSInteger teacherAge;

@end

@interface SchoolViewModel : NSObject

@end

#pragma mark - 黑名单，即加入黑名单的字段会被忽略不会转换

/** JSON
 {
     accountId = "<null>";
     avatarUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/sqicFCgiaheqCFbjrYgTmwXUQOB5l5Iyo47cVVp2cLlHARck6XgXscqicJ2ZVibicCbGH4iaVcQz8ptXqbV6n9ic5iaL9g/132";
     unionId = o2t87wKAR1pNRZR0cnReBT608mok;
     userid = 11703346;
     wxNickName = "\U90a3\U5496";
 }
 */

@interface BlacklistModel : NSObject <YYModel>

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *wxNickName;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *userid;

@end

@interface BlacklistViewModel : NSObject

@end

#pragma mark - 白名单，即只处理加入白名单的字段，其余字段忽略掉

/** JSON
 {
     accountId = "<null>";
     avatarUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/sqicFCgiaheqCFbjrYgTmwXUQOB5l5Iyo47cVVp2cLlHARck6XgXscqicJ2ZVibicCbGH4iaVcQz8ptXqbV6n9ic5iaL9g/132";
     unionId = o2t87wKAR1pNRZR0cnReBT608mok;
     userid = 11703346;
     wxNickName = "\U90a3\U5496";
 }
 */

@interface WhitelistModel : NSObject <YYModel>

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *wxNickName;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *userid;

@end

@interface WhitelistViewModel : NSObject

@end

#pragma mark - 数据校验与自定义转化

/**
 {
     accountId = "<null>";
     avatarUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/sqicFCgiaheqCFbjrYgTmwXUQOB5l5Iyo47cVVp2cLlHARck6XgXscqicJ2ZVibicCbGH4iaVcQz8ptXqbV6n9ic5iaL9g/132";
     unionId = o2t87wKAR1pNRZR0cnReBT608mok;
     userid = 11703346;
     wxNickName = "\U90a3\U5496";
 }
 */

@interface CustomTransformModel : NSObject <YYModel>

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *wxNickName;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *unionId;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *resultStr;

@end

@interface CustomTransformViewModel : NSObject

@end

@interface YYModelDemoViewController : UIViewController

@end
 


