//
//  YKVipCell.m
//  YK
//
//  Created by edz on 2018/7/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKVipCell.h"
#import "YKUserAccountVC.h"

@interface YKVipCell()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIButton *becomeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;

@end

@implementation YKVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _becomeBtn.layer.masksToBounds = YES;
    _becomeBtn.layer.cornerRadius = 16;
    // Initialization code
}
- (IBAction)btnClick:(id)sender {
    if (_btnClick) {
        _btnClick();
    }
}
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
        else{
            result = window.rootViewController;
        }
    }
    else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    
    return result;
}
- (void)setUser:(YKUser *)user{
    _user = user;
    _dayLabel.text = _user.validity;
    if ([_user.effective intValue] == 4 ) {//不是会员
        _dayLabel.text = _user.validity;
        _vipStatusLabel.text = @"您还不是会员";
        [_becomeBtn setTitle:@"成为包月会员" forState:UIControlStateNormal];
        
    }else {
        
        _dayLabel.text = _user.validity;
        if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) {
            _vipStatusLabel.text = @"缴纳押金>";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                YKUserAccountVC *account = [[YKUserAccountVC alloc]init];
                account.hidesBottomBarWhenPushed = YES;
                [[self getCurrentVC].navigationController pushViewController:account animated:YES];
            }];
            [self setUserInteractionEnabled:YES];
            [self addGestureRecognizer:tap];
            _backImage.image = [UIImage imageNamed:@"yk-1"];
            [_becomeBtn setTitle:@"续费" forState:UIControlStateNormal];
            return;
        }
        
       
        
        if ([_user.cardType intValue]==1||[_user.cardType intValue]==6) {//月卡
            _vipStatusLabel.text = @"月卡会员";
            _backImage.image = [UIImage imageNamed:@"yk-1"];
        }
        if ([_user.cardType intValue]==2) {//季卡
            _vipStatusLabel.text = @"季卡会员";
            _backImage.image = [UIImage imageNamed:@"jj"];
        }
        if ([_user.cardType intValue]==3) {//年卡
            _vipStatusLabel.text = @"年卡会员";
            _backImage.image = [UIImage imageNamed:@"nk"];
        }
        if ([_user.cardType intValue]==4) {//体验卡
            _vipStatusLabel.text = @"体验卡会员";
            _backImage.image = [UIImage imageNamed:@"yy"];
        }
        if ([_user.cardType intValue]==5) {//助力卡
            _vipStatusLabel.text = @"助力卡会员";
            _backImage.image = [UIImage imageNamed:@""];
        }
        [_becomeBtn setTitle:@"续费" forState:UIControlStateNormal];
        
    }
}

@end
