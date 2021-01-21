//
//  AppDelegate.m
//  UseTextFrameworkDemo
//
//  Created by 谢佳培 on 2020/11/5.
//

#import "AppDelegate.h"
#import "UICountingLabelViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UICountingLabelViewController *rootVC = [[UICountingLabelViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
