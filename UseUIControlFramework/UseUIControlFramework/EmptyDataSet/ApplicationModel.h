//
//  ApplicationModel.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ApplicationType)
{
    ApplicationTypeUndefined = 0,
    
    ApplicationType500px = 1,
    ApplicationTypeAirbnb,
    ApplicationTypeAppstore,
    ApplicationTypeCamera,
    ApplicationTypeDropbox,
    ApplicationTypeFacebook,
    ApplicationTypeFancy,
    ApplicationTypeFoursquare,
    ApplicationTypeiCloud,
    ApplicationTypeInstagram,
    ApplicationTypeiTunesConnect,
    ApplicationTypeKickstarter,
    ApplicationTypePath,
    ApplicationTypePinterest,
    ApplicationTypePhotos,
    ApplicationTypePodcasts,
    ApplicationTypeRemote,
    ApplicationTypeSafari,
    ApplicationTypeSkype,
    ApplicationTypeSlack,
    ApplicationTypeTumblr,
    ApplicationTypeTwitter,
    ApplicationTypeVideos,
    ApplicationTypeVesper,
    ApplicationTypeVine,
    ApplicationTypeWhatsapp,
    ApplicationTypeWWDC,
    
    ApplicationCount
};

@interface ApplicationModel : NSObject

/// APP的ID
@property (nonatomic, strong) NSString *identifier;
/// APP的类型
@property (nonatomic) ApplicationType type;
/// APP的名称
@property (nonatomic, strong) NSString *displayName;
/// 开发者的名称
@property (nonatomic, strong) NSString *developerName;
/// 图标的名称
@property (nonatomic, strong) NSString *iconName;

/** 初始化 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/** JSONAtPath */
+ (NSArray *)applicationsFromJSONAtPath:(NSString *)path;

/** JSON */
+ (NSArray *)applicationsFromJSON:(id)JSON;

@end

NS_ASSUME_NONNULL_END
