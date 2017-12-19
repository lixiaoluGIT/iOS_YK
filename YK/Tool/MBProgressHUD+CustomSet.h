//
//  MBProgressHUD+CustomSet.h
//  FXProject
//
//  Created by 周围 on 2016/11/15.
//  Copyright © 2016年 公司开发电脑. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CustomSet)

///打开进度条
+(void)initMBProgressWithView:(UIView *)currentView;

///打开说明提示框(定时消失)
+(void)initMBDetailWithView:(UIView *)currentView
                   withTime:(CGFloat)time          //定时消失
                  withTitle:(NSString *)title      //标题
                 withDetail:(NSString *)detail;    //副标题

///关闭
+(void)hideMBProgress:(UIView *)currentView;

@end
