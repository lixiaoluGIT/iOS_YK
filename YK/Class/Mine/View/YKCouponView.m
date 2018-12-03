//
//  YKCouponView.m
//  YK
//
//  Created by EDZ on 2018/3/27.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCouponView.h"

@interface YKCouponView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *train;

@property (weak, nonatomic) IBOutlet UIImageView *backImahe;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *texy;

@property (weak, nonatomic) IBOutlet UILabel *yuan;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectiveDay;

@property (weak, nonatomic) IBOutlet UILabel *kajuan;
@property (weak, nonatomic) IBOutlet UIImageView *kajuanImage;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;

@end
@implementation YKCouponView

- (void)hid{
    [_image removeFromSuperview];
    [_texy removeFromSuperview];
}

- (void)appear{
    _image.hidden = NO;
    _texy.hidden = NO;
}
- (void)resetNum:(NSInteger)num{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (WIDHT==414) {
        _gap.constant = 80;
    }
    if (WIDHT==375) {
        _train.constant = -165;
    }
    
    _useLabel.layer.masksToBounds = YES;
    _useLabel.layer.cornerRadius = 21/2;
    
    _numLabel.font = PingFangSC_Medium(kSuitLength_H(40));
    _yuan.font = PingFangSC_Regular(kSuitLength_H(12));
    _type.font = PingFangSC_Medium(kSuitLength_H(24));
    _effectiveDay.font = PingFangSC_Regular(kSuitLength_H(12));
    _useLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)initWithDic:(NSDictionary *)dic{
    if ([dic[@"couponType"] intValue] == 1) {//加时卡
        _couponType = 1;
        _yuan.text = @"天";
        _type.text = @"加时卡";
        _couponNum = [dic[@"couponDays"] integerValue];
        _numLabel.text = [NSString stringWithFormat:@"%@",dic[@"couponDays"]];
    }
    if ([dic[@"couponType"] intValue] == 2) {//优惠劵
        _couponType = 2;
        _type.text = @"代金券";
         _yuan.text = @"元";
        _couponNum = [dic[@"couponAmount"] integerValue];
        _numLabel.text = [NSString stringWithFormat:@"%@",dic[@"couponAmount"]];
    }
    
//    if ([dic[@"status"] isEqual:@"加衣劵"]) {//加衣券劵
//        _couponType = 5;
//        _type.text = @"加衣券";
//        _yuan.text = @"件";
//        _couponNum = [dic[@"couponAmount"] integerValue];
//        _numLabel.text = [NSString stringWithFormat:@"%@",dic[@"couponAmount"]];
//    }

    _couponID = [dic[@"couponId"] intValue];

    _effectiveDay.text = [NSString stringWithFormat:@"%@前有效",[self timeWithTimeIntervalString:dic[@"expiryTime"]]];

    
    if ([dic[@"status"] isEqual:@"加衣劵"]) {//加衣券劵
        _couponType = 5;
        _type.text = @"加衣券";
        _yuan.text = @"件";
        _couponNum = [dic[@"couponAmount"] integerValue];
        _numLabel.text = [NSString stringWithFormat:@"%@",dic[@"couponAmount"]];
        _couponID = [dic[@"addClothingId"] intValue];
        
        _effectiveDay.text = @"无使用时间限制";
    }
    if ([dic[@"couponStatus"] intValue]==1) {//未使用
        _effectiveDay.text = [NSString stringWithFormat:@"%@前有效",[self timeWithTimeIntervalString:dic[@"expiryTime"]]];
        _backImahe.image = [UIImage imageNamed:@"加衣劵可使用状态"];
        _couponStatus = 1;
    }
    if ([dic[@"couponStatus"] intValue]==2) {//已使用
        _effectiveDay.text = @"已使用";
        _effectiveDay.textColor = YKRedColor;
        _backImahe.image = [UIImage imageNamed:@"加衣劵不可使用状态"];
         _couponStatus = 2;
    }
    if ([dic[@"couponStatus"] intValue]==3) {//已过期
        _effectiveDay.text = @"已过期";
         _effectiveDay.textColor = YKRedColor;
        _backImahe.image = [UIImage imageNamed:@"加衣劵不可使用状态"];
         _couponStatus = 3;
    }
}

- (void)initWithD:(NSDictionary *)dic{
    
    _leading.constant = kSuitLength_H(20);
        _couponType = 5;
        _type.text = @"加衣券";
        _yuan.text = @"件";
        _couponNum = [dic[@"addNumber"] integerValue];
        _numLabel.text = [NSString stringWithFormat:@"%@",dic[@"addNumber"]];
        _couponID = [dic[@"addClothingId"] intValue];
        
        _effectiveDay.text = @"长期有效";
    
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
