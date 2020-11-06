//
//  FullScreenViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "FullScreenViewController.h"
#import <EventKit/EventKit.h>// 事件
#import <FSCalendar/FSCalendar.h>

@interface LunarFormatter ()

@property (strong, nonatomic) NSCalendar *chineseCalendar;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSArray<NSString *> *lunarDays;
@property (strong, nonatomic) NSArray<NSString *> *lunarMonths;

@end

@implementation LunarFormatter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.calendar = self.chineseCalendar;
        self.formatter.dateFormat = @"M";
        self.lunarDays = @[@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
        self.lunarMonths = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    }
    return self;
}

// 根据国历日期获得对应农历日期
- (NSString *)stringFromDate:(NSDate *)date
{
    NSInteger day = [self.chineseCalendar component:NSCalendarUnitDay fromDate:date];
    if (day != 1)
    {
        return self.lunarDays[day-2];// 不是第一天则返回对应农历Day
    }
    
    // First day of month
    NSString *monthString = [self.formatter stringFromDate:date];
    if ([self.chineseCalendar.veryShortMonthSymbols containsObject:monthString])
    {
        return self.lunarMonths[monthString.integerValue-1];
    }
    
    // 闰月
    NSInteger month = [self.chineseCalendar component:NSCalendarUnitMonth fromDate:date];
    monthString = [NSString stringWithFormat:@"闰%@", self.lunarMonths[month-1]];
    return monthString;
}

@end

@interface FullScreenViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (assign, nonatomic) BOOL showsLunar;
@property (assign, nonatomic) BOOL showsEvents;
@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (strong, nonatomic) LunarFormatter *lunarFormatter;
@property (strong, nonatomic) NSArray<EKEvent *> *events;

- (void)todayItemClicked:(id)sender;
- (void)lunarItemClicked:(id)sender;
- (void)eventItemClicked:(id)sender;
- (void)loadCalendarEvents;
- (nullable NSArray<EKEvent *> *)eventsForDate:(NSDate *)date;

@end

@implementation FullScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Full Screen Calendar";
    
    _lunarFormatter = [[LunarFormatter alloc] init];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.minimumDate = [self.dateFormatter dateFromString:@"2020-02-03"];
    self.maximumDate = [self.dateFormatter dateFromString:@"2021-04-10"];
    self.calendar.accessibilityIdentifier = @"calendar";
    
    [self createSubviews];
    
    // 加载日期事件
    [self loadCalendarEvents];
}

- (void)createSubviews
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.view = view;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height)];
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO; // ！不支持翻页
    calendar.allowsMultipleSelection = YES;
    calendar.firstWeekday = 2;
    calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase|FSCalendarCaseOptionsHeaderUsesUpperCase;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
    
    UIBarButtonItem *lunarItem = [[UIBarButtonItem alloc] initWithTitle:@"Lunar" style:UIBarButtonItemStylePlain target:self action:@selector(lunarItemClicked:)];
    [lunarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor magentaColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *eventItem = [[UIBarButtonItem alloc] initWithTitle:@"Event" style:UIBarButtonItemStylePlain target:self action:@selector(eventItemClicked:)];
    [eventItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[eventItem ,lunarItem, todayItem];
}
 
// 收到内存警告时移除缓存
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.cache removeAllObjects];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.calendar.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+44, self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

#pragma mark - Target actions

- (void)todayItemClicked:(id)sender
{
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
}

// 显示农历
- (void)lunarItemClicked:(UIBarButtonItem *)item
{
    self.showsLunar = !self.showsLunar;
    [self.calendar reloadData];
}

// 点击日历事件
- (void)eventItemClicked:(id)sender
{
    self.showsEvents = !self.showsEvents;
    [self.calendar reloadData];
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.minimumDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return self.maximumDate;
}

// 每个日期的副标题
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    // 显示事件
    if (self.showsEvents)
    {
        EKEvent *event = [self eventsForDate:date].firstObject;
        if (event)
        {
            return event.title;
        }
    }
    
    // 显示农历
    if (self.showsLunar)
    {
        return [self.lunarFormatter stringFromDate:date];
    }
    return nil;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select %@",[self.dateFormatter stringFromDate:date]);
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

// 每个日期的事件个数
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    if (!self.showsEvents) return 0;
    if (!self.events) return 0;
    
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    return events.count;
}

// 每个日期的事件颜色
- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if (!self.showsEvents) return nil;
    if (!self.events) return nil;
    
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    NSMutableArray<UIColor *> *colors = [NSMutableArray arrayWithCapacity:events.count];
    [events enumerateObjectsUsingBlock:^(EKEvent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colors addObject:[UIColor colorWithCGColor:obj.calendar.CGColor]];
    }];
    return colors.copy;
}

#pragma mark - Private methods

// 从系统日历中获取限定日期范围内的日历事件
- (void)loadCalendarEvents
{
    __weak typeof(self) weakSelf = self;
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if(granted)
        {
            NSDate *startDate = self.minimumDate;
            NSDate *endDate = self.maximumDate;
            
            NSPredicate *fetchCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray<EKEvent *> *eventList = [store eventsMatchingPredicate:fetchCalendarEvents];
            NSArray<EKEvent *> *events = [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                return event.calendar.subscribed;
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf) return;
                weakSelf.events = events;
                [weakSelf.calendar reloadData];
            });
            
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"权限错误" message:@"获取事件需要日历权限" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
}

// 从日期获取对应事件并加入缓存
- (NSArray<EKEvent *> *)eventsForDate:(NSDate *)date
{
    NSArray<EKEvent *> *events = [self.cache objectForKey:date];
    if ([events isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    // 过滤事件
    NSArray<EKEvent *> *filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        // 判断条件是发生的日期相等
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    
    // 将事件加入缓存
    if (filteredEvents.count)
    {
        [self.cache setObject:filteredEvents forKey:date];
    }
    else
    {
        [self.cache setObject:[NSNull null] forKey:date];
    }
    return filteredEvents;
}

@end
