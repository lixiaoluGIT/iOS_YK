//
//  YKChongZhiBtn.m
//  YK
//
//  Created by LXL on 2017/11/29.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKChongZhiBtn.h"
@interface YKChongZhiBtn()
@property (weak, nonatomic) IBOutlet UILabel *chong;

@end

@implementation YKChongZhiBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chongz)];
    _chong.userInteractionEnabled = YES;
    [_chong addGestureRecognizer:tap];
}

- (void)chongz{
    [self removeFromSuperview];
    if (self.chongzhi) {
        self.chongzhi();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
