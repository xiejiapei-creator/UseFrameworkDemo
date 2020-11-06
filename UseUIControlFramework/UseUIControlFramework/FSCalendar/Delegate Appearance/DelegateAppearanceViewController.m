//
//  DelegateAppearanceViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "DelegateAppearanceViewController.h"
#import <FSCalendar/FSCalendar.h>

@interface DelegateAppearanceViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@property (strong, nonatomic) NSDictionary *fillSelectionColors;
@property (strong, nonatomic) NSDictionary *fillDefaultColors;
@property (strong, nonatomic) NSDictionary *borderDefaultColors;
@property (strong, nonatomic) NSDictionary *borderSelectionColors;

@property (strong, nonatomic) NSArray *datesWithEvent;
@property (strong, nonatomic) NSArray *datesWithMultipleEvents;

@end

@implementation DelegateAppearanceViewController

- (void)todayItemClicked:(id)sender
{
    [_calendar setCurrentPage:[NSDate date] animated:NO];
}

#pragma mark - FSCalendarDataSource

// 日期包含的事件个数
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString])
    {
        return 1;
    }
    if ([_datesWithMultipleEvents containsObject:dateString])
    {
        return 3;
    }
    return 0;
}

#pragma mark - FSCalendarDelegateAppearance

// 日期事件的颜色组
- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithMultipleEvents containsObject:dateString])
    {
        return @[[UIColor magentaColor],appearance.eventDefaultColor,[UIColor blackColor]];
    }
    return nil;
}

// 选中的颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_fillSelectionColors.allKeys containsObject:key])
    {
        return _fillSelectionColors[key];
    }
    return appearance.selectionColor;
}

// 默认的颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_fillDefaultColors.allKeys containsObject:key])
    {
        return _fillDefaultColors[key];
    }
    return nil;
}

// 边框的颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_borderDefaultColors.allKeys containsObject:key])
    {
        return _borderDefaultColors[key];
    }
    return appearance.borderDefaultColor;
}

// 边框选中的颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_borderSelectionColors.allKeys containsObject:key])
    {
        return _borderSelectionColors[key];
    }
    return appearance.borderSelectionColor;
}

// 边框的圆角大小
- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date
{
    if ([@[@8,@17,@21,@25] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])])
    {
        return 0.0;// 矩形
    }
    return 1.0;// 圆形
}


#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.view = view;
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 84, self.view.bounds.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.allowsMultipleSelection = YES;
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    // 当前月份页面
    [calendar setCurrentPage:[self.dateFormatter1 dateFromString:@"2020/10/03"] animated:NO];
    
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"TODAY" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
    self.navigationItem.rightBarButtonItem = todayItem;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"FSCalendar";
        
        // 默认颜色
        self.fillDefaultColors = @{@"2020/10/08":[UIColor purpleColor],// 紫色
                                     @"2020/10/06":[UIColor greenColor],// 绿色
                                     @"2020/10/18":[UIColor cyanColor],
                                     @"2020/10/22":[UIColor yellowColor],
                                     @"2020/11/08":[UIColor purpleColor],
                                     @"2020/11/06":[UIColor greenColor],
                                     @"2020/11/18":[UIColor cyanColor],
                                     @"2020/11/22":[UIColor yellowColor],
                                     @"2020/12/08":[UIColor purpleColor],
                                     @"2020/12/06":[UIColor greenColor],
                                     @"2020/12/18":[UIColor cyanColor],
                                     @"2020/12/22":[UIColor magentaColor]};
        
        // 选中的颜色
        self.fillSelectionColors = @{@"2020/10/08":[UIColor greenColor],// 选中后变为绿色
                                 @"2020/10/06":[UIColor purpleColor],// 选中后变为紫色
                                 @"2020/10/17":[UIColor grayColor],
                                 @"2020/10/21":[UIColor cyanColor],
                                 @"2020/11/08":[UIColor greenColor],
                                 @"2020/11/06":[UIColor purpleColor],
                                 @"2020/11/17":[UIColor grayColor],
                                 @"2020/11/21":[UIColor cyanColor],
                                 @"2020/12/08":[UIColor greenColor],
                                 @"2020/12/06":[UIColor purpleColor],
                                 @"2020/12/17":[UIColor grayColor],
                                 @"2020/12/21":[UIColor cyanColor]};
        
        // 边框的颜色
        self.borderDefaultColors = @{@"2020/10/08":[UIColor brownColor],// 棕色
                                     @"2020/10/17":[UIColor magentaColor],
                                     @"2020/10/21":FSCalendarStandardSelectionColor,
                                     @"2020/10/25":[UIColor blackColor],
                                     @"2020/11/08":[UIColor brownColor],
                                     @"2020/11/17":[UIColor magentaColor],
                                     @"2020/11/21":FSCalendarStandardSelectionColor,
                                     @"2020/11/25":[UIColor blackColor],
                                     @"2020/12/08":[UIColor brownColor],
                                     @"2020/12/17":[UIColor magentaColor],
                                     @"2020/12/21":FSCalendarStandardSelectionColor,
                                     @"2020/12/25":[UIColor blackColor]};
        
        // 边框选中的颜色
        self.borderSelectionColors = @{@"2020/10/08":[UIColor redColor],// 红色
                                       @"2020/10/17":[UIColor purpleColor],
                                       @"2020/10/21":FSCalendarStandardSelectionColor,
                                       @"2020/10/25":FSCalendarStandardTodayColor,
                                       @"2020/11/08":[UIColor redColor],
                                       @"2020/11/17":[UIColor purpleColor],
                                       @"2020/11/21":FSCalendarStandardSelectionColor,
                                       @"2020/11/25":FSCalendarStandardTodayColor,
                                       @"2020/12/08":[UIColor redColor],
                                       @"2020/12/17":[UIColor purpleColor],
                                       @"2020/12/21":FSCalendarStandardSelectionColor,
                                       @"2020/12/25":FSCalendarStandardTodayColor};
        
        // 带有事件的Date
        self.datesWithEvent = @[@"2020-10-03",// 一个点
                            @"2020-10-06",
                            @"2020-10-12",
                            @"2020-10-25"];
        
        // 带有多个事件的Date
        self.datesWithMultipleEvents = @[@"2020-10-08",// 多个点
                                     @"2020-10-16",
                                     @"2020-10-20",
                                     @"2020-10-28"];
        
        
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        self.dateFormatter1 = [[NSDateFormatter alloc] init];
        self.dateFormatter1.dateFormat = @"yyyy/MM/dd";
        
        self.dateFormatter2 = [[NSDateFormatter alloc] init];
        self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

@end

