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
    self.scanBtn.layer.masksToBounds = YES;
//    self.scanBtn.layer.cornerRadius = self.scanBtn.frame.size.height/2;
    self.scanBtn.backgroundColor = mainColor;
//    self.scanBtn.layer.borderWidth = 1;
//    self.scanBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
}


- (IBAction)scanBtnClick:(id)sender {
    if (self.scanBlock) {
        self.scanBlock(1);
    }
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
