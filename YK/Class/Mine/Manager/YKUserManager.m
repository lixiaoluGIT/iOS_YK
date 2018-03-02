//
//  YKUserManager.m
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKUserManager.h"

@interface YKUserManager()<TencentSessionDelegate,DXAlertViewDelegate>
{
//    TencentOAuth *tencentOAuth;
//    NSArray * permissions;
}
@property (nonatomic,strong)TencentOAuth *tencentOAuth;

@end
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

        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
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
            
            [self saveCurrentToken:dic[@"data"][@"token"] ];//保存token
            
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
                  VetifyCode:(NSString *)vetifiCode status:(NSInteger)status
                  OnResponse:(void (^)(NSDictionary *dic))onResponse;{
    
//    NSDictionary *dic = @{@"phone":phone,@"captcha":vetifiCode};
    
    NSString *urlStr;
    if (status==0) {
        urlStr = BindPhone_Url;
    }
    if (status==1) {
        urlStr = ChangePhone_Url;
    }
    
     NSString *url = [NSString stringWithFormat:@"%@?phone=%@&captcha=%@",urlStr,phone,vetifiCode];
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"绑定成功" delay:1.2];
            
            if (status==0) {
                [self saveCurrentToken:dic[@"data"][@"token"]];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self getUserInforOnResponse:^(NSDictionary *dic) {
                        if (onResponse) {
                            onResponse(dic);
                        }
                    }];
                    
                    
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
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"退出成功" delay:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
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

- (void)saveCurrentToken:(NSString *)token{
    [UD setObject:token forKey:@"token"];
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

- (NSString *)getVersionString:(NSString *)str{
    NSString *version = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    return version;
}

- (void)checkVersion{
   
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
   
    double localVersionDou = [[self getVersionString:localVersion] doubleValue];

    NSString *url = [NSString stringWithFormat:@"%@?appVersion=%@",@"/user/checkTheLatestVersion",@"1"];

    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        //如果新版本大于当前版本,更新
        double versionNumberMin = [[self getVersionString:dict[@"data"][@"firstVersion"]] doubleValue];
        double versionNumberMax = [[self getVersionString:dict[@"data"][@"newVersion"]] doubleValue];
        if (localVersionDou < versionNumberMin) {//当前版本小于最低版本
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateVersion:dict[@"data"][@"newVersion"]];
            });
        }else if (localVersionDou > versionNumberMin && localVersionDou < versionNumberMax){//大于最低版本小于最高版本
            [self updateVersion:dict[@"data"][@"newVersion"]];
        }
       
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateVersion:(NSString *)version{
    NSString *msg = [NSString stringWithFormat:@"发现有%@版本可以更新!",version];
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"升级提示" message:msg cancelBtnTitle:@"暂不更新" otherBtnTitle:@"去更新"];
    alertView.delegate = self;
    [alertView show];
}
- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DownLoad_Url]];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//取消
        
    }
    if (buttonIndex==1) {//appstore更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/id1197745409"]];
    }
}

- (void)loginByWeChatOnResponse:(void (^)(NSDictionary *dic))onResponse{
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)getWechatAccessTokenWithCode:(NSString *)code OnResponse:(void (^)(NSDictionary *dic))onResponse
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    WeChat_APPKEY,WeChat_Secret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                NSString *accessToken = dic[@"access_token"];
                NSString *openId = dic[@"openid"];
                
                [self getWechatUserInfoWithAccessToken:accessToken openId:openId OnResponse:^(NSDictionary *dic) {
                    if (onResponse) {
                        onResponse(nil);
                    }
                }];
            }
        });
    });
}

- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId OnResponse:(void (^)(NSDictionary *dic))onResponse
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                
                NSString *openId = [dic objectForKey:@"openid"];
                NSString *memNickName = [dic objectForKey:@"nickname"];
                NSString *memSex = [dic objectForKey:@"sex"];
                
                [self loginWithOpenId:openId memNickName:memNickName memSex:memSex dic:dic OnResponse:^(NSDictionary *dic) {
                    if (onResponse) {
                        onResponse(nil);
                    }
                }];
            }
        });
        
    });
}

//调用server的第三方登录接口
- (void)loginWithOpenId:(NSString *)openId memNickName:(NSString *)memNickName memSex:(NSString *)memSex dic:(NSMutableDictionary *)dic OnResponse:(void (^)(NSDictionary *dic))onResponse{

    [dic removeObjectForKey:@"privilege"];

      [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient Method:@"POST" URLString:WeChatLogin_Url paramers:dic success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"微信授权成功" delay:1.8];
            [self saveCurrentToken:dict[@"data"][@"token"]];
            if (onResponse) {
                onResponse(nil);
            }
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"message"] delay:1.8];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//调起qq登录
- (void)loginByTencentOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQ_APPID andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    _tencentOAuth.authShareType = AuthShareType_QQ;
    [_tencentOAuth authorize:permissions];
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    if (_tencentOAuth.accessToken) {
        [_tencentOAuth getUserInfo];
    }else{
        NSLog(@"accessToken 没有获取成功");
    }
}

- (void)getUserInfoResponse:(APIResponse*) response{
  
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:response.jsonResponse];
    NSLog(@"qq用户信息%@",dic);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TencentDidLoginNotification" object:self userInfo:@{@"code":dic}];
}

- (void)loginSuccessByTencentDic:(NSDictionary *)Dic OnResponse:(void (^)(NSDictionary *dic))onResponse{

    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *city;
    if ([dic[@"city"] isEqualToString:@""]) {
        city = @"暂无城市";
    }else {
        city = dic[@"city"];
    }
    [dic setObject:Dic[@"city"] forKey:@"city"];
    [dic setObject:Dic[@"figureurl_qq_2"] forKey:@"headimgurl"];
    [dic setObject:_tencentOAuth.openId forKey:@"openid"];
    [dic setObject:Dic[@"nickname"] forKey:@"nickname"];
    [dic setObject:Dic[@"gender"] forKey:@"sex"];
    
    [YKHttpClient Method:@"POST" URLString:TencentLogin_Url paramers:dic success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"qq授权成功" delay:1.8];
            [self saveCurrentToken:dict[@"data"][@"token"]];
            [self getUserInforOnResponse:^(NSDictionary *dic) {
                if (onResponse) {
                    onResponse(nil);
                }
            }];
           
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"message"] delay:1.8];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
