//
//  smartHUD.m
//  wheelservice
//
//  Created by 趣出行开发_小宇 on 2017/1/8.
//  Copyright © 2017年 wheelheres. All rights reserved.
//

#import "smartHUD.h"

static MBProgressHUD *progerssHUD=nil;

@implementation smartHUD

+(void)alertText:(UIView *)view alert:(NSString *)alert delay:(NSInteger)delaytime{
    
    MBProgressHUD *textHUD;
    textHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    textHUD.mode = MBProgressHUDModeText;
    textHUD.labelText = alert;
    textHUD.margin = 20.f;
    textHUD.removeFromSuperViewOnHide = YES;
    [textHUD hide:YES afterDelay:delaytime];
    
}

+(void)progressShow:(UIView *)view alertText:(NSString *)alert{
        progerssHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        progerssHUD.mode = MBProgressHUDModeIndeterminate;
        progerssHUD.labelText = alert;

}

+(void)Hide{
    progerssHUD.hidden = YES;
    [progerssHUD removeFromSuperview];
}

@end
