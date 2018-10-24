//
//  YKScrollBtnView.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKScrollBtnView.h"

@interface YKScrollBtnView()
@property (nonatomic,assign)BOOL isSelected;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hhh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *www;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation YKScrollBtnView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    [self addGestureRecognizer:tap];
    
    _hhh.constant = kSuitLength_H(70);
    _www.constant = kSuitLength_H(70);
    _title.layer.masksToBounds = YES;
    _title.layer.cornerRadius = 4;
    _title.textColor = mainColor;
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = kSuitLength_H(70/2);
    _name.font = [UIFont systemFontOfSize:kSuitLength_H(12)];
//    self.backgroundColor = [UIColor yellowColor];
//    self.image.backgroundColor = [UIColor greenColor];
//    self.title.backgroundColor =[UIColor blueColor];
}
- (void)toDetail{
    _isSelected  = !_isSelected;
    if (_isSelected) {
        _title.textColor = YKRedColor;
    }else {
        _title.textColor = mainColor;
        self.styleId = @"0";
    }
    if (self.clickDetailBlock) {
        self.clickDetailBlock(self.styleId,nil);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
