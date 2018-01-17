//
//  YKUserManager.m
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKUserManager.h"

@interface YKUserManager()<TencentSessionDelegate>
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
//    //把值赋给app
//    [YKUserManager sharedManager].user.nickname  = dic[@"nickname"];
//    [YKUserManager sharedManager].user.photo = dic[@"headimgurl"];
//    [YKUserManager sharedManager].user.gender = dic[@"sex"];
//    [UD setObject:@"sad ad " forKey:@"token"];//已登录的状态
//
//    //app登录
////    [self thirdLoginByWeChatOnResponse:^(NSDictionary *dic) {
//        if (onResponse) {
//            onResponse(nil);
//        }
////    }];
    [dic removeObjectForKey:@"privilege"];

    
    [YKHttpClient Method:@"POST" URLString:WeChatLogin_Url paramers:dic success:^(NSDictionary *dict) {
        if ([dict[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"微信登录成功" delay:1.8];
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

//调用APP的登录接口
- (void)thirdLoginByWeChatOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    if (onResponse) {
        onResponse(nil);
    }
}

//调起qq登录
- (void)loginByTencentOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQ_APPID andDelegate:self];
   NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
    [_tencentOAuth authorize:permissions inSafari:NO]; //授权
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        //- (void)getUserInfoResponse:(APIResponse*) response
        //这个方法就是 用户信息的回调方法。
        
        [_tencentOAuth getUserInfo];
    }else{
        
        NSLog(@"accessToken 没有获取成功");
    }
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
}


/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }
    
}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //            _labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            NSLog(@"增量授权失败，无网络连接，请设置网络");
            break;
        }
        case kUpdateFailUserCancel:
        {
            //            _labelTitle.text=@"增量授权失败，用户取消授权";
            NSLog(@"增量授权失败，用户取消授权");
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            NSLog(@"增量授权失败，未知错误");
            break;
        }
    }
    
    
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@" response %@",response);
}



@end
