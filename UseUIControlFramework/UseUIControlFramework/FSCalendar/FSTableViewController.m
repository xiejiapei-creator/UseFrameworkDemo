//
//  FSTableViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "FSTableViewController.h"
#import "LoadViewViewController.h"
#import "FullScreenViewController.h"
#import "DelegateAppearanceViewController.h"
#import "HidePlaceholderViewController.h"
#import "ButtonsViewController.h"
#import "DIYViewController.h"
#import "RangePickerViewController.h"

@interface FSTableViewController ()

@property (strong, nonatomic) NSArray *viewControllers;

@end

@implementation FSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.viewControllers = @[
                             [RangePickerViewController class],
                             [DIYViewController class],
                             [ButtonsViewController class],
                             [HidePlaceholderViewController class],
                             [DelegateAppearanceViewController class],
                             [FullScreenViewController class],
                             [NSObject class],
                             [NSObject class],
                             [LoadViewViewController class]
                            ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CalendarCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = NSStringFromClass(self.viewControllers[indexPath.row]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id viewControllerClass = self.viewControllers[indexPath.row];
    if ([viewControllerClass isSubclassOfClass:[UIViewController class]])
    {
        [self.navigationController pushViewController:[[viewControllerClass alloc] init] animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView.indexPathForSelectedRow)
    {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    }
}

@end
