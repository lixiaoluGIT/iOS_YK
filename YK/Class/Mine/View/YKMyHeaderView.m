//
//  YKMyHeaderView.m
//  YK
//
//  Created by LXL on 2018/1/31.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKMyHeaderView.h"

@interface YKMyHeaderView()
//@property (nonatomic,strong)UIImageView *headPho;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *toDetailLabel;
@property (nonatomic,strong)UILabel *vipLabel;

@property (nonatomic,strong)UIView *tagView;

@property (nonatomic,assign)NSInteger VIPStatus;
@property (nonatomic,strong)UIButton *vipBtn;
@property (nonatomic,strong)UIImageView *cardImage;

@property (nonatomic,strong)UILabel *l1;
@property (nonatomic,strong)UILabel *l2;
@end

@implementation YKMyHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    //卡片背景
    UIView *cardView = [[UIView alloc]init];
    cardView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:cardView];
    cardView.frame = CGRectMake(kSuitLength_H(68), kSuitLength_H(105), WIDHT-kSuitLength_H(68)*2, kSuitLength_H(114));
 
    //卡图片
    self.cardImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cardView.frame.size.width, cardView.frame.size.height)];
    self.cardImage.image = [UIImage imageNamed:@"个人中心000"];
    self.cardImage.backgroundColor = [UIColor clearColor];
    [cardView addSubview:self.cardImage];
    
    //头像
    _headPho=[[UIImageView alloc]initWithFrame:CGRectMake(kSuitLength_H(26), kSuitLength_H(16),kSuitLength_H(60), kSuitLength_H(60))];
    _headPho.layer.cornerRadius=kSuitLength_H(60/2);
    _headPho.clipsToBounds=YES;
    [cardView addSubview:_headPho];
    

    //姓名
    _name=[[UILabel alloc]initWithFrame:CGRectMake(0, _headPho.bottom+5,kSuitLength_H(100), kSuitLength_H(18))];
    _name.centerX = _headPho.centerX;
    _name.font = PingFangSC_Semibold(kSuitLength_H(14));
    _name.textColor = [UIColor colorWithHexString:@"ffffff"];
    _name.textAlignment=NSTextAlignmentCenter;
    [cardView addSubview:_name];
    
    //会员按钮
    _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _vipBtn.frame = CGRectMake(_headPho.frame.size.width + _headPho.frame.origin.x + kSuitLength_H(49), kSuitLength_H(44), kSuitLength_H(91), kSuitLength_H(26));
    [_vipBtn setTitle:@"未登录" forState:UIControlStateNormal];
    [_vipBtn setImage:[UIImage imageNamed:@"右-3"] forState:UIControlStateNormal];
    [_vipBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -kSuitLength_H(100))];
      [_vipBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -kSuitLength_H(12), 0, 0)];
    _vipBtn.layer.masksToBounds = YES;
    _vipBtn.layer.cornerRadius = kSuitLength_H(26/2);
    _vipBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _vipBtn.layer.borderWidth = 1;
    [_vipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _vipBtn.titleLabel.font = PingFangSC_Medium(12);
    if (WIDHT==320) {
        _vipBtn.titleLabel.font = PingFangSC_Medium(10);
    }
    [_vipBtn addTarget:self action:@selector(VIP) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:_vipBtn];
    
    
//    _toDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _name.bottom+1, WIDHT, 20)];
//    _toDetailLabel.font = PingFangSC_Semibold(14);
//    _toDetailLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
//    _toDetailLabel.textAlignment=1;
//    [self addSubview:_toDetailLabel];
    //赋值
    _headPho.image= [UIImage imageNamed:@"touxianghuancun"];
    _name.text=@"衣库用户";
//    //    signatureLabel.text=@"没有签名就算最好的个性签名";
//
//    _vipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WIDHT/1.5-40, WIDHT, 40)];
//    _vipLabel.text = @"您还不是会员,立即加入!  >>";
//    _vipLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
//    _vipLabel.font = PingFangSC_Semibold(14);
//    [self addSubview:_vipLabel];
//    _vipLabel.backgroundColor = [UIColor colorWithHexString:@"FDDD55"];
//    _vipLabel.textAlignment = NSTextAlignmentCenter;
//    _vipLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VIP)];
//    [_vipLabel addGestureRecognizer:tap];
    
    self.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap1];
    
    //5个图标view
    _tagView = [[UIView alloc]init];
    _tagView.frame = CGRectMake(0, cardView.bottom+kSuitLength_H(24), WIDHT, kSuitLength_H(60));
    _tagView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tagView];
    //5个图标
    NSArray *titles = @[@"待签收",@"待归还",@"卡券包",@"资金账户"];
    NSArray *images = @[@"待签收-111",@"待归还111",@"卡劵包111",@"资金账户111"];
    for (int i=0;i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kSuitLength_H(20)+(WIDHT-kSuitLength_H(20)*2)/4*i, 0, (WIDHT-kSuitLength_H(20)*2)/4, kSuitLength_H(60));
        
        
        [_tagView addSubview:btn];
        //图
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:image];
        //字
        UILabel *label = [[UILabel alloc]init];
        label.text = titles[i];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = PingFangSC_Regular(kSuitLength_V(12));
        [btn addSubview:label];
        //布局
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.top.equalTo(btn.mas_top);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.top.equalTo(image.mas_bottom).offset(6);
        }];
        btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0||i==1) {
            UILabel *l = [[UILabel alloc]init];
            l.frame = CGRectMake(btn.frame.size.width-kSuitLength_H(25), -(kSuitLength_H(11/2)), kSuitLength_H(11), kSuitLength_H(11));
            l.backgroundColor = YKRedColor;
            l.textColor = [UIColor whiteColor];
//            l.text = [NSString stringWithFormat:@"%d",i];
            if (i==0) {
                l.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toQianshouNum];
                if ([[YKUserManager sharedManager].user.toQianshouNum intValue] == 0) {
                    l.hidden = YES;
                }
                self.l1 = l;
            }
            if (i==1) {
                l.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toReceiveNum];
                if ([[YKUserManager sharedManager].user.toReceiveNum intValue] == 0) {
                    l.hidden = YES;
                }
                self.l2 = l;
            }
            l.layer.masksToBounds = YES;
            l.layer.cornerRadius=kSuitLength_H(11)/2;
            
            l.textAlignment = NSTextAlignmentCenter;
            l.font = PingFangSC_Regular(kSuitLength_H(7));
            
            
            [btn addSubview:l];
            
            if ([Token length] == 0) {
                l.hidden = YES;
            }
        }
        
        
    }
}

- (void)btnClick:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock(btn.tag);
    }
}

- (void)setUser:(YKUser *)user{
    _user = user;
    
    if ([Token length] == 0) {
        _headPho.image = [UIImage imageNamed:@"touxianghuancun"];
        _name.text = @"WELCOME";
        _toDetailLabel.text = @"请登录 >";
        [_vipBtn setTitle:@"未登录" forState:UIControlStateNormal];
//    _vipLabel.text = @"您还不是会员用户";

        self.l1.hidden = YES;
        self.l2.hidden = YES;
    }else {
        self.l1.hidden = NO;
        self.l2.hidden = NO;
        self.l1.text =  [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toQianshouNum];
        self.l2.text = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.toReceiveNum];
        if ([[YKUserManager sharedManager].user.toQianshouNum intValue] == 0) {
            self.l1.hidden = YES;
        }
        if ([[YKUserManager sharedManager].user.toReceiveNum intValue] == 0) {
            self.l2.hidden = YES;
        }
    //已登录
        _toDetailLabel.text = @"查看个人信息 >";
        if ([user.nickname isEqual:[NSNull null]]) {
            _name.text = user.phone;

        }else {
            _name.text = [NSString stringWithFormat:@"%@", user.nickname];
        }
        
        [_headPho sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"touxianghuancun"]];

        self.VIPStatus = [user.effective integerValue];

        if ([user.effective intValue] != 4) {//会员状态,已开通
        
            if ([user.effective intValue] == 1) {//使用中
            _vipLabel.text = [NSString stringWithFormat:@"会员剩余%@天",user.validity];
            }
            if ([user.effective intValue] == 2) {//已过期
//            _vipLabel.text = @"会员过期去续费";
            _vipLabel.text = [NSString stringWithFormat:@"会员剩余%@天",user.validity];
            if ([user.validity intValue] < 7) {
                _vipLabel.text = @"会员剩余不足7天,请及时续费";
            }
        }
        if ([user.effective intValue] == 3) {//未交押金
//            _vipLabel.text = @"会员用户,未交押金";
            _vipLabel.text = [NSString stringWithFormat:@"会员剩余%@天",user.validity];
        }

        }else {//未开通
            _vipLabel.text = @"您还不是会员用户,立即加入!  >>";
        }
        
        if ([user.cardType intValue] == 0) {
            [_vipBtn setTitle:@"成为会员" forState:UIControlStateNormal];
            _cardImage.image = [UIImage imageNamed:@"个人中心000"];
        }
        
        if ([user.cardType intValue] == 1) {
            [_vipBtn setTitle:@"月卡会员" forState:UIControlStateNormal];
            _cardImage.image = [UIImage imageNamed:@"月卡"];
        }
        
        if ([user.cardType intValue] == 2) {
            [_vipBtn setTitle:@"季卡会员" forState:UIControlStateNormal];
            _cardImage.image = [UIImage imageNamed:@"季卡-1"];
        }
        
        if ([user.cardType intValue] == 3) {
            [_vipBtn setTitle:@"年卡会员" forState:UIControlStateNormal];
            _cardImage.image = [UIImage imageNamed:@"年卡-1"];
        }
        
        if ([user.cardType intValue] == 4) {
            [_vipBtn setTitle:@"体验卡" forState:UIControlStateNormal];
            _cardImage.image = [UIImage imageNamed:@"个人中心000"];
        }
        
        if ([user.cardType intValue] == 7) {
            [_vipBtn setTitle:@"兑换卡" forState:UIControlStateNormal];
            _cardImage.image = [UIImage imageNamed:@"月卡"];
        }

}
}

- (void)viewClick{
    
    if (self.viewClickBlock) {
        self.viewClickBlock();
    }
}

- (void)VIP{
//    if ([Token length] == 0) {
//        return;
//    }
    if (self.VIPClickBlock) {
        self.VIPClickBlock(_VIPStatus);//1使用中 2已过期 3无押金 4未开通
    }
}


@end
