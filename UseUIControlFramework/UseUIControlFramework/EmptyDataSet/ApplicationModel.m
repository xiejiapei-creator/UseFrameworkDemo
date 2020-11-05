//
//  ApplicationModel.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "ApplicationModel.h"

@implementation ApplicationModel

#pragma mark - 接口方法的实现

// 初始化
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.displayName = dictionary[@"display_name"];
        self.developerName = dictionary[@"developer_name"];
        self.identifier = dictionary[@"identifier"];
    }
    return self;
}

// JSONAtPath
+ (NSArray *)applicationsFromJSONAtPath:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil];
    
    return [self applicationsFromJSON:JSON];
}

// JSON
+ (NSArray *)applicationsFromJSON:(id)JSON
{
    NSMutableArray *objects = [NSMutableArray new];
    
    for (NSDictionary *dictionary in JSON)
    {
        ApplicationModel *obj = [[ApplicationModel alloc] initWithDictionary:dictionary];
        [objects addObject:obj];
    }
    
    return objects;
}

#pragma mark - Getter/Setter

- (void)setDisplayName:(NSString *)displayName
{
    _displayName = displayName;
    
    self.iconName = [[[NSString stringWithFormat:@"icon_%@", displayName] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    self.type = applicationTypeFromString(displayName) + 1;
}

ApplicationType applicationTypeFromString(NSString *string)
{
    NSArray *array = @[
                     @"500px",
                     @"Airbnb",
                     @"AppStore",
                     @"Camera",
                     @"Dropbox",
                     @"Facebook",
                     @"Fancy",
                     @"Foursquare",
                     @"iCloud",
                     @"Instagram",
                     @"iTunes Connect",
                     @"Kickstarter",
                     @"Path",
                     @"Pinterest",
                     @"Photos",
                     @"Podcasts",
                     @"Remote",
                     @"Safari",
                     @"Skype",
                     @"Slack",
                     @"Tumblr",
                     @"Twitter",
                     @"Videos",
                     @"Vesper",
                     @"Vine",
                     @"WhatsApp",
                     @"WWDC"
                     ];
    // index
    return (ApplicationType)[array indexOfObject:string];
}

@end
