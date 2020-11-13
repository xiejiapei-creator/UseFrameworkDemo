//
//  zhPopupViewController.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/6.
//

#import "zhPopupViewController.h"
#import "MBProgressHUDViewController.h"
#import "CustomAlertView.h"
#import "OverflyView.h"
#import "CurtainView.h"
#import "FullView.h"
#import "WallView.h"
#import "KeyboardView.h"
#import "zhPopupViewController+Custom.h"
#import "UIViewController+Custom.h"
#import <zhPopupController/zhPopupController.h>

static void *CellButtonKey = &CellButtonKey;// 用来关联cell和button

@interface zhPopupViewController ()<UITableViewDelegate, UITableViewDataSource, WallViewDelegateConfig>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *styles;
@property (nonatomic, assign) BOOL isLightStatusBar;// 状态栏是否亮
@property (nonatomic, strong) CenterKeyboardView *centerKeyboardView;
@property (nonatomic, strong) RegisterKeyboardView *registerKeyboardView;

@property (nonatomic, strong) zhPopupController *switchCitiesStyle;
@property (nonatomic, strong) zhPopupController *toastStyle;
@property (nonatomic, strong) zhPopupController *overflyStyle;
@property (nonatomic, strong) zhPopupController *qzoneStyle;
@property (nonatomic, strong) zhPopupController *sidebarStyle;
@property (nonatomic, strong) zhPopupController *fullStyle;
@property (nonatomic, strong) zhPopupController *shareStyle;
@property (nonatomic, strong) zhPopupController *centerKeyboardStyle;
@property (nonatomic, strong) zhPopupController *commentKeyboardStyle;

@end

@implementation zhPopupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSubview];
}

- (void)createSubview
{
    self.title = @"zhPopupController";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(25, 0, 35, 0);
    }
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (!_styles)
    {
        _styles = @[@"Switch Cities Style", @"Favourite Toast Style", @"Overfly Style", @"Qzone Style", @"Sidebar Style", @"Full Style", @"Shared Style", @"Center Keyboard Style", @"Comment Keyboard style"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _styles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor colorWithHex:@"0x70AFCE"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:17];
        button.layer.cornerRadius = 2;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@200);
            make.height.equalTo(@40);
            make.center.equalTo(cell.contentView);
        }];
        [cell setAssociatedValue:button withKey:CellButtonKey];
    }
    
    // 获取与cell关联的button
    UIButton *button = (UIButton *)[cell getAssociatedValueForKey:CellButtonKey];
    [button setTitle:_styles[indexPath.row] forState:UIControlStateNormal];
    button.tag = indexPath.row;
    return cell;
}

// 共用的Event入口
- (void)buttonClicked:(UIButton *)sender
{
    // 获取到Sel
    NSString *selName = [NSString stringWithFormat:@"test%lu", sender.tag + 1];
    SEL sel = NSSelectorFromString(selName);
    
    // 调用Sel
    if ([self respondsToSelector:sel])
    {
        self.title = _styles[sender.tag];
        [self performSelector:sel withObject:nil afterDelay:0];
    }
}

#pragma mark - Switch Cities Style

- (zhPopupController *)switchCitiesStyle
{
    if (!_switchCitiesStyle)
    {
        CustomAlertView *alertView = [self createHorizontalAlertView];
        
        // 展示方式为提示框
        _switchCitiesStyle = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
        _switchCitiesStyle.presentationStyle = zhPopupSlideStyleTransform;
        _switchCitiesStyle.presentationTransformScale = 1.25;
        _switchCitiesStyle.dismissonTransformScale = 0.85;
    }
    return _switchCitiesStyle;
}

// 创建水平提示框
- (CustomAlertView *)createHorizontalAlertView
{
    CustomAlertView *alertView = [self switchCitiesAlert];
    alertView.layer.cornerRadius = 3;
    alertView.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    alertView.messageLabel.textColor = [UIColor blackColor];
    alertView.messageLabel.font = [UIFont fontWithName:@"pingFangSC-light" size:16];
    
    CustomAlertButton *cancelButton = [CustomAlertButton buttonWithTitle:@"取消" handler:^(CustomAlertButton *button) {
        NSLog(@"点击了取消按钮：%@",button.currentTitle);
    }];
    
    __weak typeof(self) weakSelf = self;
    CustomAlertButton *okButton = [CustomAlertButton buttonWithTitle:@"确定" handler:^(CustomAlertButton * button) {
        [weakSelf.switchCitiesStyle dismiss];
    }];
    
    cancelButton.lineColor = [UIColor colorWithHex:@"0x70AFCE"];
    okButton.lineColor = [UIColor colorWithHex:@"0x70AFCE"];
    [cancelButton setTitleColor:[UIColor colorWithHex:@"0x70AFCE"] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithHex:@"0x70AFCE"] forState:UIControlStateNormal];
    cancelButton.edgeInsets = UIEdgeInsetsMake(22, 0, 0, 0);
    
    [alertView adjoinWithLeftAction:cancelButton rightAction:okButton];
    
    return alertView;
}

// 创建垂直提示框
- (CustomAlertView *)createVerticalAlertView
{
    CustomAlertView *alertView = [self switchCitiesAlert];
    alertView.layer.cornerRadius = 3;
    alertView.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    alertView.messageLabel.textColor = [UIColor blackColor];
    alertView.messageLabel.font = [UIFont fontWithName:@"pingFangSC-light" size:16];
    
    CustomAlertButton *cancelButton = [CustomAlertButton buttonWithTitle:@"取消" handler:^(CustomAlertButton *button) {
        NSLog(@"点击了取消按钮：%@",button.currentTitle);
    }];
    
    CustomAlertButton *submitButton = [CustomAlertButton buttonWithTitle:@"提交" handler:^(CustomAlertButton *button) {
        NSLog(@"点击了提交按钮：%@",button.currentTitle);
    }];
    
    __weak typeof(self) weakSelf = self;
    CustomAlertButton *okButton = [CustomAlertButton buttonWithTitle:@"确定" handler:^(CustomAlertButton * button) {
        [weakSelf.switchCitiesStyle dismiss];
    }];
    
    cancelButton.lineColor = [UIColor colorWithHex:@"0x70AFCE"];
    submitButton.lineColor = [UIColor colorWithHex:@"0x70AFCE"];
    okButton.lineColor = [UIColor colorWithHex:@"0x70AFCE"];
    [cancelButton setTitleColor:[UIColor colorWithHex:@"0x70AFCE"] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor colorWithHex:@"0x70AFCE"] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithHex:@"0x70AFCE"] forState:UIControlStateNormal];
    
    // 保持取消按钮和标题之前存在空白间隙
    cancelButton.edgeInsets = UIEdgeInsetsMake(22, 0, 0, 0);
    
    [alertView addAlertButton:cancelButton];
    [alertView addAlertButton:submitButton];
    [alertView addAlertButton:okButton];
    
    return alertView;
}

// 点击按钮呈现提示框
- (void)test1
{
    [self.switchCitiesStyle showInView:self.view.window completion:^{
        NSLog(@"城市切换的提示框");
    }];
}

#pragma mark - Toast Style

// 创建Toast
- (zhPopupController *)toastStyle
{
    if (!_toastStyle)
    {
        CustomAlertView *alertView = [self createFavouriteToastView];
        
        // 展示方式为Toast
        _toastStyle = [[zhPopupController alloc] initWithView:alertView size:alertView.bounds.size];
        _toastStyle.presentationStyle = zhPopupSlideStyleTransform;
        _toastStyle.maskType = zhPopupMaskTypeDarkBlur;// 黑色模糊遮罩
        _toastStyle.dismissOnMaskTouched = NO;// 点击黑色模糊遮罩则Toast消失
    }
    return _toastStyle;
}

// 点击按钮呈现Toast
- (void)test2
{
    // 0.75秒后自动消失
    [self.toastStyle showInView:self.view.window duration:0.75 bounced:YES completion:^{
        NSLog(@"询问喜好的Toast");
    }];
}

// 创建视图
- (CustomAlertView *)createFavouriteToastView
{
    CustomAlertView *alert = [self favouriteToastStyle];
    
    __weak typeof(self) weakSelf = self;
    CustomAlertButton *okButton = [CustomAlertButton buttonWithTitle:@"确定" handler:^(CustomAlertButton * button) {
        [weakSelf.toastStyle dismiss];
    }];
    okButton.edgeInsets = UIEdgeInsetsMake(20, 20, 25, 20);
    okButton.backgroundColor = [UIColor colorWithRed:27/255.0 green:159/255.0 blue:253/255.0 alpha:1.0];
    okButton.layer.cornerRadius = 5;
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alert addAlertButton:okButton];
    
    return alert;
}

#pragma mark - Overfly Style

// 创建火箭弹出视图
- (zhPopupController *)overflyStyle
{
    if (!_overflyStyle)
    {
        OverflyView *overflyView = [self createOverflyView];
        
        _overflyStyle = [[zhPopupController alloc] initWithView:overflyView size:overflyView.bounds.size];
        _overflyStyle.dismissOnMaskTouched = NO;
        // 从底部滑出
        _overflyStyle.presentationStyle = zhPopupSlideStyleFromBottom;
        // 从顶部消失
        _overflyStyle.dismissonStyle = zhPopupSlideStyleFromTop;
        // 控制弹出视图偏离的位置
        _overflyStyle.offsetSpacing = 20;
    }
    return _overflyStyle;
}

// 点击展示火箭视图
- (void)test3
{
    [self.overflyStyle showInView:self.view.window completion:^{
        NSLog(@"展示火箭视图");
    }];
}

// 创建Alert Button
- (OverflyView *)createOverflyView
{
    OverflyView *overflyView = [self overflyView];
    
    __weak typeof(self) weakSelf = self;
    OverflyButton *ignoreOverflyButton = [OverflyButton buttonWithTitle:@"忽略" handler:^(OverflyButton * _Nonnull button) {
        [weakSelf.overflyStyle dismiss];
    }];
    [ignoreOverflyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    OverflyButton *viewDetailsOverflyButton = [OverflyButton buttonWithTitle:@"查看详情" handler:^(OverflyButton * _Nonnull button) {
        NSLog(@"点击了查看详情");
    }];
    [viewDetailsOverflyButton setTitleColor:[UIColor colorWithRed:236/255.0 green:78/255.0 blue:39/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [overflyView adjoinWithLeftOverflyButton:ignoreOverflyButton rightOverflyButton:viewDetailsOverflyButton];
    
    return overflyView;
}

#pragma mark - Qzone style

// 创建窗帘视图
- (zhPopupController *)qzoneStyle
{
    if (!_qzoneStyle)
    {
        CurtainView *curtainView = [self createCurtainView];
        
        _qzoneStyle = [[zhPopupController alloc] initWithView:curtainView size:curtainView.bounds.size];
        _qzoneStyle.layoutType = zhPopupLayoutTypeTop;// 位置在顶部
        _qzoneStyle.presentationStyle = zhPopupSlideStyleFromTop;// 从顶部滑入呈现
        _qzoneStyle.offsetSpacing = -30;// 偏移量
        
        __weak typeof(self) weakSelf = self;
        // 窗帘即将呈现的时候状态栏文字变暗
        _qzoneStyle.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            weakSelf.isLightStatusBar = NO;
        };
        
        // 窗帘即将消失的时候状态栏文字变亮
        _qzoneStyle.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
            weakSelf.isLightStatusBar = YES;
        };
    }
    return _qzoneStyle;
}

// 点击后弹出窗帘视图
- (void)test4
{
    [self.qzoneStyle showInView:self.view.window duration:0.75 bounced:YES completion:^{
        NSLog(@"点击后弹出窗帘视图");
    }];
}

// 提供窗帘视图按钮的点击事件
- (CurtainView *)createCurtainView
{
    CurtainView *curtainView = [self curtainView];
    
    __weak typeof(self) weakSelf = self;
    // 点击后窗帘消失
    curtainView.closeClicked = ^(UIButton *closeButton) {
        [weakSelf.qzoneStyle dismiss];
    };
    
    // 点击后弹出提示框
    curtainView.didClickItems = ^(CurtainView *curtainView, NSInteger index) {
        [self showAlert:curtainView.items[index].titleLabel.text];
    };
    
    return curtainView;
}

// 弹出提示框
- (void)showAlert:(NSString *)text
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 0, 270, 70);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    label.text = text;
    label.font = [UIFont fontWithName:@"palatino-boldItalic" size:20];
    
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:label size:label.bounds.size];
    popupController.dismissAfterDelay = 1;// 1秒后消失
    popupController.maskType = zhPopupMaskTypeBlackOpacity;// 黑色遮罩
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.layoutType = zhPopupLayoutTypeTop;// 位置在顶部
    popupController.offsetSpacing = 90;// 偏移量
    
    UIView *window = UIApplication.sharedApplication.keyWindow;
    [popupController showInView:window duration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
}

// 设置状态栏是否亮
- (void)setIsLightStatusBar:(BOOL)isLightStatusBar
{
    _isLightStatusBar = isLightStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

// 我在这上面耽搁了半个多小时.......这鬼东西就是不执行
// 重写childViewControllerForStatusBarStyle方法也不会执行
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // UIStatusBarStyleDarkContent 文字黑色
    // UIStatusBarStyleLightContent 文字白色
    return self.isLightStatusBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - Sidebar style

// 创建侧边栏视图
- (zhPopupController *)sidebarStyle
{
    if (!_sidebarStyle)
    {
        SidebarView *sidebar = [self createSidebarView];
        _sidebarStyle = [[zhPopupController alloc] initWithView:sidebar size:sidebar.bounds.size];
        _sidebarStyle.layoutType = zhPopupLayoutTypeLeft;// 布局在左边
        _sidebarStyle.presentationStyle = zhPopupSlideStyleFromLeft;// 从左边出现
        _sidebarStyle.panGestureEnabled = YES;// 支持扇动手势
        _sidebarStyle.panDismissRatio = 0.5;// 到Sidebar出现的比例少于自身一半的时候则隐藏
    }
    
    return _sidebarStyle;
}

// 点击后弹出侧边栏
- (void)test5
{
    [self.sidebarStyle showInView:self.view.window completion:^{
        NSLog(@"点击后弹出侧边栏");
    }];
}

// 实现侧边栏按钮的点击事件
- (SidebarView *)createSidebarView
{
    SidebarView *sidebar = [self sidebarView];
    
    __weak typeof(self) weakSelf = self;
    sidebar.didClickItems = ^(SidebarView *sidebarView, NSInteger index) {
        [weakSelf.sidebarStyle dismiss];
        [self showAlert:sidebarView.items[index].titleLabel.text];
    };
    
    return sidebar;
}

#pragma mark - Full Style

// 创建全屏视图
- (zhPopupController *)fullStyle
{
    if (!_fullStyle)
    {
        FullView *fullView = [self createFullView];
        _fullStyle = [[zhPopupController alloc] initWithView:fullView size:fullView.bounds.size];
        _fullStyle.maskType = zhPopupMaskTypeExtraLightBlur;
        _fullStyle.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            [fullView startAnimationsWithCompletion:^(BOOL finished) {
                NSLog(@"弹出全屏视图完成");
            }];
        };
    }
    return _fullStyle;
}
 
// 点击弹出全屏视图
- (void)test6
{
    [self.fullStyle showInView:self.view.window completion:^{
        NSLog(@"点击弹出全屏视图");
    }];
}

// 实现全屏视图按钮的点击事件
- (FullView *)createFullView
{
    FullView *fullView = [self fullView];
    
    __weak typeof(self) weakSelf = self;
    // 点击屏幕
    fullView.didClickFullView = ^(FullView * _Nonnull fullView) {
        [weakSelf.fullStyle dismiss];
    };

    // 点击Item
    fullView.didClickItems = ^(FullView *fullView, NSInteger index) {
        [fullView endAnimationsWithCompletion:^(FullView *fullView) {
            [weakSelf.fullStyle dismiss];
            
            MBProgressHUDViewController *vc = [MBProgressHUDViewController new];
            vc.title = fullView.items[index].titleLabel.text;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    };
    
    return fullView;
}

#pragma mark - Shared style

// 创建分享视图
- (zhPopupController *)shareStyle
{
    if (!_shareStyle)
    {
        WallView *wallView = [self createShareView];
        _shareStyle = [[zhPopupController alloc] initWithView:wallView size:wallView.bounds.size];
        _shareStyle.layoutType = zhPopupLayoutTypeBottom;
        _shareStyle.presentationStyle = zhPopupSlideStyleFromBottom;
    }
    return _shareStyle;
}

// 点击弹出分享视图
- (void)test7
{
    [self.shareStyle showInView:self.view.window duration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut bounced:NO completion:nil];
}

// 实现分享视图底部按钮的点击事件
- (WallView *)createShareView
{
    WallView *wallView = [self wallView];
    wallView.delegate = self;
    
    __weak typeof(self) weakself = self;
    wallView.didClickFooter = ^(WallView * sheetView) {
        [weakself.shareStyle dismiss];
    };
    
    return wallView;
}

// WallViewDelegateConfig（配置外观）
- (WallViewLayout *)layoutOfItemInWallView:(WallView *)wallView
{
    WallViewLayout *layout = [WallViewLayout new];
    layout.itemSubviewsSpacing = 9;
    return layout;
}

- (WallViewAppearance *)appearanceOfItemInWallView:(WallView *)wallView
{
    WallViewAppearance *appearance = [WallViewAppearance new];
    appearance.textLabelFont = [UIFont systemFontOfSize:10];
    return appearance;
}

// WallViewDelegate（点击分享按钮）
- (void)wallView:(WallView *)wallView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallItemModel *model = [self wallModels][indexPath.section][indexPath.row];
    [self.shareStyle dismissWithDuration:0.25 completion:^{
        [self showAlert:model.text];
    }];
}

#pragma mark - Center Keyboard Style

// 创建登陆视图
- (zhPopupController *)centerKeyboardStyle
{
    if (!_centerKeyboardStyle)
    {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 236)];
        [backView addSubview:self.centerKeyboardView];

        _centerKeyboardStyle = [[zhPopupController alloc] initWithView:backView size:backView.bounds.size];
        _centerKeyboardStyle.maskType = zhPopupMaskTypeBlackOpacity;
        _centerKeyboardStyle.layoutType = zhPopupLayoutTypeCenter;
        _centerKeyboardStyle.presentationStyle = zhPopupSlideStyleFromBottom;
        _centerKeyboardStyle.keyboardOffsetSpacing = 50;// 调整键盘间距
        _centerKeyboardStyle.keyboardChangeFollowed = YES;// YES将在键盘更改时调整视图位置
        _centerKeyboardStyle.becomeFirstResponded = YES;
        
        __weak typeof(self) weakSelf = self;
        _centerKeyboardStyle.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            [weakSelf.centerKeyboardView.phoneNumberField becomeFirstResponder];
        };
        
        _centerKeyboardStyle.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
            if (weakSelf.centerKeyboardView.phoneNumberField.isFirstResponder)
            {
                [weakSelf.centerKeyboardView.phoneNumberField resignFirstResponder];
            }
            
            if (weakSelf.registerKeyboardView.phoneNumberField.isFirstResponder)
            {
                [weakSelf.registerKeyboardView.phoneNumberField resignFirstResponder];
            }
        };
    }
    return _centerKeyboardStyle;
}

// 点击呈现登陆视图
- (void)test8
{
    [self.centerKeyboardStyle showInView:self.view.window duration:0.25 completion:NULL];
}

// 创建登录键盘
- (CenterKeyboardView *)centerKeyboardView
{
    if (!_centerKeyboardView)
    {
        _centerKeyboardView = [[CenterKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 300, 236)];
        
        __weak typeof(self) weakSelf = self;
        // 点击登陆按钮
        _centerKeyboardView.loginClickedBlock = ^(CenterKeyboardView *keyboardView) {
            [weakSelf.centerKeyboardStyle dismiss];
        };
        
        // 点击注册按钮
        _centerKeyboardView.registerClickedBlock = ^(CenterKeyboardView *keyboardView, UIButton *button) {
            // 进入注册界面
            [UIView transitionWithView:weakSelf.centerKeyboardStyle.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{

                [weakSelf.centerKeyboardStyle.view addSubview:weakSelf.registerKeyboardView];
                [weakSelf.registerKeyboardView.phoneNumberField becomeFirstResponder];

            } completion:^(BOOL finished) {
                
                // 移除登陆界面
                if ([weakSelf.centerKeyboardStyle.view.subviews containsObject:keyboardView]) {
                    [keyboardView removeFromSuperview];
                }
            }];
        };
    }
    return _centerKeyboardView;
}

// 创建注册键盘
- (RegisterKeyboardView *)registerKeyboardView
{
    if (!_registerKeyboardView)
    {
        _registerKeyboardView = [[RegisterKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 300, 236)];
        
        __weak typeof(self) weakSelf = self;
        // 点击返回按钮
        _registerKeyboardView.gobackClickedBlock = ^(RegisterKeyboardView *keyboardView, UIButton *button) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            // 进入登陆界面
            [UIView transitionWithView:strongSelf.centerKeyboardStyle.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{

                [strongSelf.centerKeyboardStyle.view addSubview:strongSelf.centerKeyboardView];
                [strongSelf.centerKeyboardView.phoneNumberField becomeFirstResponder];

            } completion:^(BOOL finished) {
                // 移除注册界面
                if ([strongSelf.centerKeyboardStyle.view.subviews containsObject:keyboardView]) {
                    [keyboardView removeFromSuperview];
                }
            }];
        };
        
        _registerKeyboardView.nextClickedBlock = ^(RegisterKeyboardView *keyboardView, UIButton *button) {
            [weakSelf.centerKeyboardView.phoneNumberField resignFirstResponder];
            [weakSelf.registerKeyboardView.phoneNumberField resignFirstResponder];
            
            NSLog(@"注册成功");
        };
    }
    return _registerKeyboardView;
}

// 创建评论视图
- (zhPopupController *)commentKeyboardStyle
{
    if (!_commentKeyboardStyle)
    {
        CGRect rect = CGRectMake(0, 0, self.view.width, 60);
        CommentKeyboardView *commentKeyboardView = [[CommentKeyboardView alloc] initWithFrame:rect];
        
        __weak typeof(self) weakSelf = self;
        commentKeyboardView.senderClickedBlock = ^(CommentKeyboardView *keyboardView, UIButton *button) {
            [weakSelf.commentKeyboardStyle dismiss];
        };
        
        _commentKeyboardStyle = [[zhPopupController alloc] initWithView:commentKeyboardView size:commentKeyboardView.bounds.size];
        _commentKeyboardStyle.maskType = zhPopupMaskTypeDarkBlur;
        _commentKeyboardStyle.layoutType = zhPopupLayoutTypeBottom;
        _commentKeyboardStyle.presentationStyle = zhPopupSlideStyleFromBottom;
        _commentKeyboardStyle.becomeFirstResponded = YES;
        _commentKeyboardStyle.keyboardChangeFollowed = YES;
        
        _commentKeyboardStyle.willPresentBlock = ^(zhPopupController * _Nonnull popupController) {
            [commentKeyboardView.commentTextField becomeFirstResponder];
        };
        
        _commentKeyboardStyle.willDismissBlock = ^(zhPopupController * _Nonnull popupController) {
            [commentKeyboardView.commentTextField resignFirstResponder];
        };
    }
    return _commentKeyboardStyle;
}

- (void)test9
{
    [self.commentKeyboardStyle showInView:self.view.window completion:NULL];
}

@end
