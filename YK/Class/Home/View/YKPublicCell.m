//
//  YKPublicCell.m
//  YK
//
//  Created by LXL on 2018/3/16.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKPublicCell.h"

@implementation YKPublicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(public)];
    [self addGestureRecognizer:tap];
    // Initialization code
}

- (void)public{
    if (self.PublicBlock) {
        self.PublicBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
