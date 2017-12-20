//
//  YKSelectPayView.m
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSelectPayView.h"

@interface YKSelectPayView()

@property (nonatomic,strong)UIButton *Button0;
@property (nonatomic,assign) payMethod payMethod;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@end
@implementation YKSelectPayView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    _payMethod = 3;//给个非0
}
- (IBAction)selectPayMethod:(id)sender {
    UIButton * button = (UIButton *)sender;
    
    switch (button.tag) {
        case 101:
            _payMethod = AlIPAY;
            break;
        case 102:
            _payMethod = WXPAY;
            break;
       
        default:
            break;
    }
   
    if (self.Button0 != button) {
        self.Button0.selected = NO;
        button.selected = YES;
    }
    self.Button0 = button;
}
- (IBAction)cancle:(id)sender {//取消
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}
- (IBAction)ensure:(id)sender {
    if (_payMethod!=AlIPAY && _payMethod!=WXPAY) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请选择支付方式"  delay:1.2];
        return;
    }

    if (_selectPayBlock) {
        _selectPayBlock(_payMethod);
    }
}

- (IBAction)bigBtn:(id)sender {
    
    UIButton * button = (UIButton *)sender;
    
    switch (button.tag) {
        case 201:
            self.Button0 = _aliBtn;
            _aliBtn.selected = YES;
            _wxBtn.selected = NO;
            _payMethod = AlIPAY;
            break;
        case 202:
            self.Button0 = _wxBtn;
            _wxBtn.selected = YES;
            _aliBtn.selected = NO;
            _payMethod = WXPAY;
            break;
            
        default:
            break;
    }

}

@end
