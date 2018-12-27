//
//  YKCartHeader.m
//  YK
//
//  Created by edz on 2018/11/9.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCartHeader.h"
@interface YKCartHeader()
@property (nonatomic,strong)UIButton *tempBtn;
@end
@implementation YKCartHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}

- (void)setUpUI{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(17));
        make.right.mas_equalTo(kSuitLength_H(-17));
        make.height.mas_equalTo(kSuitLength_H(26));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = kSuitLength_H(26)/2;
    //图标
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"衣位"]];
    [backView addSubview:image];
 
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(17));
        make.centerY.mas_equalTo(backView.mas_centerY);
        
    }];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"衣位不够？";
    lable.textColor = mainColor;
    lable.font = PingFangSC_Regular(kSuitLength_H(12));
    [backView addSubview:lable];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(image.mas_right).offset(kSuitLength_H(7));
        make.centerY.mas_equalTo(image.mas_centerY);
        make.width.mas_equalTo(kSuitLength_H(120));
        make.height.mas_equalTo(backView.mas_height);
    }];
    
    //使用或购买加衣券按钮
    _tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tempBtn setTitle:@"使用加衣券" forState:UIControlStateNormal];
    [_tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_tempBtn setBackgroundColor:YKRedColor];
    _tempBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    [_tempBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_tempBtn];
    
    [_tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(backView.mas_centerY);
        make.width.mas_equalTo(kSuitLength_H(83));
        make.height.mas_equalTo(backView.mas_height);
    }];
    _tempBtn.layer.masksToBounds = YES;
    _tempBtn.layer.cornerRadius = kSuitLength_H(26)/2;
}

- (void)setIsHadCC:(BOOL)isHadCC{
    _isHadCC = isHadCC;
    if (_isHadCC) {
        [_tempBtn setTitle:@"使用加衣券" forState:UIControlStateNormal];
    }else {
        [_tempBtn setTitle:@"购买加衣券" forState:UIControlStateNormal];
    }
}

- (void)buttonAction{
    if (self.btnAction) {
        self.btnAction(_isHadCC);
    }
}
@end
