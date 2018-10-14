//
//  YKAddCell.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKAddCell.h"

@interface YKAddCell()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image;

@end
@implementation YKAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _btn.layer.masksToBounds = YES;
    _btn.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    _btn.layer.borderWidth = 1;
    [_btn setUserInteractionEnabled:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
