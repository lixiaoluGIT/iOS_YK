//
//  YKShareCell.m
//  YK
//
//  Created by edz on 2018/8/8.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKShareCell.h"
@interface YKShareCell()
@property (weak, nonatomic) IBOutlet UIImageView *wx;
@property (weak, nonatomic) IBOutlet UIImageView *zone;
@property (weak, nonatomic) IBOutlet UIView *back;

@end

@implementation YKShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _back.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    _back.layer.borderWidth = 1;
    [_wx setUserInteractionEnabled:YES];
    [_zone setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share1)];
    [_wx addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share2)];
    [_wx addGestureRecognizer:tap1];
    [_zone addGestureRecognizer:tap2];
}

- (void)share1{
    if (self.shareBlock1) {
        self.shareBlock1();
    }
}
- (void)share2{
    if (self.shareBlock2) {
        self.shareBlock2();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
