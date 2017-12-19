//
//  YKSuitHeader.m
//  YK
//
//  Created by LXL on 2017/12/13.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuitHeader.h"

@interface YKSuitHeader()
@property (weak, nonatomic) IBOutlet UILabel *ensureReceive;
@property (weak, nonatomic) IBOutlet UILabel *scanSMS;
@property (weak, nonatomic) IBOutlet UILabel *orderBack;

@end
@implementation YKSuitHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.scanSMS setUserInteractionEnabled:YES];
    [self.ensureReceive setUserInteractionEnabled:YES];
    [self.orderBack setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sms)];
    [self.scanSMS addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ensure)];
    [self.ensureReceive addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(order)];
    [self.orderBack addGestureRecognizer:tap3];
}

- (void)sms{
    if (_SMSBlock) {
        _SMSBlock();
    }
}

- (void)ensure{
    if (_ensureReceiveBlock) {
        _ensureReceiveBlock();
    }
}

- (void)order{
    if (_orderBackBlock) {
        _orderBackBlock();
    }
}

@end
