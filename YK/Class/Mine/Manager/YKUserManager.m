//
//  YKUserManager.m
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKUserManager.h"

@implementation YKUserManager

+ (YKUserManager *)sharedManager{
    static YKUserManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)getVetifyCodeWithPhone:(NSString *)phone
                    OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?phone=%@",GetVetifyCode_Url,phone];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"验证码发送成功" delay:1.2];
            

                    if (onResponse) {
                        onResponse(dic);
                    }

        }
    }];
    
}

- (void)LoginWithPhone:(NSString *)phone
            VetifyCode:(NSString *)vetifiCode
            OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

    NSString *url = [NSString stringWithFormat:@"%@?phone=%@&captcha=%@",Login_Url,phone,vetifiCode];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            
            //登录成功数据处理
//            [self saveCurrentTime];//保存登录时间z
            [self saveCurrentToken:dic];//保存token
            
            //获取当前用户信息
            [self getUserInforOnResponse:^(NSDictionary *dic) {
                
            }];
            
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"登录成功" delay:1.2];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [smartHUD  Hide];
               
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (onResponse) {
                        onResponse(dic);
                    }
                    
                });
                
            });
        }
    }];
}

- (void)getUserInforOnResponse:(void (^)(NSDictionary *dic))onResponse{

    [YKHttpClient Method:@"GET" apiName:GetUserInfor_Url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] integerValue] == 200) {
            
            [self getUserInfo:dic[@"data"]];//得到用户基本数据
            if (onResponse) {
                onResponse(nil);
            }
        }
    }];
}

- (void)updateUserInforWithGender:(NSString *)gender nickname:(NSString *)nickname photo:(NSString *)photo OnResponse:(void (^)(NSDictionary *))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    
    if ([gender isEqualToString:@"男"]) {
        gender = @"1";
    }
    if ([gender isEqualToString:@"女"]) {
        gender = @"2";
    }
    NSDictionary *dic = @{@"gender":gender,@"nickname":nickname};
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"POST" URLString:UpdateUserInfor_Url paramers:dic success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] != 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2];
            
            if (onResponse) {
                onResponse(dict);
            }
            return ;
        }
        
        
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"保存成功" delay:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (onResponse) {
                    onResponse(dict);
                }
                
            });
            
        });
    } failure:^(NSError *error) {
            [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"servier error" delay:2];
    }];
}

- (void)exitLoginWithPhone:(NSString *)phone
                VetifyCode:(NSString *)vetifiCode
                OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [self clear];
      [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"退出成功" delay:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (onResponse) {
                onResponse(nil);
            }
            
        });
        
    });
}

- (void)saveCurrentToken:(NSDictionary *)dic{
    [UD setObject:dic[@"data"][@"token"] forKey:@"token"];
}

- (void)getUserInfo:(NSDictionary *)dic{
    self.user = [[YKUser alloc]initWithDictionary:dic];
}

- (void)clear{
    [UD setObject:@"" forKey:@"token"];
    self.user = nil;
}

@end
