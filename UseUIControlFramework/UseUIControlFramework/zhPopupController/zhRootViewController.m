//
//  zhRootViewController.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/6.
//

#import "zhRootViewController.h"
#import "zhPopupViewController.h"
#import "UIViewController+Custom.h"
#import "UIColor+Custom.h"
#import "UIImage+Custom.h"
#import <Masonry/Masonry.h>
#import <zhPopupController/zhPopupController.h>

@interface zhRootViewController ()

@end

@implementation zhRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 状态栏
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.translucent = NO;
    UIImage *backImage = [UIImage imageWithColor:[UIColor colorWithHex:@"0x70AFCE"]];
    [self.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 状态栏标题
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:22];
    self.navigationController.navigationBar.titleTextAttributes = textAttrs;
    self.title = @"zhPopupController";
    
    // 状态栏左边返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    NSMutableDictionary *backTextAttrs = [NSMutableDictionary dictionary];
    backTextAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:20];
    [backItem setTitleTextAttributes:backTextAttrs forState:UIControlStateNormal];
    [backItem setTitleTextAttributes:backTextAttrs forState:UIControlStateHighlighted];
    backItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backItem;
    
    // 进入菜单界面的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 2;
    button.backgroundColor = [UIColor colorWithHex:@"0x70AFCE"];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:17];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@40);
        make.top.equalTo(@270);
        make.centerX.equalTo(self.view);
    }];
}

- (void)next
{
    zhPopupViewController *vc = [zhPopupViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
