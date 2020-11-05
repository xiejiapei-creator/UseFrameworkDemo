//
//  MailViewController.m
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import "MailViewController.h"
#import "MailTableCell.h"
#import <MGSwipeTableCell.h>

@implementation MailData

@end

@interface MailViewController ()<MGSwipeTableCellDelegate>

@property (nonatomic, strong) NSMutableArray *demoData;

@end

@implementation MailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"MSwipeTableCell MailApp";
    [self prepareDemoData];
    
    [self.refreshControl addTarget:self action:@selector(refreshCallback) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MailCell";
    MailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[MailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    
    MailData *data = [self.demoData objectAtIndex:indexPath.row];
    cell.mailFrom.text = data.from;
    cell.mailSubject.text = data.subject;
    cell.mailMessage.text = data.message;
    cell.mailTime.text = data.date;
    [self updateCellIndicactor:data cell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark - MGSwipeTableCellDelegate
 
// 配置按钮
- (NSArray *)swipeTableCell:(MGSwipeTableCell*)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings*)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    
    __weak MailViewController *weakSelf = self;
    MailData *mail = [weakSelf mailForIndexPath:[self.tableView indexPathForCell:cell]];
    
    if (direction == MGSwipeDirectionLeftToRight)// 从左向右滑
    {
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 2;
        
        return @[[MGSwipeButton buttonWithTitle:[weakSelf readButtonText:mail.read] backgroundColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] padding:5 callback:^BOOL(MGSwipeTableCell *sender) {
            
            MailData *mail = [weakSelf mailForIndexPath:[weakSelf.tableView indexPathForCell:sender]];
            mail.read = !mail.read;
            
            // 刷新单元格内容时需要刷新
            [weakSelf updateCellIndicactor:mail cell:(MailTableCell*)sender];
            [cell refreshContentView];
            [(UIButton *)[cell.leftButtons objectAtIndex:0] setTitle:[weakSelf readButtonText:mail.read] forState:UIControlStateNormal];
            
            return YES;
        }]];
    }
    else// 从右向左滑
    {
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 1.1;
        CGFloat padding = 15;
        
        MGSwipeButton *trash = [MGSwipeButton buttonWithTitle:@"Trash" backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:sender];
            [weakSelf deleteMail:indexPath];
            
            // 不自动隐藏以改进删除动画
            return NO;
        }];
        
        MGSwipeButton *flag = [MGSwipeButton buttonWithTitle:@"Flag" backgroundColor:[UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            MailData *mail = [weakSelf mailForIndexPath:[weakSelf.tableView indexPathForCell:sender]];
            mail.flag = !mail.flag;
            
            // 刷新单元格内容时需要刷新
            [weakSelf updateCellIndicactor:mail cell:(MailTableCell*)sender];
            [cell refreshContentView];
            
            return YES;
        }];
        
        MGSwipeButton *more = [MGSwipeButton buttonWithTitle:@"More" backgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            return NO;
        }];
        
        return @[trash, flag, more];
    }
    
    return nil;
    
}

- (void)swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString *string;
    switch (state)
    {
        case MGSwipeStateNone: string = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: string = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: string = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: string = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: string = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", string, gestureIsActive ? @"Active" : @"Ended");
}


#pragma mark - Events

- (NSString *)readButtonText:(BOOL) read
{
    return read ? @"Mark as\nunread" :@"Mark as\nread";
}

- (MailData *)mailForIndexPath:(NSIndexPath*) path
{
    return [self.demoData objectAtIndex:path.row];
}

- (void)deleteMail:(NSIndexPath *)indexPath
{
    [self.demoData removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)refreshCallback
{
    [self prepareDemoData];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

// 更新指示器的颜色
- (void)updateCellIndicactor:(MailData *)mail cell:(MailTableCell *)cell
{
    UIColor *color;
    UIColor *innerColor;
    
    if (!mail.read && mail.flag)
    {
        color = [UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0];
        innerColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    }
    else if (mail.flag)
    {
        color = [UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0];
    }
    else if (mail.read)
    {
        color = [UIColor clearColor];
    }
    else
    {
        color = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    }
    
    cell.indicatorView.indicatorColor = color;
    cell.indicatorView.innerColor = innerColor;
}


#pragma mark - 数据源

- (void) prepareDemoData
{
    self.demoData = [NSMutableArray array];
    
    NSArray *from = @[
                       @"Vincent",
                       @"Mr Glass",
                       @"Marsellus",
                       @"Ringo",
                       @"Sullivan",
                       @"Mr Wolf",
                       @"Butch Coolidge",
                       @"Marvin",
                       @"Captain Koons",
                       @"Jules",
                       @"Jimmie Dimmick"
                       ];
    
    NSArray *subjects = @[
                           @"You think water moves fast?",
                           @"They called me Mr Glass",
                           @"The path of the righteous man",
                           @"Do you see any Teletubbies in here?",
                           @"Now that we know who you are",
                           @"My money's in that office, right?",
                           @"Now we took an oath",
                           @"That show's called a pilot",
                           @"I know who I am. I'm not a mistake",
                           @"It all makes sense!",
                           @"The selfish and the tyranny of evil men",
                           ];
    
    NSArray *messages = @[
                           @"You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out.",
                           @"And I will strike down upon thee with great vengeance and furious anger those who would attempt to poison and destroy My brothers.",
                           @"Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house",
                           @"No? Well, that's what you see at a toy store. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.",
                           @"In a comic, you know how you can tell who the arch-villain's going to be? He's the exact opposite of the hero",
                           @"If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there.",
                           @"that I'm breaking now. We said we'd say it was the snow that killed the other two, but it wasn't. Nature is lethal but it doesn't hold a candle to man.",
                           @"Then they show that show to the people who make shows, and on the strength of that one show they decide if they're going to make more shows.",
                           @"And most times they're friends, like you and me! I should've known way back when...",
                           @"After the avalanche, it took us a week to climb out. Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide",
                           @"Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother's keeper and the finder of lost children",
                           ];
    
    
    for (int i = 0; i < messages.count; ++i)
    {
        MailData *mail = [[MailData alloc] init];
        mail.from = [from objectAtIndex:i];
        mail.subject = [subjects objectAtIndex:i];
        mail.message = [messages objectAtIndex:i];
        mail.date = [NSString stringWithFormat:@"11:%d", 43 - i];
        [self.demoData addObject:mail];
    }
}

@end

