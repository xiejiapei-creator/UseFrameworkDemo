//
//  CycleScrollViewController.m
//  UseImageFrameworkDemo
//
//  Created by 谢佳培 on 2020/11/6.
//
#import "CycleScrollViewController.h"
#import <SDCycleScrollView.h>

#define SCREEN_WIDTH self.view.frame.size.width

@interface CycleScrollViewController () <SDCycleScrollViewDelegate>

@end

@implementation CycleScrollViewController
{
    NSArray *_titles;
    NSArray *_imageNames;
    NSArray *_imagesURLStrings;
    SDCycleScrollView *_customCellScrollView;
    UIScrollView *_ContainerView;
}

// 带标题的网络图片
- (void)URLImage
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    // page位置，默认居中
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    // 自定义分页控件小圆标颜色
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    // 添加标题
    cycleScrollView.titlesGroup = _titles;
    [_ContainerView addSubview:cycleScrollView];
    
    // 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = self->_imagesURLStrings;
    });
    
    // block监听点击方式
    cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        NSLog(@"block监听点击方式，位置为：%ld", (long)currentIndex);
    };
}

// 自定义分页控件
- (void)pageDot
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 350, SCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    [_ContainerView addSubview:cycleScrollView];
    
    // 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = self->_imagesURLStrings;
    });
}

// 本地图片
- (void)localImage
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 650, SCREEN_WIDTH, 300) shouldInfiniteLoop:YES imageNamesGroup:_imageNames];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 仅显示文字
    NSMutableArray *titlesArray = [NSMutableArray new];
    [titlesArray addObject:@"纯文字"];
    [titlesArray addObjectsFromArray:_titles];
    cycleScrollView.titlesGroup = [titlesArray copy];
    [cycleScrollView disableScrollGesture];
    
    [_ContainerView addSubview:cycleScrollView];
}

// 如果要实现自定义cell的轮播图，必须先实现代理方法
- (void)customCell
{
    _customCellScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 1000, SCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _customCellScrollView.imageURLStringsGroup = _imagesURLStrings;
    [_ContainerView addSubview:_customCellScrollView];
}

#pragma mark - SDCycleScrollViewDelegate

// 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld张图片", (long)index);
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVC") new] animated:YES];
}

// 滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"滚动到第%ld张图", (long)index);
}

#pragma mark - Life Circle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果你的CycleScrollview会在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
    // [你的CycleScrollview adjustWhenControllerViewWillAppear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createSubview];
    [self setUpDataSource];
    
    [self URLImage];
    [self pageDot];
    [self localImage];
    [self customCell];
}

// 创建视图
- (void)createSubview
{
    self.title = @"轮播图";
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    // 容器
    _ContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _ContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
    [self.view addSubview:_ContainerView];
}

// 数据源
- (void)setUpDataSource
{
    // 本地图片请填写全名
    NSArray *imageNames = @[@"稚气.PNG",
                            @"咖啡.JPG",
                            @"luckcoffee.JPG",
                            ];
    _imageNames = imageNames;
    
    // 网络图片
    NSArray *imagesURLStrings = @[
                            @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2509738482,1756079210&fm=26&gp=0.jpg",
                            @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1608781154,1940629457&fm=26&gp=0.jpg",
                            @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2675993795,1163311747&fm=26&gp=0.jpg"
                            ];
    _imagesURLStrings = imagesURLStrings;
    
    // 图片配文字
    NSArray *titles = @[@"欧洲历史上的中世纪",
                        @"是从奴隶制的西罗马帝国灭亡开始",
                        @"直到17世纪英国资产阶级革命爆发为止",
                        @"基督教思想制约中世纪文化",
                        @"基督教会成为封建统治的主要支柱"
                        ];
    _titles = titles;
}


@end

