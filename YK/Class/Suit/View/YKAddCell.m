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
//    _btn.layer.masksToBounds = YES;
//    _btn.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
//    _btn.layer.borderWidth = 1;
//    [_btn setUserInteractionEnabled:NO];
    [self setUpUI];
}

- (void)setUpUI{
    //背景
//    UIView *backView = [[UIView alloc]init];
//    backView.backgroundColor = [UIColor whiteColor];
////    backView.layer.masksToBounds = YES;
////    backView.layer.cornerRadius = kSuitLength_H(6);
////    backView.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;
////    backView.layer.borderWidth = 1;
//    [self addSubview:backView];
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kSuitLength_H(17));
//        make.right.mas_equalTo(kSuitLength_H(-17));
//        make.top.mas_equalTo(kSuitLength_H(5));
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-kSuitLength_H(5));
//    }];
    
    UIImageView *im = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"添加单品加入衣袋"]];
//    im.frame = backView.frame;
    [self addSubview:im];
    
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(17));
        make.right.mas_equalTo(kSuitLength_H(-17));
        make.top.mas_equalTo(kSuitLength_H(5));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kSuitLength_H(5));
    }];
    
//    //加号图片
//    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"添加"]];
//    [backView addSubview:image];
//    [image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.top.mas_equalTo(kSuitLength_H(21));
//    }];
//
//    //文字
//    UILabel *lable = [[UILabel alloc]init];
//    lable.text = @"添加单品加入衣袋";
//    lable.textColor = [UIColor colorWithHexString:@"d1d1d1"];
//    lable.font = PingFangSC_Regular(kSuitLength_H(12));
//    [backView addSubview:lable];
//    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(image.mas_bottom).offset(kSuitLength_H(8));
//        make.centerX.mas_equalTo(backView.mas_centerX);
//    }];
}


@end
