//
//  YKHomeAleartView.m
//  YK
//
//  Created by edz on 2018/8/8.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHomeAleartView.h"
#import "YKToBeVIPVC.h"
#import "YKRegisterVC.h"

@interface YKHomeAleartView()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *girlImage;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;

@end
@implementation YKHomeAleartView

- (void)awakeFromNib {
    [super awakeFromNib];
    _getBtn.layer.masksToBounds = YES;
    _getBtn.layer.cornerRadius = 20;
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 1;
    _gap.constant = 80*WIDHT/375;
    if ([Token length] == 0) {
        [self.getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    }else {
        [self.getBtn setTitle:@"立即使用" forState:UIControlStateNormal];
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

- (void)appear{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, -20, WIDHT, HEIGHT);
         _backView.alpha = 0.7;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, 20, WIDHT, HEIGHT);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.frame = CGRectMake(0, -10, WIDHT, HEIGHT);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.frame = CGRectMake(0, 10, WIDHT, HEIGHT);
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        self.frame = CGRectMake(0, -5, WIDHT, HEIGHT);
                    }completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            self.frame = CGRectMake(0, 5, WIDHT, HEIGHT);
                        }completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.1 animations:^{
                                self.frame = CGRectMake(0, 0, WIDHT, HEIGHT);
                            }completion:^(BOOL finished) {
//
//                                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//                                //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
//                                animation.fromValue = [NSNumber numberWithFloat:0.f];
//                                animation.toValue = [NSNumber numberWithFloat: M_PI/7];
//                                animation.duration = 1;
//                                animation.autoreverses = NO;
//                                animation.fillMode = kCAFillModeForwards;
//                                animation.repeatCount = 1; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
//                                [self.girlImage.layer addAnimation:animation forKey:nil];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, HEIGHT, WIDHT, HEIGHT);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)bySelf:(id)sender {
    [self dismiss];
}

- (IBAction)playYK:(id)sender {
    [self removeFromSuperview];
    
}

- (IBAction)close:(id)sender {
    [self dismiss];
}

- (IBAction)use:(id)sender {
    [self removeFromSuperview];
    if ([Token length] == 0) {
        //到注册页
        YKRegisterVC *registerVC = [[YKRegisterVC alloc]init];
        [[self getCurrentVC] presentViewController:registerVC animated:YES completion:^{
            
        }];
    }else {
        //到ToBeVip页
        YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
        [YKUserManager sharedManager].isFromCoupon = YES;
         [YKUserManager sharedManager].couponID = 10103;
         [YKUserManager sharedManager].couponNum = 150;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
        
        [[self getCurrentVC] presentViewController:nav animated:YES completion:^{
            
        }];
    }
    
}

@end
