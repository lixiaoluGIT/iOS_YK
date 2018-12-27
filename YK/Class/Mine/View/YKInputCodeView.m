//
//  YKInputCodeView.m
//  YK
//
//  Created by edz on 2018/11/27.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKInputCodeView.h"

@interface YKInputCodeView()
@property (nonatomic,strong)UIView *backView;//背景图层
@property (nonatomic,strong)UIView *containView;//手机号容器视图
@property (nonatomic,strong)UITextField *phoneText;
@end
@implementation YKInputCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];//输入手机号界面
//        [self setUpCodeView];
    }
    return self;
}

- (void)setUpUI{
    
    //背景图层
    _backView = [[UIView alloc]initWithFrame:CGRectZero];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.74;
    _backView.frame = kWindow.bounds;
    [_backView setUserInteractionEnabled:YES];
   [self addSubview:_backView];
    
    //
    _containView = [[UIView alloc]initWithFrame:CGRectZero];
    _containView.backgroundColor = [UIColor whiteColor];
    _containView.layer.masksToBounds = YES;
    _containView.layer.cornerRadius = 4;
    [self addSubview:_containView];
    
    _containView.frame = CGRectMake(kSuitLength_H(58), HEIGHT, WIDHT-kSuitLength_H(58)*2, kSuitLength_H(148));
    
   
    //
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"使用好友邀请码";
    lable.textColor = mainColor;
    lable.font = PingFangSC_Regular(kSuitLength_H(14));
    [_containView addSubview:lable];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containView.mas_centerX);
        make.top.mas_equalTo(kSuitLength_H(14));
    }];
    
    //输入框
    _phoneText = [[UITextField alloc]init];
    _phoneText.placeholder = @"输入邀请码";
    _phoneText.textColor = mainColor;
    _phoneText.font = PingFangSC_Regular(kSuitLength_H(12));
    _phoneText.keyboardType = UIKeyboardTypeDefault;
    [_containView addSubview:_phoneText];
    
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lable.mas_bottom).offset(kSuitLength_H(20));
        make.left.mas_equalTo(kSuitLength_H(50));
        make.right.mas_equalTo(kSuitLength_H(-50));
        make.height.mas_equalTo(kSuitLength_H(30));
    }];
    
    //线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [_containView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(50));
        make.right.mas_equalTo(kSuitLength_H(-50));
        make.height.equalTo(@0.5);
        make.top.mas_equalTo(_phoneText.mas_bottom).offset(kSuitLength_H(1));
    }];
    
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:YKRedColor forState:UIControlStateNormal];
    cancle.titleLabel.font = PingFangSC_Regular(14)
    [_containView addSubview:cancle];
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(56));
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(20));
    }];
    
    UIButton *en = [UIButton buttonWithType:UIButtonTypeCustom];
    [en setTitle:@"确定" forState:UIControlStateNormal];
    [en setTitleColor:YKRedColor forState:UIControlStateNormal];
    en.titleLabel.font = PingFangSC_Regular(14)
    [_containView addSubview:en];
    [en mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-56));
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(20));
    }];
    [cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [en addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
    [_containView layoutIfNeeded];
    //动画弹出
    [self showContain];
}

- (void)ensure{
    if (_phoneText.text.length == 0) {
        [smartHUD alertText:kWindow alert:@"邀请码不能为空" delay:1.2];
        return;
    }
    [self dismiss];
    if (self.loginSuccess) {
        self.loginSuccess(_phoneText.text);
    }
}
- (void)showContain{
    
        [UIView animateWithDuration:0.25 animations:^{
            _containView.top = kSuitLength_H(219);
          
        }completion:^(BOOL finished) {
            [_phoneText becomeFirstResponder];
        }];
        
    
}
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        _containView.top = HEIGHT;
       
        
    }completion:^(BOOL finished) {
        [_phoneText resignFirstResponder];
        [self removeFromSuperview];
    }];
}
@end
