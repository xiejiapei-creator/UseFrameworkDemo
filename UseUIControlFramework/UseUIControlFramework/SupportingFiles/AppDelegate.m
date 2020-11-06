//
//  AppDelegate.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/5.
//

#import "AppDelegate.h"
#import "FSTableViewController.h"
#import "ToastViewController.h"
#import "MBProgressHUDViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MBProgressHUDViewController *rootVC = [[MBProgressHUDViewController alloc] init];
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = mainNC;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
