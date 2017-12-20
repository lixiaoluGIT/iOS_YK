//
//  YKAleartView.m
//  YK
//
//  Created by LXL on 2017/12/19.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKAleartView.h"

@interface YKAleartView ()
@property (nonatomic,copy)void (^noBlock)(void);
@property (nonatomic,copy)void (^yesBlock)(void);

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIView *aleartView;
@property (nonatomic,strong)UIButton *noBtn;
@property (nonatomic,strong)UIButton *yesBtn;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *line2;
@end

@implementation YKAleartView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self setLayOut];
    }
    return self;
}

- (void)setUpUI{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    self.backView = [[UIView alloc]initWithFrame:self.frame];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    [self addSubview:self.backView];
    
    self.aleartView = [[UIView alloc]init];
    self.aleartView = [[UIView alloc]initWithFrame:CGRectMake(40,-h, w-80, 450)];
    self.aleartView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.aleartView];
    
    self.aleartView.layer.masksToBounds = YES;
    self.aleartView.layer.cornerRadius = 8;

    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = PingFangSC_Semibold(18)
    [self.aleartView addSubview:self.titleLabel];

    
    self.noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.noBtn setTitleColor:[UIColor colorWithHexString:@"516484"] forState:UIControlStateNormal];
    [self.aleartView addSubview:self.noBtn];
    [self.noBtn addTarget:self action:@selector(no) forControlEvents:UIControlEventTouchUpInside];
    self.noBtn.titleLabel.font = PingFangSC_Regular(14);
    
    
    self.yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.aleartView addSubview:self.yesBtn];
    [self.yesBtn addTarget:self action:@selector(yes) forControlEvents:UIControlEventTouchUpInside];
    [self.yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.yesBtn.titleLabel.font = PingFangSC_Regular(14);
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"F5F7FA"];
    [self.aleartView addSubview:line1];
    self.line1 = line1;
    
    self.line2 = [[UILabel alloc]init];
    self.line2.backgroundColor = [UIColor colorWithHexString:@"F5F7FA"];
    [self.aleartView addSubview:self.line2];
    
}
- (void)showWithtitle:(NSString *)title notitle:(NSString *)notitle yestitle:(NSString *)yestitle cancelBlock:(void (^)(void))cancelBlock ensureBlock:(void (^)(void))ensureBlock{
  
    [self setLayOut];
    
    [self show];
    self.noBlock = cancelBlock;
    self.yesBlock = ensureBlock;
    
    self.titleLabel.text = title;
    
    
    self.titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.noBtn setTitle:notitle forState:UIControlStateNormal];
    [self.yesBtn setTitle:yestitle forState:UIControlStateNormal];
    [self.yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.yesBtn setBackgroundColor:[UIColor colorWithHexString:@"ff6d6a"]];
}

- (void)setLayOut{
    
    WeakSelf(weakSelf)

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.aleartView.mas_centerX);
        make.top.equalTo(weakSelf.aleartView.mas_top).offset(8);
        make.height.equalTo(@90);
    }];
    
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line1.mas_bottom);
        make.centerX.equalTo(weakSelf.aleartView.mas_centerX);
        make.height.equalTo(@50);
        make.width.equalTo(@1);
        make.bottom.equalTo(weakSelf.aleartView.mas_bottom);
    }];
    
    [self.noBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line1.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(weakSelf.line2.mas_left);
        make.height.equalTo(@55);
        //        make.bottom.equalTo(weakSelf.aleartView.mas_bottom);
    }];
    
    [self.yesBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.line2.mas_right);
        make.top.equalTo(weakSelf.line1.mas_bottom);
        make.right.equalTo(@0);
        make.height.equalTo(@55);
        //        make.bottom.equalTo(weakSelf.aleartView.mas_bottom);
    }];
    
    [self.aleartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(@50);
        make.right.equalTo(@(-50));
        make.top.equalTo(weakSelf.titleLabel.mas_top);
        make.bottom.equalTo(weakSelf.line2.mas_bottom);
    }];
    
    
}

- (void)no{
    self.noBlock();
    [self dissmiss];
}
- (void)yes{
    self.yesBlock();
    [self dissmiss];
}
- (void)show{
    self.aleartView.center = self.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0.5;
    }];
}
- (void)dissmiss{

    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
        self.backView.alpha = 1;
    }];
   

}
@end
