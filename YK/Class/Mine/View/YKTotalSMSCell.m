//
//  YKTotalSMSCell.m
//  YK
//
//  Created by LXL on 2017/12/18.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKTotalSMSCell.h"

@interface YKTotalSMSCell()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *orderId;

@end

@implementation YKTotalSMSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 4;
}

- (void)initWithDictionary:(NSDictionary *)dic{
    [_image sd_setImageWithURL:[NSURL URLWithString:dic[@""]] placeholderImage:[UIImage imageNamed:@"首页商品图"]];
    _name.text = dic[@""];
    _orderId.text = dic[@""];
    _orderNo = dic[@""];
}
@end
