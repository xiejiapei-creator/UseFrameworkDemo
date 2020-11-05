//
//  MailTableCell.h
//  框架Demo
//
//  Created by 谢佳培 on 2020/11/4.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@interface MailIndicatorView : UIView

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *innerColor;

@end

@interface MailTableCell : MGSwipeTableCell

@property (nonatomic, strong) UILabel *mailFrom;
@property (nonatomic, strong) UILabel *mailSubject;
@property (nonatomic, strong) UITextView *mailMessage;
@property (nonatomic, strong) UILabel *mailTime;
@property (nonatomic, strong) MailIndicatorView *indicatorView;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
 
