//
//  YKCouponView.h
//  YK
//
//  Created by EDZ on 2018/3/27.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCouponView : UITableViewCell

@property (nonatomic,copy)void (^toUse)(void);
- (void)resetNum:(NSInteger)num;
@end
