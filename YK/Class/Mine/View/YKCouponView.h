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
@property (nonatomic,assign)NSInteger couponType;//1加时卡 2优惠劵
@property (nonatomic,assign)NSInteger couponStatus;//1未使用 2已使用 3已过期
@property (nonatomic,assign)NSInteger couponNum;//价钱
@property (nonatomic,assign)int couponID;//id
- (void)resetNum:(NSInteger)num;
- (void)initWithDic:(NSDictionary *)dic;
- (void)hid;

- (void)appear;
@end
