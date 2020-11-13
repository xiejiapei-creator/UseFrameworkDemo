//
//  UIView+Custom.h
//  CategoryDemo
//
//  Created by 谢佳培 on 2020/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Custom)

#pragma mark - 获取属性值

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

#pragma mark - 添加图形

/** 为视图指定部分添加圆角 */
- (void)addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

@end

NS_ASSUME_NONNULL_END
