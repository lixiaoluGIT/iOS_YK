//
//  YKTotalSMSCell.m
//  YK
//
//  Created by LXL on 2017/12/18.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKTotalSMSCell.h"

@interface YKTotalSMSCell()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation YKTotalSMSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
