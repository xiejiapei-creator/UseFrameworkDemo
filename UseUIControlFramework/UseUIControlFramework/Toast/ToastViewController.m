//
//  ToastViewController.m
//  UseUIControlFramework
//
//  Created by 谢佳培 on 2020/11/6.
//

#import "ToastViewController.h"
#import <Toast/Toast.h>

static NSString *ToastSwitchCell = @"ToastSwitchCell";
static NSString *ToastCell = @"ToastCell";

@interface ToastViewController ()

@property (assign, nonatomic, getter=isShowingActivity) BOOL showingActivity;
@property (strong, nonatomic) UISwitch *tapToDismissSwitch;
@property (strong, nonatomic) UISwitch *queueSwitch;

@end

@implementation ToastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Toast";
    self.showingActivity = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ToastCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 11;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"设置";
    }
    else
    {
        return @"演示";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ToastSwitchCell];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ToastSwitchCell];
            
            self.tapToDismissSwitch = [[UISwitch alloc] init];
            _tapToDismissSwitch.onTintColor = [UIColor colorWithRed:239.0 / 255.0 green:108.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
            [_tapToDismissSwitch addTarget:self action:@selector(handleTapToDismissToggled) forControlEvents:UIControlEventValueChanged];
            [_tapToDismissSwitch setOn:[CSToastManager isTapToDismissEnabled]];// !!!Dimiss Toast
            
            cell.accessoryView = _tapToDismissSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.textLabel.text = @"允许 Toast 消失";
        }
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ToastSwitchCell];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ToastSwitchCell];
            self.queueSwitch = [[UISwitch alloc] init];
            _queueSwitch.onTintColor = [UIColor colorWithRed:239.0 / 255.0 green:108.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
            [_queueSwitch addTarget:self action:@selector(handleQueueToggled) forControlEvents:UIControlEventValueChanged];
            [_queueSwitch setOn:[CSToastManager isQueueEnabled]];// !!!Queue Toast
            
            cell.accessoryView = _queueSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.textLabel.text = @"允许 Toast 退出";
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ToastCell forIndexPath:indexPath];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"最简单的Toast";
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"持续3秒的Toast";
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"所有Toast共享的风格";
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"自定义视图作为Toast";
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"显示加载中的指示器";
        }
        else if (indexPath.row == 5)
        {
            cell.textLabel.text = @"隐藏Toast";
        }
        
        return cell;
    }
}

#pragma mark - Events

- (void)handleTapToDismissToggled
{
    [CSToastManager setTapToDismissEnabled:![CSToastManager isTapToDismissEnabled]];
}

- (void)handleQueueToggled
{
    [CSToastManager setQueueEnabled:![CSToastManager isQueueEnabled]];
}

#pragma mark - Toast

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:// 最简单的Toast
            [self.navigationController.view makeToast:@"Toast"];
            break;
        case 1:// 持续指定时间的Toast
            [self.navigationController.view makeToast:@"持续3秒的Toast" duration:3.0 position:CSToastPositionTop];
            break;
        case 2:// 所有Toast共享的风格
        {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageFont = [UIFont fontWithName:@"Zapfino" size:14.0];
            style.messageColor = [UIColor redColor];
            style.messageAlignment = NSTextAlignmentCenter;
            style.backgroundColor = [UIColor yellowColor];
            style.titleColor = [UIColor blackColor];
            [CSToastManager setSharedStyle:style];
            
            [self.navigationController.view makeToast:@"This is a piece of toast with a title" duration:2.0 position:CSToastPositionTop title:@"文艺复兴运动" image:[UIImage imageNamed:@"luckcoffee.JPG"] style:style completion:^(BOOL didTap) {
                if (didTap)
                {
                    NSLog(@"completion from tap");
                }
                else
                {
                    NSLog(@"completion without tap");
                }
            }];
            break;
        }
        case 3:// 自定义视图作为Toast
        {
            UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 400)];
            [customView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
            customView.backgroundColor = [UIColor orangeColor];
            
            // 将CGPoint封装为NSValue对象
            [self.navigationController.view showToast:customView duration:2.0 position:[NSValue valueWithCGPoint:CGPointMake(110, 110)] completion:nil];
            
            break;
        }
        case 4:// 显示加载中的指示器
        {
            if (!self.isShowingActivity)
            {
                [self.navigationController.view makeToastActivity:CSToastPositionCenter];
            }
            else
            {
                [self.navigationController.view hideToastActivity];
            }
            _showingActivity = !self.isShowingActivity;
            [tableView reloadData];
            
            break;
        }
        case 5:// 隐藏Toast
        {
            [self.navigationController.view hideToast];
            [self.navigationController.view hideAllToasts];
        }
        default:
            break;
    }
}

@end


