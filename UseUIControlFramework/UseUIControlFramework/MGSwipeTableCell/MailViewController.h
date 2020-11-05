//
//  MailViewController.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailData : NSObject

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, assign) BOOL flag;

@end

@interface MailViewController : UITableViewController

@end
 
