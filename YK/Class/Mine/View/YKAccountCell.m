//
//  YKAccountCell.m
//  YK
//
//  Created by edz on 2018/7/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKAccountCell.h"
@interface YKAccountCell()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *txBtn;

@end

@implementation YKAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAccount:(NSDictionary *)account{
    _account = account;
    _accountLabel.text = [NSString stringWithFormat:@"¥%@",account[@"capital"]];
    if ([account[@"capital"] intValue] == 0) {
        _txBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [_txBtn setUserInteractionEnabled:NO];
    }else {
        _txBtn.backgroundColor = mainColor;
        [_txBtn setUserInteractionEnabled:YES];
    }
}
- (IBAction)tixian:(id)sender {
    
    if ([_account[@"capital"] intValue] <50) {//余额不足
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"满50才可提现哦" delay:1.5];
        return;
    }
    if (self.tixianClick) {
        self.tixianClick();
    }
}

@end
