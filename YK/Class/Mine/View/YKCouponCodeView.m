//
//  YKCouponCodeView.m
//  YK
//
//  Created by edz on 2018/8/1.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCouponCodeView.h"
@interface YKCouponCodeView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
@implementation YKCouponCodeView


-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [self.codeText resignFirstResponder];
    
    return YES;
    
}

- (IBAction)changeAction:(id)sender {
    if (_codeText.text.length==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请输入兑换码" delay:1.5];
    }else {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"兑换码输入有误" delay:1.5];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.codeText.delegate = self;
    
    self.codeText.returnKeyType = UIReturnKeyDone;
}

@end
