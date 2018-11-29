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
#import "YKLogInView.h"

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
     _gap.constant = kSuitLength_V(120);
    if (WIDHT==320) {
        _gap.constant = 40;
    }
   
    if ([Token length] == 0) {
        [self.getBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    }else {
        [self.getBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    }
    
//    [self shakeAnimation];
}


- (void) shakeAnimation
{
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];//度数转弧度
    
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.4;
    keyAnimaion.repeatCount = MAXFLOAT;
    [self.getBtn.layer addAnimation:keyAnimaion forKey:nil];

//    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    //设置抖动幅度
//    shake.fromValue = [NSNumber numberWithFloat:+0.2];
//    shake.toValue = [NSNumber numberWithFloat:-0.2];
//    shake.duration = 0.5;
//    shake.autoreverses = NO ; //是否重复
//    shake.repeatCount = 100;
//    [self.getBtn.layer addAnimation:shake forKey:@"imageView"];
//    self.getBtn.alpha = 1.0;
//    [UIView animateWithDuration:3.0
//                           delay:0.0
//                         options:UIViewAnimationOptionCurveEaseIn
//                      animations:nil completion:nil];
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

- (void)setDic:(NSDictionary *)Dic{
    _Dic = Dic;
   
    [_girlImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",Dic[@"popupImg"]]] placeholderImage:[UIImage imageNamed:@"弹窗-2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self appear];
    }];
    [YKUserManager sharedManager].couponID = [Dic[@"couponId"] intValue];
    [YKUserManager sharedManager].couponNum = [Dic[@"couponAmount"] integerValue];
}
- (void)appear{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, 0, WIDHT, HEIGHT+2);
         _backView.alpha = 0.7;
    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.frame = CGRectMake(0, 20, WIDHT, HEIGHT);
//        }completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                self.frame = CGRectMake(0, -10, WIDHT, HEIGHT);
//            }completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.1 animations:^{
//                    self.frame = CGRectMake(0, 10, WIDHT, HEIGHT);
//                }completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.1 animations:^{
//                        self.frame = CGRectMake(0, -5, WIDHT, HEIGHT);
//                    }completion:^(BOOL finished) {
//                        [UIView animateWithDuration:0.1 animations:^{
//                            self.frame = CGRectMake(0, 5, WIDHT, HEIGHT);
//                        }completion:^(BOOL finished) {
//                            [UIView animateWithDuration:0.1 animations:^{
//                                self.frame = CGRectMake(0, 0, WIDHT, HEIGHT);
//                            }completion:^(BOOL finished) {
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
//                            }];
//                        }];
//                    }];
//                }];
//            }];
//        }];
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
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
           
            
        }];
//        YKRegisterVC *registerVC = [[YKRegisterVC alloc]init];
//        [[self getCurrentVC] presentViewController:registerVC animated:YES completion:^{
//
//        }];
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
