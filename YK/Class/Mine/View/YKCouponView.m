//
//  YKCouponView.m
//  YK
//
//  Created by EDZ on 2018/3/27.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCouponView.h"

@interface YKCouponView()
@property (weak, nonatomic) IBOutlet UILabel *num;

@end
@implementation YKCouponView

- (void)resetNum:(NSInteger)num{
    _num.text = [NSString stringWithFormat:@"%ld",num];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Use)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    // Initialization code
}

- (void)Use{
    if (self.toUse) {
        self.toUse();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
