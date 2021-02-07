//
//  DBCell.h
//  UseFMDB
//
//  Created by 谢佳培 on 2021/2/7.
//

#import <UIKit/UIKit.h>
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBCell : UITableViewCell

@property (nonatomic, strong)UILabel *pkid;
@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong)UILabel *phoneNum;
@property (nonatomic, strong)UILabel *photoData;
@property (nonatomic, strong)UILabel *luckyNum;
@property (nonatomic, strong)UILabel *sex;
@property (nonatomic, strong)UILabel *age;
@property (nonatomic, strong)UILabel *height;
@property (nonatomic, strong)UILabel *weight;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier columnArr:(NSArray *)array;
- (void)setData:(Person *)model;

@end

NS_ASSUME_NONNULL_END
