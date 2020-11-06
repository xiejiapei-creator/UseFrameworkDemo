//
//  DIYViewController.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SelectionType)
{
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};


@interface DIYCalendarCell : FSCalendarCell

@property (weak, nonatomic) UIImageView *circleImageView;

@property (weak, nonatomic) CAShapeLayer *selectionLayer;

@property (assign, nonatomic) SelectionType selectionType;

@end

@interface DIYViewController : UIViewController

@end
