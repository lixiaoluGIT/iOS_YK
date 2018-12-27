//
//  YKCouponListVC.h
//  YK
//
//  Created by edz on 2018/7/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBaseTableVC.h"

@interface YKCouponListVC : YKBaseVC
@property (nonatomic,copy)void (^selectCoupon)(NSInteger CouponNum,int CouponId);
@property (nonatomic,assign)BOOL isFromPay;
@property (nonatomic,assign)BOOL isFromSuit;



@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign) NSInteger couponStatus;
@end
