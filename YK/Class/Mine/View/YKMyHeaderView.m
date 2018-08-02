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
    _headPho=[[UIImageView alloc]initWithFrame:CGRectMake(WIDHT/2-30, 54,60, 60)];
    _headPho.layer.cornerRadius=30;
    _headPho.clipsToBounds=YES;
    [self addSubview:_headPho];
    
    _name=[[UILabel alloc]initWithFrame:CGRectMake(0, _headPho.bottom+7,WIDHT, 20)];
    _name.font = PingFangSC_Semibold(18);
    _name.textColor = [UIColor colorWithHexString:@"ffffff"];
    _name.textAlignment=1;
    [self addSubview:_name];
    
    _toDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _name.bottom+1, WIDHT, 20)];
    _toDetailLabel.font = PingFangSC_Semibold(14);
    _toDetailLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    _toDetailLabel.textAlignment=1;
    [self addSubview:_toDetailLabel];
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
    _tagView.frame = CGRectMake(0, _toDetailLabel.bottom+23, WIDHT, 58);
    _tagView.backgroundColor = mainColor;
    [self addSubview:_tagView];
    //5个图标
    NSArray *titles = @[@"全部衣袋",@"待签收",@"待归还",@"优惠劵",@"资金账户"];
    NSArray *images = @[@"衣袋图标",@"待签收-1",@"待归还-1",@"优惠劵-2",@"资金账户"];
    for (int i=0;i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(WIDHT/5*i, 0, WIDHT/5, 58);
        [_tagView addSubview:btn];
        //图
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:image];
        //字
        UILabel *label = [[UILabel alloc]init];
        label.text = titles[i];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
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
//    _vipLabel.text = @"您还不是会员用户";

    }else {
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

}
}

- (void)viewClick{
    
    if (self.viewClickBlock) {
        self.viewClickBlock();
    }
}

- (void)VIP{
    if ([Token length] == 0) {
        return;
    }
    if (self.VIPClickBlock) {
        self.VIPClickBlock(_VIPStatus);//1使用中 2已过期 3无押金 4未开通
    }
}


@end
