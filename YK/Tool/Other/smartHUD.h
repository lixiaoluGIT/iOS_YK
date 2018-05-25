//
//  smartHUD.h
//  wheelservice
//
//  Created by 趣出行开发_小宇 on 2017/1/8.
//  Copyright © 2017年 wheelheres. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface smartHUD : NSObject
//{
//    MBProgressHUD *textHUD;
//}
//@property(nonatomic,strong)MBProgressHUD *textHUD;
+(void)alertText:(UIView *)view alert:(NSString *)alert delay:(NSInteger)delaytime;
+(void)progressShow:(UIView *)view alertText:(NSString *)alert;
+(void)Hide;
@end
