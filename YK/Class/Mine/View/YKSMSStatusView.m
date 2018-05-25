//
//  YKSMSStatusView.m
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSMSStatusView.h"

@interface YKSMSStatusView()
@property (weak, nonatomic) IBOutlet UILabel *smsStatus;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end
@implementation YKSMSStatusView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initWithOrderId:(NSString *)orderId orderStatus:(NSString *)orderStatus phone:(NSString *)phone{
    _smsStatus.text = orderStatus;
    if (orderId.length == 0) {
        _orderId.text = @"未查到顺风订单号";
    }else {
        _orderId.text = [NSString stringWithFormat:@"顺风查询编号:%@",orderId];
    }
    _phone.text = [NSString stringWithFormat:@"客服电话:%@",phone];
}
@end
