//
//  UICountingLabelViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "UICountingLabelViewController.h"
#import <UICountingLabel.h>

@interface UICountingLabelViewController ()

@property (strong, nonatomic) UICountingLabel *completionBlockLabel;

@end

@implementation UICountingLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubview];
}

- (void)createSubview
{
    // 做一个算数的
    UICountingLabel *myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 100, 200, 40)];
    myLabel.method = UILabelCountingMethodLinear;// 线性变化
    myLabel.format = @"%d";
    [self.view addSubview:myLabel];
    [myLabel countFrom:1 to:10 withDuration:3.0];
    
    // 使用ease-in-out（默认设置）将计数从5%增加到10%
    UICountingLabel *countPercentageLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 170, 200, 40)];
    [self.view addSubview:countPercentageLabel];
    countPercentageLabel.format = @"%.1f%%";
    [countPercentageLabel countFrom:5 to:10];
    
    // 使用使用数字格式化的字符串进行计数
    UICountingLabel *scoreLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 210, 200, 40)];
    [self.view addSubview:scoreLabel];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    // 可以对显示的文本格式进行自定义
    scoreLabel.formatBlock = ^NSString *(CGFloat value)
    {
        NSString *formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"Score: %@",formatted];
    };
    scoreLabel.method = UILabelCountingMethodEaseOut;// 开始速度很快，快结束时变得缓慢
    [scoreLabel countFrom:0 to:10000 withDuration:2.5];// 可以指定动画的时长，默认时长是2.0秒
    
    // 使用属性字符串计数
    NSInteger toValue = 100;
    UICountingLabel *attributedLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 270, 200, 40)];
    [self.view addSubview:attributedLabel];
    
    // 用于设置属性字符串的格式，如果指定了formatBlock，则将会覆盖掉format属性，因为block的优先级更高
    attributedLabel.attributedFormatBlock = ^NSAttributedString* (CGFloat value)
    {
        NSDictionary *normal = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-UltraLight" size: 20] };
        NSDictionary *highlight = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 20] };
        
        NSString *prefix = [NSString stringWithFormat:@"%d", (int)value];
        NSString *postfix = [NSString stringWithFormat:@"/%d", (int)toValue];
        
        NSMutableAttributedString *prefixAttr = [[NSMutableAttributedString alloc] initWithString: prefix attributes: highlight];
        NSAttributedString *postfixAttr = [[NSAttributedString alloc] initWithString: postfix attributes: normal];
        [prefixAttr appendAttributedString: postfixAttr];
        
        return prefixAttr;
    };
    [attributedLabel countFrom:0 to:toValue withDuration:2.5];
    
    // 获得动画结束的事件
    self.completionBlockLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(10, 370, 200, 40)];
    [self.view addSubview:self.completionBlockLabel];
    self.completionBlockLabel.method = UILabelCountingMethodEaseInOut;
    self.completionBlockLabel.format = @"%d%%";
    
    __weak UICountingLabelViewController *weakSelf = self;
    self.completionBlockLabel.completionBlock = ^{
        weakSelf.completionBlockLabel.textColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    };
    [self.completionBlockLabel countFrom:0 to:100];
}

@end




