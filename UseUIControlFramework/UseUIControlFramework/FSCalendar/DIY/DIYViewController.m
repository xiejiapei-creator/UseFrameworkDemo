//
//  DIYViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "DIYViewController.h"
#import <FSCalendarExtensions.h>

@implementation DIYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle"]];
        [self.contentView insertSubview:circleImageView atIndex:0];
        self.circleImageView = circleImageView;
        
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        selectionLayer.fillColor = [UIColor blackColor].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        self.shapeLayer.hidden = YES;
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        
    }
    return self;
}

// 绘制选中的圆圈
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectInset(self.bounds, 1, 1);
    self.circleImageView.frame = self.backgroundView.frame;
    self.selectionLayer.frame = self.bounds;
    
    if (self.selectionType == SelectionTypeMiddle)
    {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:self.selectionLayer.bounds].CGPath;
    }
    else if (self.selectionType == SelectionTypeLeftBorder)
    {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.selectionLayer.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.selectionLayer.fs_width/2, self.selectionLayer.fs_width/2)].CGPath;
    }
    else if (self.selectionType == SelectionTypeRightBorder)
    {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.selectionLayer.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(self.selectionLayer.fs_width/2, self.selectionLayer.fs_width/2)].CGPath;
    }
    else if (self.selectionType == SelectionTypeSingle)
    {
        
        CGFloat diameter = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width);
        self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter/2, self.contentView.fs_height/2-diameter/2, diameter, diameter)].CGPath;
        
    }
}

// 重写内置外观配置
- (void)configureAppearance
{
    [super configureAppearance];
    
    // 占位的日期用灰色表示
    if (self.isPlaceholder)
    {
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.eventIndicator.hidden = YES;
    }
}

// 更新选中类型
- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType)
    {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}

@end

@interface DIYViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (weak, nonatomic) UILabel *eventLabel;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation DIYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"DIYCalendar";
    
    [self createSubview];
    
    // 初始化属性
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    // 选中的日期（前今明天）
    [self.calendar selectDate:[self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0] scrollToDate:NO];
    [self.calendar selectDate:[NSDate date] scrollToDate:NO];
    [self.calendar selectDate:[self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSDate date] options:0] scrollToDate:NO];
    
    // Uncomment this to perform an 'initial-week-scope'
    // self.calendar.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
}

- (void)createSubview
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.view = view;
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.navigationController.navigationBar.frame) + 44, view.frame.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.swipeToChooseGesture.enabled = YES;// 支持滑动选中手势
    calendar.allowsMultipleSelection = YES;// 支持多选
    [view addSubview:calendar];
    self.calendar = calendar;
    
    // 头部视图
    calendar.calendarHeaderView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    // 周视图
    calendar.calendarWeekdayView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    // 事件选中的颜色
    calendar.appearance.eventSelectionColor = [UIColor whiteColor];
    // 事件偏移量
    calendar.appearance.eventOffset = CGPointMake(0, -7);
    // 隐藏今天的圆圈
    calendar.today = nil;
    // 注册Cell
    [calendar registerClass:[DIYCalendarCell class] forCellReuseIdentifier:@"cell"];
    
    // 扇动的手势
    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:calendar action:@selector(handleScopeGesture:)];
    [calendar addGestureRecognizer:scopeGesture];
    
    // 创建事件Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.view addSubview:label];
    self.eventLabel = label;
    
    // 配置事件Label的文本属性
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
    attatchment.image = [UIImage imageNamed:@"icon_cat"];
    attatchment.bounds = CGRectMake(0, -3, attatchment.image.size.width, attatchment.image.size.height);
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"  Hey Daily Event  "]];
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    self.eventLabel.attributedText = attributedText.copy;
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2020-10-08"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:5 toDate:[NSDate date] options:0];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date])
    {
        return @"今";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    DIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

// 事件数量
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return 2;
}

#pragma mark - FSCalendarDelegate

// 调整事件Label的位置
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    
    self.eventLabel.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50);
    
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date: %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date: %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date])
    {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 可以获取到Cell所对应的日期值
        NSDate *date = [self.calendar dateForCell:obj];
        // 可以获取到Cell所在的月份位置，比如知道是本月还是下一个月
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    DIYCalendarCell *diyCell = (DIYCalendarCell *)cell;
    
    // 自定义今日圆圈，如果是今日则显示红色圆圈
    diyCell.circleImageView.hidden = ![self.gregorian isDateInToday:date];
    
    // 配置选择图层即边框位置
    if (monthPosition == FSCalendarMonthPositionCurrent)
    {
        SelectionType selectionType = SelectionTypeNone;
        
        NSLog(@"选中的日期包括：%@",self.calendar.selectedDates);
        if ([self.calendar.selectedDates containsObject:date])
        {
            NSDate *previousDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
            NSDate *nextDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
            
            if ([self.calendar.selectedDates containsObject:date])
            {
                if ([self.calendar.selectedDates containsObject:previousDate] && [self.calendar.selectedDates containsObject:nextDate])
                {
                    // 选中日期包含昨天和明天则居中
                    selectionType = SelectionTypeMiddle;
                }
                else if ([self.calendar.selectedDates containsObject:previousDate] && [self.calendar.selectedDates containsObject:date])
                {
                    // 选中日期包含昨天和今天则边框居于右边
                    selectionType = SelectionTypeRightBorder;
                }
                else if ([self.calendar.selectedDates containsObject:nextDate])
                {
                    // 选中日期包含明天和今天则边框居于左边
                    selectionType = SelectionTypeLeftBorder;
                }
                else
                {
                    // 只包含今天则只有一个边框
                    selectionType = SelectionTypeSingle;
                }
            }
        }
        else
        {
            // 未选中
            selectionType = SelectionTypeNone;
            NSLog(@"未选中");
        }
        
        // 未选中则隐藏选中图层直接返回
        if (selectionType == SelectionTypeNone)
        {
            diyCell.selectionLayer.hidden = YES;
            NSLog(@"未选中则隐藏选中图层");
            return;
        }
        
        // 选中则显示并更新选中图层
        diyCell.selectionLayer.hidden = NO;
        diyCell.selectionType = selectionType;
        
        NSLog(@"选中则显示并更新选中图层");
        
    }
    else
    {
        // 不是当前处理的日期月份页面（比如下一个月）则直接隐藏圆圈和选中图层
        diyCell.circleImageView.hidden = YES;
        diyCell.selectionLayer.hidden = YES;
        
        NSLog(@"不是当前处理的日期月份页面（比如下一个月）则直接隐藏圆圈和选中图层");
    }
}

@end
