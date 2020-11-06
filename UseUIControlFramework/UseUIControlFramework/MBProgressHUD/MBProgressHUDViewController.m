//
//  MBProgressHUDViewController.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/6.
//

#import "MBProgressHUDViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUDViewController ()

@property(nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation MBProgressHUDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化MBProgressHUD
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    // 添加ProgressHUD到界面中
    [self.view addSubview:self.progressHUD];
    
    [self setUPProgressHUD];
}

// 配置进度条的属性
- (void)setUPProgressHUD
{
    // 只能设置菊花的颜色 全局设置
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor redColor];
    
    // 提示框格式 Determinate-圆形饼图 HorizontalBar- 水平进度条
    // AnnularDeterminate-圆环 CustomView-自定义视图 Text-文本
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    
    // 设置进度框中的提示文字
    self.progressHUD.label.text = @"加载中...";
    // 信息详情
    _progressHUD.detailsLabel.text = @"人善如菊，夜凉如水...";
    // 进度指示器  模式是0，取值从0.0————1.0
    _progressHUD.progress = 0.5;
    
    // 设置背景框的透明度，默认0.8
    _progressHUD.bezelView.opaque = 1;
    // 设置背景颜色之后opacity属性的设置将会失效
    _progressHUD.bezelView.color = [[UIColor redColor] colorWithAlphaComponent:1];
    // 背景框的圆角值，默认是10
    _progressHUD.bezelView.layer.cornerRadius = 20;
    
    // 置提示框的相对于父视图中心点位置，正值 向右下偏移，负值左上
    [_progressHUD setOffset:CGPointMake(-80, -100)];
    // 设置各个元素距离矩形边框的距离
    [_progressHUD setMargin:5];
    // 背景框的最小尺寸
    _progressHUD.minSize = CGSizeMake(50, 50);
    // 是否强制背景框宽高相等
    _progressHUD.square = YES;
    
    // ZoomOut:逐渐的后退消失 ZoomIn：前进淡化消失
    // 默认类型的，渐变
    _progressHUD.animationType = MBProgressHUDAnimationFade;
    // 设置最短显示时间，为了避免显示后立刻被隐藏   默认是0
    _progressHUD.minShowTime = 5;
    
    // 被调用方法在宽限期内执行完，则HUD不会被显示
    // 为了避免在执行很短的任务时，去显示一个HUD窗口
    // _progressHUD.graceTime
    
    // 设置隐藏的时候是否从父视图中移除，默认是NO
    _progressHUD.removeFromSuperViewOnHide = NO;
    
    // 显示进度框
    [self.progressHUD showAnimated:YES];
    
    // 两种隐藏的方法
    // [_progressHUD hideAnimated:YES];
    [_progressHUD hideAnimated:YES afterDelay:5];
    
    // 隐藏时候的回调 隐藏动画结束之后
    _progressHUD.completionBlock = ^{
        NSLog(@"哈哈哈哈哈哈哈哈哈");
    };
}

@end
