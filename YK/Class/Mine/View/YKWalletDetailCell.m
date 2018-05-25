//
//  YKWalletDetailCell.m
//  YK
//
//  Created by LXL on 2017/11/23.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKWalletDetailCell.h"
#import "NSString+FD.h"
@interface YKWalletDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *type;//交易类型
@property (weak, nonatomic) IBOutlet UILabel *price;//价钱
@property (weak, nonatomic) IBOutlet UILabel *time;//时间
@property (weak, nonatomic) IBOutlet UILabel *payType;//付款类型

@end
@implementation YKWalletDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code;
}

- (void)initWithDictionary:(NSDictionary *)dic{
    if ([dic[@"transactionType"] intValue] == 1) {
        _type.text = @"充值成功";
    }
    if ([dic[@"transactionType"] intValue] == 2) {
        _type.text = @"退款成功";
    }
    
    _price.text = [NSString stringWithFormat:@"¥%@",dic[@"transactionAmount"]];
    
    _time.text = [NSString stringWithFormat:@"%@",[self timeWithTimeIntervalString:dic[@"tradingTime"]]];
    
    
    if ([dic[@"paymentMethod"] intValue] == 1) {
        _payType.text = @"支付宝支付";
    }
    if ([dic[@"paymentMethod"] intValue] == 2) {
        _payType.text = @"微信支付";
    }
    
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
