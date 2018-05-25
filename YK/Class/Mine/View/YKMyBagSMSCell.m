//
//  YKMyBagSMSCell.m
//  YK
//
//  Created by LXL on 2017/11/21.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMyBagSMSCell.h"

@interface YKMyBagSMSCell()
@property (weak, nonatomic) IBOutlet UILabel *smsLabel;

@end
@implementation YKMyBagSMSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Scan)];
    [self addGestureRecognizer:tap];
    // Initialization code
}

- (void)Scan{
    if (self.scanSMSBlock) {
        self.scanSMSBlock();
    }
}

@end
