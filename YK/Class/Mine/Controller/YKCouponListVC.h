//
//  YKCouponListVC.h
//  YK
//
//  Created by edz on 2018/7/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBaseTableVC.h"

@interface YKCouponListVC : YKBaseTableVC
@property (nonatomic,copy)void (^selectCoupon)(NSInteger CouponNum,int CouponId);
@end
