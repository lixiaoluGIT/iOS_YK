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

    _couponID = [dic[@"couponId"] intValue];
//    _type.text = dic[@"couponName"];
    _effectiveDay.text = [NSString stringWithFormat:@"%@前有效",[self timeWithTimeIntervalString:dic[@"expiryTime"]]];

    if ([dic[@"couponStatus"] intValue]==1) {//未使用
        _effectiveDay.text = [NSString stringWithFormat:@"%@前有效",[self timeWithTimeIntervalString:dic[@"expiryTime"]]];
        _backImahe.image = [UIImage imageNamed:@"可使用"];
        _couponStatus = 1;
    }
    if ([dic[@"couponStatus"] intValue]==2) {//已使用
        _effectiveDay.text = @"已使用";
        _effectiveDay.textColor = YKRedColor;
        _backImahe.image = [UIImage imageNamed:@"不可使用"];
         _couponStatus = 2;
    }
    if ([dic[@"couponStatus"] intValue]==3) {//已过期
        _effectiveDay.text = @"已过期";
         _effectiveDay.textColor = YKRedColor;
        _backImahe.image = [UIImage imageNamed:@"不可使用"];
         _couponStatus = 3;
    }
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
