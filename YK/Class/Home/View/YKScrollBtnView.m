//
//  YKScrollBtnView.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKScrollBtnView.h"

@implementation YKScrollBtnView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    [self addGestureRecognizer:tap];
    // Initialization code
}
- (void)toDetail{
    if (self.clickDetailBlock) {
        self.clickDetailBlock(self.brandId,nil);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
