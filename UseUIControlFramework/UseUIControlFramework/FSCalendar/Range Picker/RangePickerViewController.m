//
//  RangePickerViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "RangePickerViewController.h"

@implementation RangePickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CALayer *selectionLayer = [[CALayer alloc] init];
        selectionLayer.backgroundColor = [UIColor orangeColor].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]}; // 移除隐藏动画
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        CALayer *middleLayer = [[CALayer alloc] init];
        middleLayer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor;
        middleLayer.actions = @{@"hidden":[NSNull null]}; // 移除隐藏动画
        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
        self.middleLayer = middleLayer;
        
        // 隐藏默认选择层
        self.shapeLayer.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.contentView.bounds;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    self.selectionLayer.frame = self.contentView.bounds;
    self.middleLayer.frame = self.contentView.bounds;
}

@end

@interface RangePickerViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (weak, nonatomic) UILabel *eventLabel;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@end

@implementation RangePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubview];
}

- (void)createSubview
{
    // 初始化属性
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";

    // 创建calendar
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO;
    calendar.allowsMultipleSelection = YES;
    calendar.rowHeight = 60;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    calendar.appearance.titleDefaultColor = [UIColor blackColor];
    calendar.appearance.headerTitleColor = [UIColor blackColor];
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    
    calendar.scope = FSCalendarScopeWeek;
    calendar.weekdayHeight = 20;

    calendar.swipeToChooseGesture.enabled = YES;
    
    // Hide the today circle
    // calendar.today = nil;
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"RangePickerCell"];
}

#pragma mark - FSCalendarDataSource

// 最小日期
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2020-06-08"];
}

// 最大日期
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:10 toDate:[NSDate date] options:0];
}

// 今日的标题
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date])
    {
        return @"今";
    }
    return nil;
}

// 创建Cell
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"RangePickerCell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

// 配置Cell
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

// 是否可以选中日期
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

// 是否支持反选日期
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

// 选中日期
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    // 如果选择是由滑动手势引起的
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged)
    {
        
        if (!self.startDate)
        {
            self.startDate = date;
        }
        else
        {
            if (self.endDate)
            {
                [calendar deselectDate:self.endDate];
            }
            self.endDate = date;
        }
    }
    else
    {
        if (self.endDate)
        {
            [calendar deselectDate:self.startDate];
            [calendar deselectDate:self.endDate];
            self.startDate = date;
            self.endDate = nil;
        }
        else if (!self.startDate)
        {
            self.startDate = date;
        }
        else
        {
            self.endDate = date;
        }
    }
    
    [self configureVisibleCells];
}

// 取消选中
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"取消选中的日期为：%@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

// 日期事件颜色
- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date])
    {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

// 配置可见日期的选中状态
- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

// 配置每一个日期的选中状态
- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent)
    {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.startDate && self.endDate)
    {
        BOOL isMiddle = [date compare:self.startDate] != [date compare:self.endDate];
        rangeCell.middleLayer.hidden = !isMiddle;
    }
    else
    {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.startDate && [self.gregorian isDate:date inSameDayAsDate:self.startDate];
    isSelected |= self.endDate && [self.gregorian isDate:date inSameDayAsDate:self.endDate];
    rangeCell.selectionLayer.hidden = !isSelected;
}

@end
