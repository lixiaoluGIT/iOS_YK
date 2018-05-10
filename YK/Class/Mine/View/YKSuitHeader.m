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
@property (weak, nonatomic) IBOutlet UILabel *statusLable;
@property (weak, nonatomic) IBOutlet UIImageView *wuliuImage;

@end

@implementation YKSuitHeader

- (void)resetUI:(NSInteger)status{
    _wuliuImage.hidden = YES;
    _statusLable.text = @"衣箱状态:待归还";
    if (status) {//已预约归还
        _scanSMS.text = @"预约成功，等待快递员上门取件";
        _orderBack.userInteractionEnabled = NO;
    }else {//没预约归还
        _scanSMS.text = @"预约归还";
        _orderBack.userInteractionEnabled = YES;
    }
}

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
    
    if ([YKOrderManager sharedManager].isOnRoad) {//已发货
        _ensureReceive.userInteractionEnabled = YES;
        _ensureReceive.text = @"确认收货";
    }else {
        _ensureReceive.userInteractionEnabled = NO;
        _ensureReceive.text = @"待发货";
    }
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
