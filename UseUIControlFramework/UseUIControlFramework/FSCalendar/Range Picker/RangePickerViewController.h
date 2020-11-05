//
//  RangePickerViewController.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar/FSCalendar.h>

@interface RangePickerCell : FSCalendarCell

// 范围的开始/结束
@property (weak, nonatomic) CALayer *selectionLayer;

// 范围的中间
@property (weak, nonatomic) CALayer *middleLayer;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RangePickerViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
