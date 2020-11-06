//
//  HidePlaceholderViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "HidePlaceholderViewController.h"
#import <FSCalendar/FSCalendar.h>

@interface HidePlaceholderViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (weak, nonatomic) UIView *bottomContainer;
@property (weak, nonatomic) UILabel *eventLabel;
@property (weak, nonatomic) UIButton *nextButton;
@property (weak, nonatomic) UIButton *prevButton;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (void)nextClicked:(id)sender;
- (void)prevClicked:(id)sender;

@end

@implementation HidePlaceholderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Prev-Next-Buttons Calendar";
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.appearance.separators = FSCalendarSeparatorInterRows;
    self.calendar.swipeToChooseGesture.enabled = YES;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    [self createSubview];
}

- (void)createSubview
{
    UIView *view;
    UIButton *button;
    
    view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.view = view;
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 400 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+44, CGRectGetWidth(self.view.frame), height)];
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;// 隐藏占位日期
    calendar.adjustsBoundingRectWhenChangingMonths = YES;// 当月份改变的时候自动调整矩形宽度
    calendar.currentPage = [self.dateFormatter dateFromString:@"2020-06-01"];
    calendar.firstWeekday = 2;// 以周一开始
    calendar.scrollDirection = FSCalendarScrollDirectionVertical;// 垂直翻转月份
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    view = [[UIView alloc] initWithFrame:(CGRectMake(0, CGRectGetMaxY(calendar.frame), CGRectGetWidth(self.view.frame), 50))];
    [self.view addSubview:view];
    self.bottomContainer = view;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 170, 50)];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [self.bottomContainer addSubview:label];
    self.eventLabel = label;
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(self.eventLabel.frame)+5, 10, 60, 30);
    [button setTitle:@"PREV" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(prevClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = button.tintColor.CGColor;
    button.layer.cornerRadius = 6;
    [self.bottomContainer addSubview:button];
    self.prevButton = button;
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(self.prevButton.frame)+5, 10, 60, 30);
    [button setTitle:@"NEXT" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 1;
    button.layer.borderColor = button.tintColor.CGColor;
    button.layer.cornerRadius = 6;
    [self.bottomContainer addSubview:button];
    self.nextButton = button;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
    attatchment.image = [UIImage imageNamed:@"icon_cat"];
    attatchment.bounds = CGRectMake(0, -3, attatchment.image.size.width, attatchment.image.size.height);
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"  Hey Daily Event  "]];
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    self.eventLabel.attributedText = attributedText.copy;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2016-01-08"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2018-10-08"];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    self.bottomContainer.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame), CGRectGetWidth(self.view.frame), 50);
}

- (void)nextClicked:(id)sender
{
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self.calendar.currentPage options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

- (void)prevClicked:(id)sender
{
    NSDate *prevMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:self.calendar.currentPage options:0];
    [self.calendar setCurrentPage:prevMonth animated:YES];
}

@end
