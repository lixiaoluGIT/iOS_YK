//
//  YKMyHeaderView.m
//  YK
//
//  Created by LXL on 2018/1/31.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKMyHeaderView.h"

@interface YKMyHeaderView()
@property (nonatomic,strong)UIImageView *headPho;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *vipLabel;

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
    _headPho=[[UIImageView alloc]initWithFrame:CGRectMake(WIDHT/2-40, 60,80, 80)];
    _headPho.layer.cornerRadius=40;
    _headPho.clipsToBounds=YES;
    [self addSubview:_headPho];
    
    _name=[[UILabel alloc]initWithFrame:CGRectMake(0, 160,WIDHT, 20)];
    _name.font = PingFangSC_Semibold(20);
    _name.textColor = [UIColor colorWithHexString:@"ffffff"];
    _name.textAlignment=1;
    [self addSubview:_name];

    //赋值
    _headPho.image= [UIImage imageNamed:@"touxianghuancun"];
    _name.text=@"衣库用户";
    //    signatureLabel.text=@"没有签名就算最好的个性签名";
    
    _vipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WIDHT/1.5-40, WIDHT, 40)];
    _vipLabel.text = @"您还不是会员,立即加入!  >>";
    _vipLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    _vipLabel.font = PingFangSC_Semibold(14);
    [self addSubview:_vipLabel];
    _vipLabel.backgroundColor = [UIColor colorWithHexString:@"FDDD55"];
    _vipLabel.textAlignment = NSTextAlignmentCenter;
    _vipLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VIP)];
    [_vipLabel addGestureRecognizer:tap];
    
    self.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap1];
}

- (void)setUser:(YKUser *)user{
    _user = user;
    
    if ([Token length] == 0) {
    _headPho.image = [UIImage imageNamed:@"touxianghuancun"];
    _name.text = @"未登录";
    _vipLabel.text = @"您还不是会员用户";


    }else {
    //已登录

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
