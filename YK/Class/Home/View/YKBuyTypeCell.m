//
//  YKBuyTypeCell.m
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBuyTypeCell.h"
@interface YKBuyTypeCell()
@property (nonatomic,strong)UIButton *Button0;
@property (nonatomic,assign) payMethod payMethod;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

@end
@implementation YKBuyTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _payMethod = 3;
    
}
- (IBAction)selectAli:(id)sender {
   
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
    
    if (self.selectPayBlock) {
        self.selectPayBlock(_payMethod);
    }
}



@end
