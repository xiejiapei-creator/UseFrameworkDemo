//
//  ProductionView.h
//  UseFMDB
//
//  Created by 谢佳培 on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

typedef void(^BLOCK)(void);

@interface ProductionView : UIView

- (void)reloadData;

- (void)insertMethod1:(BLOCK)block;
- (void)insertMethod2:(BLOCK)block;
- (void)insertMethod3:(BLOCK)block;
- (void)insertMethod4:(BLOCK)block;

- (void)deleteMethod1:(BLOCK)block;
- (void)deleteMethod2:(BLOCK)block;
- (void)deleteMethod3:(BLOCK)block;
- (void)deleteMethod4:(BLOCK)block;

- (void)updateMethod1:(BLOCK)block;
- (void)updateMethod2:(BLOCK)block;
- (void)updateMethod3:(BLOCK)block;
- (void)updateMethod4:(BLOCK)block;

- (void)lookupMethod1:(BLOCK)block;
- (void)lookupMethod2:(BLOCK)block;
- (void)lookupMethod3:(BLOCK)block;
- (void)lookupMethod4:(BLOCK)block;

- (void)transactionMethod1:(BLOCK)block;

@end

NS_ASSUME_NONNULL_END
