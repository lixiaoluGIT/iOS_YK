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
    _accountLabel.text = [NSString stringWithFormat:@"¥%@",account[@"account"]];
    if ([account[@"account"] intValue] == 0) {
        _txBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
        [_txBtn setUserInteractionEnabled:NO];
    }else {
        _txBtn.backgroundColor = mainColor;
        [_txBtn setUserInteractionEnabled:YES];
    }
}
- (IBAction)tixian:(id)sender {
    [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"客官莫急"  delay:1.5];
}

@end
