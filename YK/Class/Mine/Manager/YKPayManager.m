//
//  YKPayManager.m
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKPayManager.h"
#define PID  @"2088521576324489"
#define APPID  @"2017011705155246"

@implementation YKPayManager

+ (YKPayManager *)sharedManager{
    static YKPayManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(NSString*)base64Encode:(NSString *)str{
    
    NSData *dataDecoded = [[NSData alloc] initWithBase64EncodedData:str options:0];
    return [[NSString alloc] initWithData:dataDecoded encoding:NSUTF8StringEncoding];
}

- (void)payWithPayMethod:(NSInteger )payMethod
                 payType:(NSInteger )paytype
                activity:(NSInteger)activity
               channelId:(int)couponId
              inviteCode:(NSString *)inviteCode
              OnResponse:(void (^)(NSDictionary *dic))onResponse{
  
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

//    if (paytype==2||paytype==3) {
//        activity = 1;
//    }
    //判断支付来源
    NSString *str;
//    if ([[self appName] isEqualToString:@"衣库"]){
        if (couponId==0) {
            if ([[YKUserManager sharedManager].user.depositEffective intValue] == 1) {//押金有效，不交押金
                str = [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&deposit=%d&activity=%@&couponId=0",AliPay_Url,@(payMethod),@(paytype),2,@(activity)];
            }else {//押金无效，会员卡押金一起交
                str =  [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&deposit=%d&activity=%@&couponId=0",AliPay_Url,@(payMethod),@(paytype),1,@(activity)];
            }
            
            if (paytype==0) {//单独充押金
                str =  [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&deposit=%d&activity=%@&couponId=0",AliPay_Url,@(payMethod),@(paytype),1,@(activity)];
            }
        }else {
        if ([[YKUserManager sharedManager].user.depositEffective intValue] == 1) {//押金有效，不交押金
            str = [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&deposit=%d&activity=%@&couponId=%@",AliPay_Url,@(payMethod),@(paytype),2,@(activity),@(couponId)];
        }else {//押金无效，会员卡押金一起交
            str =  [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&deposit=%d&activity=%@&couponId=%@",AliPay_Url,@(payMethod),@(paytype),1,@(activity),@(couponId)];
        }
        
        if (paytype==0) {//单独充押金
            str =  [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&deposit=%d&activity=%@&couponId=%@",AliPay_Url,@(payMethod),@(paytype),1,@(activity),@(couponId)];
        }}
    
    if (paytype == 5) {//加衣劵
        str = [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&deposit=%d&activity=%@&couponId=%@",AliPay_Url,@(payMethod),@(paytype),2,@(activity),@(couponId)];
    }
//    }
    
//    if ([[self appName] isEqualToString:@"女神的衣柜"]) {//主包支付{//马甲包支付
//        str = [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&platform=%@",AliPay_Url,@(payMethod),@(paytype),@"1"];
//    }
//
//    if ([[self appName] isEqualToString:@"共享衣橱"]) {//主包支付{//马甲包支付
//        str = [NSString stringWithFormat:@"%@?payMethod=%@&payType=%@&platform=%@",AliPay_Url,@(payMethod),@(paytype),@"2"];
//    }
    
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"GET" URLString:str paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] != 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2];
            return ;
        }
        
        //预fu fei
        //短链监测
        [MobClick event:@"__cust_event_4"];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                switch (payMethod) {
                    case 1://支付宝支付
                        [self aliPayWithSign:[self base64Encode:dict[@"data"][@"alipay"]]];
                       break;
                        
                    case 2://微信支付
                      [self WXPayPostDic:dict[@"data"] Debug:nil CallWXpay:^(NSString *wrong) {
                            
                        }];
                        break;
                    default:
                        break;
                }
             
                
                if (onResponse) {
                    onResponse(dict);
                }
                
            });
            
        });
    } failure:^(NSError *error) {
        
    }];
}

//判断是主包支付还是马甲包支付
- (NSString *)appName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"%@",app_Name);
   
    return app_Name;
}

//调起支付宝支付
- (void)aliPayWithSign:(NSString *)pay_param {
    
   NSString *appScheme = @"YKAliPay";
    [[AlipaySDK defaultService] payOrder:pay_param fromScheme:appScheme callback:^(NSDictionary *resultDic) {
       

    }];
}

//调起微信支付
- (void)WXPayPostDic:(NSDictionary *)dic  Debug:(void(^)(NSString *error))errorBlock CallWXpay:(void(^)(NSString *wrong))callWXpay {
 
    payRequsestHandler *req = [payRequsestHandler alloc];
    [req init:APP_ID mch_id:MCH_ID];
    [req setKey:PARTNER_ID];

    if(dic == nil){
        NSString *debug = [req getDebugifo];
        errorBlock(debug);
    }else{
        callWXpay([req getDebugifo]);
        NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dic objectForKey:@"appid"];
        req.partnerId           = [dic objectForKey:@"partnerid"];
        req.prepayId            = [dic objectForKey:@"prepayid"];
        req.nonceStr            = [dic objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dic objectForKey:@"package"];
        req.sign                = [dic objectForKey:@"sign"];
//        req.openID              = @"wx08491f30bacfc1ce";
//                req.partnerId           = @"1496670272";
//                req.prepayId            = @"wx08120701416881d574e459463625596850";
//                req.nonceStr            = @"1207005880";
//        req.timeStamp           = 1533701220 ;
//                req.package             = @"Sign=WXPay";
//                req.sign                = @"BB03AB5F94D05F605159986A019";
//
        
        [WXApi sendReq:req];
    }
}

//微信支付结果
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                
                strMsg = @"++++++++支付结果：成功！";
                //NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpaysuc" object:nil userInfo:@{@"codeid":[NSString stringWithFormat:@"%d",resp.errCode]}];
                
                break;
            }
                
            default:{
                
                strMsg = [NSString stringWithFormat:@"+++++支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                
                //NSLog(@"++++++错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpaysuc" object:nil userInfo:@{@"codeid":[NSString stringWithFormat:@"%d",resp.errCode]}];
                
                
                break;
            }
        }
    }
}

//钱包相关

- (void)getWalletPageOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [YKHttpClient Method:@"GET" apiName:wallet_Url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] integerValue] == 200) {
            
            if (onResponse) {
                onResponse(dic[@"data"]);
            }
            
        }
    }];
}

- (void)getWalletDetailPageOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient Method:@"GET" apiName:transactionDetails_Url Params:nil Completion:^(NSDictionary *dic) {
        
             [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] integerValue] == 200) {
            
            if (onResponse) {
                onResponse(dic);
            }
            
        }
    }];
}

- (void)updateVIPInforPageOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [YKHttpClient Method:@"GET" apiName:updateMemberInfoRegular_Url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] integerValue] == 200) {
            
            
            
        }
    }];
}

//押金退还申请
- (void)refondDepositOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@",refundApply_Url];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"已提交申请" delay:1.2];
            if (onResponse) {
                onResponse(dic);
            }
            
        }else {
             [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
        }
    }];
}

//押金退还
- (void)returnDepositOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?userId=%@",returnDeposit_Url,[YKUserManager sharedManager].user.userId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            
            if (onResponse) {
                onResponse(dic[@"data"]);
            }
            
        }
    }];
}

@end
