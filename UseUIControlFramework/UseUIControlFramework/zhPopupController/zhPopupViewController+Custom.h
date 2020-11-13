//
//  zhPopupViewController+Custom.h
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/9.
//

#import "zhPopupViewController.h"
#import "CustomAlertView.h"
#import "OverflyView.h"
#import "CurtainView.h"
#import "SidebarView.h"
#import "FullView.h"
#import "WallView.h"

NS_ASSUME_NONNULL_BEGIN

@interface zhPopupViewController (Custom)

/** 切换城市的提示 */
- (CustomAlertView *)switchCitiesAlert;

/** 询问喜好的Toast */
- (CustomAlertView *)favouriteToastStyle;

/** 创建火箭视图 */
- (OverflyView *)overflyView;

/** 创建窗帘视图 */
- (CurtainView *)curtainView;

/** 创建侧边栏视图 */
- (SidebarView *)sidebarView;

/** 创建全屏视图 */
- (FullView *)fullView;

/** 创建分享视图 */
- (WallView *)wallView;

/** 分享视图的Model */
- (NSArray *)wallModels;

@end

NS_ASSUME_NONNULL_END
