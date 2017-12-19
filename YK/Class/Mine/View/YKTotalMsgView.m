//
//  YKTotalMsgView.m
//  YK
//
//  Created by LXL on 2017/12/18.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKTotalMsgView.h"

@interface YKTotalMsgView()
@property (weak, nonatomic) IBOutlet UIView *MsgView;

@property (weak, nonatomic) IBOutlet UIView *SMSView;

@end
@implementation YKTotalMsgView

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [self.MsgView setUserInteractionEnabled:YES];
    [self.SMSView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMsg)];
     UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToSMS)];
    [self.MsgView addGestureRecognizer:tap1];
    [self.SMSView addGestureRecognizer:tap2];
}

- (void)ToSMS{
    if (_ToSMSBlock) {
        _ToSMSBlock();
    }
}

- (void)toMsg{
    
}
@end
