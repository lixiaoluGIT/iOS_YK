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
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
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
        
         if ([dic[@"status"] integerValue] != 200) {
         [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"验证码错误" delay:1.2];
         }
        
        if ([dic[@"status"] integerValue] == 200) {
            
            //登录成功数据处理
//            [self saveCurrentTime];//保存登录时间z
            //上传pushID
            
            [self saveCurrentToken:dic];//保存token
            
            [self upLoadPushID];//上传推送ID
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
        
        if ([dic[@"status"] intValue] == 401) {//未登录
            [UD setObject:@"" forKey:@"token"];
           
        }
       [self getUserInfo:dic[@"data"]];//得到用户基本数据
            if (onResponse) {
                onResponse(nil);
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

-(void)uploadHeadImageWithData:(NSData*)picData OnResponse:(void (^)(NSDictionary *dic))onResponse{

     [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,UploadImage_Url];
    [YKHttpClient uploadPicUrl:url pic:picData success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] == 200) {
            
            [self getUserInforOnResponse:^(NSDictionary *dic) {
                if (onResponse) {
                    onResponse(nil);
                }
            }];
             [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"修改成功" delay:1.2];
            
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.2];
        }
    } failure:^(NSError *error) {
       
    }];
}

- (void)changePhoneGetVetifyCodeWithPhone:(NSString *)phone
                               OnResponse:(void (^)(NSDictionary *dic))onResponse{

     NSString *url = [NSString stringWithFormat:@"%@?phone=%@",ChangePhoneGetVetifyCode_Url,phone];
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {

        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

        if ([dic[@"status"] integerValue] == 200) {

            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"验证码发送成功" delay:1.2];


            if (onResponse) {
                onResponse(dic);
            }

        }else {
             [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
        }
    }];
}

- (void)changePhoneWithPhone:(NSString *)phone
                  VetifyCode:(NSString *)vetifiCode
                  OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    NSDictionary *dic = @{@"phone":phone,@"captcha":vetifiCode};
     NSString *url = [NSString stringWithFormat:@"%@?phone=%@&captcha=%@",ChangePhone_Url,phone,vetifiCode];
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"修改成功" delay:1.2];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self getUserInforOnResponse:^(NSDictionary *dic) {
                        
                    }];
                    if (onResponse) {
                        onResponse(dic);
                    }
                    
                });
                
            });
            
        } else {
             [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
        }
    }];
}

//TODO:退出登录推送应该处理
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

- (void)upLoadPushID{
    
    NSString *s = [UD objectForKey:@"GTID"];
    
    NSString *url = [NSString stringWithFormat:@"%@?pushId=%@",upLoadPushID_Url,s];
    [YKHttpClient Method:@"POST" URLString:url paramers:nil success:^(NSDictionary *dict) {

    } failure:^(NSError *error) {
       
    }];
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
    [UD removeObjectForKey:@"lastAleartTime"];
}

- (void)registerPushForGeTui{
    
}

- (void)exitPushForGeTui{
    
}

//通知server已分享
- (void)shareSuccess{
    
    [YKHttpClient Method:@"POST" apiName:ShareSuccess_Url Params:nil Completion:^(NSDictionary *dic) {
        [self getUserInforOnResponse:^(NSDictionary *dic) {
            
        }];
    }];
}

- (void)checkVersion{
   
        NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
        NSNumber *flag = [NSNumber numberWithInt:1];
        double localVersionDou = [localVersion doubleValue];

    NSString *url = [NSString stringWithFormat:@"%@?appVersion=%@",@"/user/checkTheLatestVersion",@"1"];

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"程序猿哥哥又创造了奇迹" message:@"有新版本可以更新了!" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
    alertview.delegate = self;
    [alertview show];
    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        //如果新版本大于当前版本,更新
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"程序猿哥哥又创造了奇迹" message:@"有新版本可以更新了!" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
//        alertview.delegate = self;
//        [alertview show];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//取消
        
    }
    if (buttonIndex==1) {//appstore更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id1197745409"]];
    }
}

@end
