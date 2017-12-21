//
//  YKMineheader.m
//  YK
//
//  Created by LXL on 2017/11/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMineheader.h"
@interface YKMineheader()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *isVIP;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backW;
@property (weak, nonatomic) IBOutlet UILabel *VIPLable;

@property (nonatomic,assign)NSInteger VIPStatus;


@end
@implementation YKMineheader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:246.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height/2;
    [self.headImage setContentMode:UIViewContentModeScaleAspectFit];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 20;
    self.backW.constant = 180*WIDHT/414;
    CGFloat fond;
    fond = 15*WIDHT/414;
    self.VIPLable.font = PingFangSC_Regular(fond);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VIP)];
    [self.backView addGestureRecognizer:tap];
    
    self.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap1];
}

- (void)setUser:(YKUser *)user{
    _user = user;
    
    if ([Token length] == 0) {
        _headImage.image = [UIImage imageNamed:@"paisongyuan"];
        _userName.text = @"未登录";
        _isVIP.hidden = YES;
        _backView.hidden = YES;
        _VIPLable.hidden = YES;
        
    }else {
    //已登录
    _isVIP.hidden = NO;
    _backView.hidden = NO;
    _VIPLable.hidden = NO;
    if (user.nickname == [NSNull null]) {
        _userName.text = user.phone;
     
    }else {
        _userName.text = [NSString stringWithFormat:@"%@", user.nickname];
    }
    [_headImage sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"liutao.jpg"]];
    
    self.VIPStatus = [user.effective integerValue];
        
    if ([user.effective intValue] != 4) {//会员状态,已开通
        _isVIP.text = @"会员用户";
        if ([user.effective intValue] == 1) {//使用中
            _VIPLable.text = [NSString stringWithFormat:@"会员剩余%@天",user.validity];
        }
        if ([user.effective intValue] == 2) {//已过期
            _VIPLable.text = @"会员过期去续费";
        }
        if ([user.effective intValue] == 3) {//未交押金
            _VIPLable.text = @"缴纳押金";
        }
        
    }else {//未开通
        _isVIP.text = @"您还不是会员用户";
        _VIPLable.text = @"开通会员";
    }
        
    }
}

- (void)viewClick{

        if (self.viewClickBlock) {
            self.viewClickBlock();
        }
}

- (void)VIP{
    if (self.VIPClickBlock) {
        self.VIPClickBlock(_VIPStatus);//1使用中 2已过期 3无押金 4未开通
    }
}

@end
