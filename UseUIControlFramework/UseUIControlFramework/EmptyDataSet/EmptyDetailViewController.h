//
//  EmptyDetailViewController.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmptyDetailViewController : UITableViewController

/// APP 数组
@property (nonatomic, weak) NSArray *applications;
/// 是否允许洗牌
@property (nonatomic) BOOL allowShuffling;

/** 初始化 */
- (instancetype)initWithApplication:(ApplicationModel *)application;

@end

NS_ASSUME_NONNULL_END
