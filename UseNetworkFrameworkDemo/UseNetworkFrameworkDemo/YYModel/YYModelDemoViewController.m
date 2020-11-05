//
//  YYModelDemoViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/9/15.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "YYModelDemoViewController.h"

#pragma mark - JSON转换为模型，或者模型转换为JSON

@implementation FansModel

@end

@implementation FansViewModel

- (void)JSONConvertModel
{
    // JSON转换为模型
    NSDictionary *dict;
    FansModel *fansModelWithJSON = [FansModel yy_modelWithJSON:dict];
    FansModel *fansModelWithDictionary = [FansModel yy_modelWithDictionary:dict];

    // 模型转换为JSON
    NSDictionary *json = [fansModelWithJSON yy_modelToJSONObject];
}

@end


#pragma mark - 手动创建的模型和服务端返回的模型属性名称不一致

@implementation StarModel

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"avatarUrl" : @"avatar",
             @"wxNickName" : @"userName",
             @"accountId" : @"merchantId",
             @"unionId" : @"unionID",
             @"userid":@"userID",
             };
}

@end

@implementation StarViewModel

- (void)inconsistentName
{
    // JSON转换为模型
    NSDictionary *dict;
    StarModel *fansModelWithJSON = [StarModel yy_modelWithJSON:dict];
    StarModel *fansModelWithDictionary = [StarModel yy_modelWithDictionary:dict];
}

@end


#pragma mark - 模型套模型

@implementation BaseModel

// 将 id 映射为 _id
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    // 由于对accountId做了校验，所以如果accountId不符合要求，该JSON将不会被解析
    return @{@"_id": @"id"};
}

@end

@implementation AreaModel

@end

@implementation CityModel

// 模型套模型
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"areas" : [AreaModel class]};
}

@end

@implementation ProvinceModel

// 模型套模型
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"citys" : [CityModel class]};
}

@end

@implementation MapViewModel

- (void)modelContainer
{
    //将JSON转换为模型
    NSDictionary *dict;
    ProvinceModel *provinceModel = [ProvinceModel yy_modelWithJSON:dict];
    CityModel *cityModel = provinceModel.citys[0];
    AreaModel *areaModel = cityModel.areas[0];
}

@end

#pragma mark - 数组里面存放字典类型转换为模型

@implementation RabbitModel

@end

@implementation RabbitViewModel

// 转换为模型
- (void)manyRabbit
{
    NSArray *array;
    NSArray<RabbitModel *> *rabbitModelArray = [NSArray yy_modelArrayWithClass:[RabbitModel class] json:array];
}

@end

#pragma mark - 容器类属性

@implementation SchoolModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"teachers":[TeacherModel class]};
}

@end

@implementation TeacherModel

@end

@implementation SchoolViewModel

- (void)teachStudent
{
    // 转换为模型
    NSDictionary *dict = @{
      @"schoolName":@"厦门大学",
      @"teachers":@[
              @{@"teacherName":@"Sndday",@"teacherAge":@(50)},
              @{@"teacherName":@"Ssasas",@"teacherAge":@(70)},
              @{@"teacherName":@"Snddasa",@"teacherAge":@(30)}
              ],
      };

    SchoolModel *model = [SchoolModel yy_modelWithJSON:dict];
    TeacherModel *teacherModel = model.teachers[0];
}

@end

#pragma mark - 黑名单，即加入黑名单的字段会被忽略不会转换

@implementation BlacklistModel

// 加入黑名单的字段会被忽略不会转换
+ (NSArray *)modelPropertyBlacklist
{
    return @[@"avatarUrl", @"accountId"];
}

@end

@implementation BlacklistViewModel

- (void)blackList
{
    // 将JSON转换为模型，转换出来的模型中的avatarUrl和accountId的值为nil
    NSDictionary *dict;
    BlacklistModel *blacklistModel = [BlacklistModel yy_modelWithJSON:dict];
}

@end

#pragma mark - 白名单，即只处理加入白名单的字段，其余字段忽略掉

@implementation WhitelistModel

// 只处理加入白名单的字段，其余字段忽略掉
+ (NSArray *)modelPropertyWhitelist
{
    return @[@"avatarUrl", @"accountId"];
}

@end

@implementation WhitelistViewModel

- (void)whiteList
{
    // 将JSON转换为模型
    NSDictionary *dict;
    WhitelistModel *whitelistModel = [WhitelistModel yy_modelWithJSON:dict];
}

@end

#pragma mark - 数据校验与自定义转化

@implementation CustomTransformModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dict
{
    NSString *timestamp = dict[@"accountId"];
    if ([timestamp isEqualToString:@"<null>"])
    {
         return NO;
    }
    
    _resultStr = [NSString stringWithFormat:@"将后端返回的时间戳转换为时间字符串：%@",timestamp];
    return YES;
}

@end

@implementation CustomTransformViewModel

- (void)customTransform
{
    // 将JSON转换为模型
    NSDictionary *dict;
    CustomTransformModel *customTransformModel = [CustomTransformModel yy_modelWithJSON:dict];
}

@end

@implementation YYModelDemoViewController

@end
