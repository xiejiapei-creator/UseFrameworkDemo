//
//  EmptyMainViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "EmptyMainViewController.h"
#import "EmptyDetailViewController.h"

@interface EmptyMainViewController ()

@property (nonatomic, strong) NSArray *applications;

@end

@implementation EmptyMainViewController

- (void)viewDidLoad
{
    self.title = @"Applications";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"applications" ofType:@"json"];
    self.applications = [ApplicationModel applicationsFromJSONAtPath:path];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.applications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"app_cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    ApplicationModel *app = [self.applications objectAtIndex:indexPath.row];
    cell.textLabel.text = app.displayName;
    cell.detailTextLabel.text = app.developerName;
    
    UIImage *image = [UIImage imageNamed:app.iconName];
    cell.imageView.image = image;
    cell.imageView.layer.cornerRadius = image.size.width*0.2;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
    cell.imageView.layer.borderWidth = 0.5;
    cell.imageView.layer.shouldRasterize = YES;
    cell.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationModel *app = [self.applications objectAtIndex:indexPath.row];
    EmptyDetailViewController *controller = [[EmptyDetailViewController alloc] initWithApplication:app];
    controller.applications = self.applications;
    controller.allowShuffling = YES;
    
    if ([controller preferredStatusBarStyle] == UIStatusBarStyleLightContent)
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
