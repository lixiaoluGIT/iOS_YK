//
//  MBProgressHUD+CustomSet.m
//  FXProject
//
//  Created by 周围 on 2016/11/15.
//  Copyright © 2016年 公司开发电脑. All rights reserved.
//

#import "MBProgressHUD+CustomSet.h"

@implementation MBProgressHUD (CustomSet)

+(void)initMBProgressWithView:(UIView *)currentView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.minSize = CGSizeMake(100, 100);
    hud.color = [UIColor grayColor];
}

+(void)initMBDetailWithView:(UIView *)currentView
                   withTime:(CGFloat)time
                  withTitle:(NSString *)title
                 withDetail:(NSString *)detail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.minSize = CGSizeMake(140, 90);
    hud.color = [UIColor grayColor];
    hud.labelText = title;
    hud.detailsLabelText = detail;
    
    //自动隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:currentView animated:YES];
    });
}

+(void)hideMBProgress:(UIView *)currentView
{
    [MBProgressHUD hideHUDForView:currentView animated:YES];
}

@end
