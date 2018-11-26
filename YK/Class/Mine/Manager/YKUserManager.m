//
//  YKUserManager.m
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKUserManager.h"
#import <RongIMKit/RongIMKit.h>
#import <AdSupport/AdSupport.h>
#import "YKNewLoginView.h"

@interface YKUserManager()<DXAlertViewDelegate,TencentSessionDelegate>
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
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
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
         
             [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
         }
        
        if ([dic[@"status"] integerValue] == 200) {
            
          
            //登录成功数据处理
//            [self saveCurrentTime];//保存登录时间z
            //上传pushID
            
//            [self saveCurrentToken:dic[@"data"][@"token"] ];//保存token
            [self saveCurrentToken:dic[@"data"]];//保存token
            [self upLoadPushID];//上传推送ID
            
            //上传idfa
            [self uploadIdfa:@"" OnResponse:^(NSDictionary *dic) {
                
            }];
            
            //链接融云
//            [self RongCloudConnect:dic];
            
            //获取当前用户信息
            [self getUserInforOnResponse:^(NSDictionary *dic) {
//                 [self RongCloudConnect];
                //监测登陆成功的事件
                [MobClick event:@"__register" attributes:@{@"userid":_user.userId}];
                [MobClick event:@"__login" attributes:@{@"userid":_user.userId}];
                //主包监测
                [MobClick event:@"register"];
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
//注册
- (void)RegisterWithPhone:(NSString *)phone
               VetifyCode:(NSString *)vetifiCode
               InviteCode:(NSString *)inviteCode
               OnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *colledgeId = inviteCode;
    if (colledgeId==nil) {
        colledgeId = @"0";
    }
    NSString *url = [NSString stringWithFormat:@"%@?phone=%@&captcha=%@&schoolId=%d",Register_Url,phone,vetifiCode,[colledgeId intValue]];
    
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] != 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
        }
        
        if ([dic[@"status"] integerValue] == 200) {
            
            //登录成功数据处理
            //            [self saveCurrentTime];//保存登录时间z
            //上传pushID
            
            [self saveCurrentToken:dic[@"data"]];//保存token
            
            [self upLoadPushID];//上传推送ID
            
            //上传idfa
            [self uploadIdfa:@"" OnResponse:^(NSDictionary *dic) {
                
            }];
            
            //链接融云
            //            [self RongCloudConnect:dic];
            
            //获取当前用户信息
            [self getUserInforOnResponse:^(NSDictionary *dic) {
//                [self RongCloudConnect];
                //监测登陆成功的事件
                [MobClick event:@"__register" attributes:@{@"userid":_user.userId}];
                [MobClick event:@"__login" attributes:@{@"userid":_user.userId}];
                //主包监测
                [MobClick event:@"register"];
            }];
            
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"注册成功" delay:1.2];
            
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
-(void)RongCloudConnect{

    NSString *rongToken = self.user.rongToken;
 
    [[RCIM sharedRCIM] connectWithToken:rongToken success:^(NSString *userId) {
        NSLog(@"融云链接成功,当前用户:%@",userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"融云链接失败");
    } tokenIncorrect:^{
        NSLog(@"融云token失效");
    }];
    
}

- (void)getUserInforOnResponse:(void (^)(NSDictionary *dic))onResponse{

    [YKHttpClient Method:@"GET" apiName:GetUserInfor_Url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] intValue] == 401) {//未登录
            [UD setObject:@"" forKey:@"token"];
            if (onResponse) {
                onResponse(nil);
            }
            return ;
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

     NSString *url = [NSString stringWithFormat:@"%@?phone=%@",GetVetifyCode_Url,phone];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
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

- (void)changePhoneWithPhone:(NSString *)phone
                  VetifyCode:(NSString *)vetifiCode
                      status:(NSInteger)status
                  inviteCode:(NSString *)inviteCode
                  OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    NSDictionary *dic = @{@"phone":phone,@"captcha":vetifiCode};
    
    NSString *urlStr;
    NSString *url =nil;
    if (status==0) {
        urlStr = BindPhone_Url;
        NSString *colledgeId = inviteCode;
        if (colledgeId==nil) {
            colledgeId = @"0";
        }
        url = [NSString stringWithFormat:@"%@?phone=%@&captcha=%@&schoolId=%@",BindPhone_Url,phone,vetifiCode,colledgeId];
    }
    if (status==1) {
        urlStr = ChangePhone_Url;
        url = [NSString stringWithFormat:@"%@?phone=%@&captcha=%@",ChangePhone_Url,phone,vetifiCode];
    }
    
//     NSString *url = [NSString stringWithFormat:@"%@?phone=%@&captcha=%@",urlStr,phone,vetifiCode];
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            
           
            
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"绑定成功" delay:1.2];
            
            if (status==0) {
                [self saveCurrentToken:dic[@"data"][@"token"]];
            }
            
            //上传idfa
            [self uploadIdfa:@"" OnResponse:^(NSDictionary *dic) {
                
            }];
            
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
    [YKSuitManager sharedManager].couponId = 0;
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
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    NSString *channelId;
    if ([app_Name isEqualToString:@"女神的衣柜"]) {
        channelId = @"1";
    }else
    if ([app_Name isEqualToString:@"衣橱共享"]) {
        channelId = @"2";
    }if ([app_Name isEqualToString:@"女神新衣"]) {
        channelId = @"4";
    }else {
        channelId = @"0";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?pushId=%@&channel=%@",upLoadPushID_Url,s,channelId];
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
    
    [[RCIM sharedRCIM] logout];//断开当前用户与融云的链接
    
//    //建立匿名聊天
//    [[RCIM sharedRCIM] connectWithToken:@"mpQunDWgfbYX1aUZ9sKm4FcQiL9c5ZAVYfjoGUM8E8gWfEDFWFo5MVdLkwRRNpWzj8XLG974CL6jEKsp8uXlGw==" success:^(NSString *userId) {
//        NSLog(@"融云链接成功,当前用户:%@",userId);
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"融云链接失败");
//    } tokenIncorrect:^{
//        NSLog(@"融云token失效");
//    }];
    
}

- (void)registerPushForGeTui{
    
}

- (void)exitPushForGeTui{
    
}

//通知server已分享
- (void)shareSuccessOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [YKHttpClient Method:@"POST" apiName:ShareSuccess_Url Params:nil Completion:^(NSDictionary *dic) {
        [self getUserInforOnResponse:^(NSDictionary *dic) {
            if (onResponse) {
                onResponse(nil);
            }
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

- (BOOL)isBase{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"%@",app_Name);
    if ([app_Name isEqualToString:@"衣库"]) {
        return YES;
    }
    return NO;
}

- (void)updateVersion:(NSString *)version{
    if (![self isBase]) {
        return;
    }
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
//    city = Haidian;
//    country = CN;
//    headimgurl = "http://thirdwx.qlogo.cn/mmopen/vi_32/GlIcUX1eK6DhzGLtZiat03CW0ibG4j1nVWaszqCUcQvznDaHdZumcIs9kvRibZScic0LiavPQ887vVIibg8BRbDnKCNA/132";
//    language = "zh_CN";
//    nickname = "\U8d5b";
//    openid = "oxxn91EVOYUNWeaAJ_QjshamSPmU";
//    province = Beijing;
//    sex = 1;
//    unionid = oMTz10QphHKC3BLL7eWst4nWxGqY;
      [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    if ([UD boolForKey:@"bindWX"] == YES) {
        [dic setObject:@"1" forKey:@"type"];//登录
    }else {
        [dic setObject:@"0" forKey:@"type"];//绑定
    }
    [YKHttpClient Method:@"POST" URLString:WeChatLogin_Url paramers:dic success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"微信授权成功" delay:1.8];
            [self saveCurrentToken:dict[@"data"][@"token"]];
            
           
            [self getUserInforOnResponse:^(NSDictionary *dic) {
                //链接融云
                [self RongCloudConnect];
                //监测登陆成功的事件
                [MobClick event:@"__register" attributes:@{@"userid":_user.userId}];
                [MobClick event:@"__login" attributes:@{@"userid":_user.userId}];
                //主包监测
                [MobClick event:@"register"];
            }];
            
            if (onResponse) {
                onResponse(nil);
            }
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2.5];
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
                //链接融云
                [self RongCloudConnect];
                //监测登陆成功的事件
                [MobClick event:@"__register" attributes:@{@"userid":_user.userId}];
                [MobClick event:@"__login" attributes:@{@"userid":_user.userId}];
                //主包监测
                [MobClick event:@"register"];
                
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

- (void)useCouponId:(NSString *)couponId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
     [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@?couponId=%@",useCoupon_Url,couponId];
    
    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dict[@"status"] intValue] == 400) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"不是会员或会员卡过期" delay:1.8];
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"使用成功" delay:1.8];
            if (onResponse) {
                onResponse(nil);
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//下载广告页内容
- (void)downLoadAdsContentOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [YKHttpClient Method:@"GET" apiName:downLoadAd_Url Params:nil Completion:^(NSDictionary *dic) {

        //保存广告页图片Url
        [self saveAdImage:dic];
        
        if (onResponse) {
            onResponse(nil);
        }
        
    }];
}

//校验邀请码是否有效
- (void)checkInviteCode:(NSString *)code OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?code=%@",checkInviteCode_Url,code];
    
    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
       
        if ([dict[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"验证码有效" delay:2.0];
        }else {
             [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2.0];
        }

    } failure:^(NSError *error) {
        
    }];
}

- (void)saveAdImage:(NSDictionary *)dic{
    [UD setObject:dic[@"data"][@"imgUrl"] forKey:Ad_Url];
    [UD setObject:dic[@"data"][@"jumpUrl"] forKey:Ad_linkUrl];
    [UD setObject:dic[@"data"][@"showTime"] forKey:@"showTime"];
    [UD synchronize];
}

- (void)addbust:(NSString *)bust hipline:(NSString *)hipline shoulderWidth:(NSString *)shoulderWidth theWaist:(NSString *)theWaist OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSDictionary *d = @{@"bust":bust,@"hipline":hipline,@"shoulderWidth":shoulderWidth,@"theWaist":theWaist};
    
    [YKHttpClient Method:@"POST" URLString:upLoadUserSize_Url paramers:d success:^(NSDictionary *dict) {
        
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

- (void)getUserSizeOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

    [YKHttpClient Method:@"POST" URLString:getUserSize_Url paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] == 400) {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2];
            
//            if (onResponse) {
//                onResponse(dict);
//            }
            return ;
        }
        
        if (onResponse) {
            onResponse(dict);
        }

    
    } failure:^(NSError *error) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"servier error" delay:2];
    }];
}

//获取大学列表
- (void)getColedgeListStatus:(NSInteger)status OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    if (status==1) {
        [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    [YKHttpClient Method:@"GET" apiName:getColedge_Url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

//上传学校
- (void)postColledgeInforColledgeId:(NSString *)colledgeId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@?schoolId=%@",upLoadColledge_Url,colledgeId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] intValue] == 200)  {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"上传成功" delay:1.5];
            [self getUserInforOnResponse:^(NSDictionary *dic) {
                
            }];
            if (onResponse) {
                onResponse(dic);
            }
        }else{
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"上传失败" delay:1.5];
        }
      
    }];
}

//上传设备idfa
- (void)uploadIdfa:(NSString *)idfa OnResponse:(void (^)(NSDictionary *dic))onResponse{
//
    
    //聚告测试 2D7507F6-2CDD-47E0-92A7-D3DF811E67B1
    //省广畅思测试 3ABD0FF1-3A5C-4E75-B9E5-1AA3DE2C8DD0
    //木桐测试 305E26E8-9767-45D1-AEDF-DC947FA1D5A2
    //正式数据
    NSString *ia = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *url = [NSString stringWithFormat:@"%@?IDFA=%@",upLoadIdfa_Url,ia];

    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {



    }];
    
//    NSString *url = [NSString stringWithFormat:@"%@?pcid=%@&idfa=%@&callback=%@",upLoadIdfa_Url,@"YJHT",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],@"http://api.hutong18.cn/active"];
//
//    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
//
//
//
//    }];
}

- (void)getWalletDetailPageOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient Method:@"GET" apiName:CouponList_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] integerValue] == 200) {
            
            if (onResponse) {
                onResponse(dic);
            }
            
        }
    }];
}

- (void)getAccountPageOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient Method:@"GET" apiName:getAccount_Url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] integerValue] == 200) {
            if (onResponse) {
                onResponse(dic);
            }
            
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.5];
        }
    }];
}

- (void)getAccountDetailPageOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient Method:@"GET" apiName:getAccount_Url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] integerValue] == 200) {
            if (onResponse) {
                onResponse(dic);
            }
            
        }
    }];
}

- (void)tiXianeOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient Method:@"GET" apiName:tiXian_Url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
      
        if ([dic[@"status"] integerValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.5];
        }
        
            if (onResponse) {
                onResponse(dic);
            }
        
            
//        }
        //没绑定微信
//        if ([dic[@"status"] intValue] == 410) {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"即将去绑定微信账户" delay:3];
//           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                    [[YKUserManager sharedManager]loginByWeChatOnResponse:^(NSDictionary *dic) {
//
//                    }];
//
//                });
//
//            });
//        }
//
    }];
}

- (void)showLoginViewOnResponse:(void (^)(NSDictionary *dic))onResponse{
    YKNewLoginView *loginView = [[YKNewLoginView alloc]initWithFrame:kWindow.bounds];
    loginView.loginSuccess = ^(){
        onResponse(nil);
    };

    [kWindow addSubview:loginView];
}

- (void)getShareImagesOnResponse:(void (^)(NSDictionary *))onResponse{
 
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
//    [YKHttpClient Method:@"GET" apiName:shareImageList_Url Params:nil Completion:^(NSDictionary *dic) {
//        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//
//        if ([dic[@"status"] integerValue] == 200) {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.5];
//        }
//
//        if (onResponse) {
//            onResponse(dic);
//        }
//
//    }];
    [YKHttpClient Method:@"GET" URLString:shareImageList_Url paramers:nil success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
                if ([dict[@"status"] integerValue] != 200) {
                    [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.5];
                }
        
                if (onResponse) {
                    onResponse(dict);
                }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getShareImageShareimageId:(NSString *)shareImageid OnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@?userId=%d&shareImgId=%d",getshareImage_Url,[[YKUserManager sharedManager].user.userId intValue],[shareImageid intValue]];
    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dict[@"status"] integerValue] != 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.5];
        }
        
        if (onResponse) {
            onResponse(dict);
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
