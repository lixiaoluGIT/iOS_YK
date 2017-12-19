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


@end
@implementation YKMineheader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:246.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height/2;
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
    //是会员,不是会员
    
}

- (void)setUser:(YKUser *)user{
    _user = user;
    
    if ([Token length] == 0) {
        _headImage.image = [UIImage imageNamed:@"paisongyuan"];
        _userName.text = @"未登录";
        _isVIP.hidden = YES;
        _backView.hidden = YES;
        _VIPLable.hidden = YES;
//        _huiyuanImage.hidden = YES;
        
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
    
//    //不是会员
    if ([user.isVIP intValue] == 1) {
        _isVIP.text = @"您还不是会员";
        _VIPLable.text = @"成为包月会员";
    }else {//是会员
        _isVIP.text = @"您已是会员用户";
        _VIPLable.text = @"会员剩余16天";
    }
        }
}

- (void)viewClick{
//    if ([_user.isVIP isEqualToString:@"0"]) {//不是VIP
        if (self.viewClickBlock) {
            self.viewClickBlock();
        }
//    }
   
}

- (void)VIP{
    if ([_user.isVIP isEqualToString:@"0"]) {//不是VIP
    if (self.VIPClickBlock) {
        self.VIPClickBlock();
    }
    }
}

@end
