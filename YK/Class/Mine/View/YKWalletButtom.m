//
//  YKWalletButtom.m
//  YK
//
//  Created by LXL on 2017/11/23.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKWalletButtom.h"

@interface YKWalletButtom()

@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@end
@implementation YKWalletButtom

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.scanBtn.layer.masksToBounds = YES;
////    self.scanBtn.layer.cornerRadius = self.scanBtn.frame.size.height/2;
//    self.scanBtn.backgroundColor = mainColor;
////    self.scanBtn.layer.borderWidth = 1;
////    self.scanBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
//    self.scanBtn.frame = CGRectMake(WIDHT-kSuitLength_H(140), -kSuitLength_H(36), kSuitLength_H(120), kSuitLength_H(21));
//    self.scanBtn.backgroundColor = YKRedColor;
//    self.scanBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
//    self.scanBtn.layer.masksToBounds = YES;
//    self.scanBtn.layer.cornerRadius = kSuitLength_H(21)/2;
    
    self.des.font = PingFangSC_Regular(kSuitLength_H(12));
    
    self.scanBtn.hidden = YES;
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(WIDHT-kSuitLength_H(100), kSuitLength_H(18), kSuitLength_H(80), kSuitLength_H(21));
    b.centerY = self.des.centerY;
    b.backgroundColor = YKRedColor;
    b.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    b.layer.masksToBounds = YES;
    b.layer.cornerRadius = kSuitLength_H(21)/2;
    self.scanBtn = b;
    [b addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:b];
}

- (IBAction)scanBtnClick:(id)sender {
    if (self.scanBlock) {
        self.scanBlock(1);
    }
}

- (void)scan{
    if (self.scanBlock) {
        self.scanBlock(1);
    }
}

- (void)setTit{
    [_scanBtn setTitle:@"缴纳押金" forState:UIControlStateNormal];
}

- (void)setTitle:(NSInteger)status{
    switch (status) {
        case 0://押金未交
            _des.text = @"未交押金,缴纳押金享受会员权益";
            break;
            
        case 1://押金有效
            _des.text = @"已交押金,可享受平台各种会员服务";
            break;
        case 2://押金退还中
            _des.text = @"押金退还中";
            break;
        case 3://押金无效
             _des.text = @"未交押金,缴纳押金享受会员权益";
            break;
        default:
            break;
    }
}

@end
