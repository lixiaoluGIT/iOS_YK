//
//  YKLogInView.m
//  YK
//
//  Created by edz on 2018/8/8.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKLogInView.h"
#import "YKPlayVC.h"

@interface YKLogInView()
@property (weak, nonatomic) IBOutlet UIButton *bySelfBtn;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
@implementation YKLogInView
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

- (void)awakeFromNib {
    [super awakeFromNib];
    _bySelfBtn.layer.borderColor = [UIColor colorWithHexString:@"979797"].CGColor;
    _bySelfBtn.layer.borderWidth = 1;
    [_image setContentMode:UIViewContentModeScaleAspectFit];
    
}

- (void)appear{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, WIDHT, HEIGHT);
//    }completion:^(BOOL finished) {
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
    YKPlayVC *play = [[YKPlayVC alloc]init];
    play.hidesBottomBarWhenPushed = YES;
    play.navigationController.navigationBar.hidden = YES;
    play.title = @"玩转衣库";
    play.imageName = @"玩转详情 copy 2-1";
    [[self getCurrentVC].navigationController pushViewController:play animated:YES];
    
}

@end
