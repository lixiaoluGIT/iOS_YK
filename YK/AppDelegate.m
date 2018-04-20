//
//  AppDelegate.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "AppDelegate.h"
#import "YKMainVC.h"
#import "YKHomeVC.h"
#import "WelcomeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <UMSocialCore/UMSocialCore.h>
#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import <GTSDK/GeTuiSdk.h> // GetuiSdk头 件应
// iOS10 及以上需导  UserNotifications.framework
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>
#import <UserNotifications/UserNotifications.h>
#import "DDAdvertisementVC.h"
#import "YKMessageVC.h"
#import <RongIMKit/RongIMKit.h>
#import "YKProductDetailVC.h"
#import "MTA.h"
#import "MTAConfig.h"

@interface AppDelegate ()<WXApiDelegate,UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate,DXAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //马甲包去掉了引导页（防止被拒）
    if (![UD boolForKey:@"notFirst"]) {
    
        _window.rootViewController = [[WelcomeViewController alloc] init];
        
        [[YKUserManager sharedManager]downLoadAdsContentOnResponse:^(NSDictionary *dic) {
            
        }];
    }
    else{
        DDAdvertisementVC *ad = [DDAdvertisementVC new];
        if ([UD objectForKey:Ad_Url]) {
            ad.url = [UD objectForKey:Ad_Url];
            UINavigationController *nvi = [[UINavigationController alloc]initWithRootViewController:ad];
            self.window.rootViewController = nvi;
            
            //请求最新的
            [[YKUserManager sharedManager]downLoadAdsContentOnResponse:^(NSDictionary *dic) {
                
            }];
            
        }else {
        //TODO:请求广告页图片并保存到文件
        [[YKUserManager sharedManager]downLoadAdsContentOnResponse:^(NSDictionary *dic) {
            ad.url = [UD objectForKey:Ad_Url];
            UINavigationController *nvi = [[UINavigationController alloc]initWithRootViewController:ad];
            self.window.rootViewController = nvi;
            
        }];
            
        }
       
    }
    
    //注册融云服务
    [[RCIM sharedRCIM] initWithAppKey:RongAPPID];
    
    if ([Token length]>0) {//已登录
        [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
           
            NSString *rong = [YKUserManager sharedManager].user.rongToken;
            NSString *rongToken;
            if (rong.length>0) {
                rongToken = rong;
            }else {
                //        rongToken = @"mpQunDWgfbYX1aUZ9sKm4FcQiL9c5ZAVYfjoGUM8E8gWfEDFWFo5MVdLkwRRNpWzj8XLG974CL6jEKsp8uXlGw==";
                rongToken = @"";
            }
            [[RCIM sharedRCIM] connectWithToken:rongToken success:^(NSString *userId) {
                NSLog(@"融云链接成功,当前用户:%@",userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"融云链接失败");
            } tokenIncorrect:^{
                NSLog(@"融云token失效");
            }];
            
        }];
        
    }
    //微信支付
    [WXApi registerApp:WeChat_APPKEY withDescription:@"yk"];
 
    //个推
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注:该 法需要在主线程中调
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    //是否允许SDK 后台运行（这个一定要设置，否则后台apns不会执行）
    [GeTuiSdk runBackgroundEnable:YES];
    // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"GT-Channel"];
    [GeTuiSdk setPushModeForOff:NO];
    [self registerRemoteNotification];

    
#pragma mark - 友盟分享相关
     // 统计组件配置
    //友盟统计
    NSString *umKey;
    if ([[self appName] isEqualToString:@"女神的衣柜"]) {
        umKey = @"5a6ae7f7f43e4834a500012e";
        [UMConfigure setEncryptEnabled:YES];//打开加密传输
        [UMConfigure setLogEnabled:YES];//设置打开日志
        [UMConfigure initWithAppkey:umKey channel:@"App Store"];
        [MobClick setScenarioType:E_UM_NORMAL];
        //
        [[UMSocialManager defaultManager] openLog:YES];
        [[UMSocialManager defaultManager] setUmSocialAppkey:umKey];
    }
    if ([[self appName] isEqualToString:@"共享衣橱"]) {
        umKey = @"5ad46debf43e48587400001a";
        [UMConfigure setEncryptEnabled:YES];//打开加密传输
        [UMConfigure setLogEnabled:YES];//设置打开日志
        [UMConfigure initWithAppkey:umKey channel:@"App Store"];
        [MobClick setScenarioType:E_UM_NORMAL];
        //
        [[UMSocialManager defaultManager] openLog:YES];
        [[UMSocialManager defaultManager] setUmSocialAppkey:umKey];
    }
    if ([[self appName] isEqualToString:@"衣库"]) {
        umKey = @"5ad95888f29d9859af000115";
        [UMConfigure setEncryptEnabled:YES];//打开加密传输
        [UMConfigure setLogEnabled:YES];//设置打开日志
        [UMConfigure initWithAppkey:umKey channel:@"App Store"];
        [MobClick setScenarioType:E_UM_NORMAL];
        //
        [[UMSocialManager defaultManager] openLog:YES];
        [[UMSocialManager defaultManager] setUmSocialAppkey:umKey];
    }

    
  
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    
    //腾讯统计
    [[MTAConfig getInstance] setSmartReporting:YES];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
    [[MTAConfig getInstance] setDebugEnable:YES];
    
    //总数据
    [MTA startWithAppkey:@"I3KQ6XQ1J5FT"];
    
//    NSString *tencentKey;
//    //主包
//    if ([[self appName] isEqualToString:@"衣库"]) {
//        tencentKey = @"IC4C21RR8IRZ";
//    }
//    //CPA-1
//    if ([[self appName] isEqualToString:@"共享衣橱"]) {
//        tencentKey = @"I8YF7DJ3F8AX";
//    }
//
//    [MTA startWithAppkey:tencentKey];
    
    [MTA setAccount:@"其它账号" type:AT_OTH];

    return YES;
}
- (NSString *)appName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"%@",app_Name);
    return app_Name;
}
#pragma mark - UM
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms
{
    
    /* 设置微信的appKey和appSecret */
//    [UMSocialWechatHandler setWXAppId:@"wxb4188a08e56b21a0" appSecret:@"h6JQEGRXMPjsA3aydxEXAzyAujzzDZNp" url:@"http://www.umeng.com/social"];
   
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChat_APPKEY appSecret:WeChat_Secret redirectURL:@"http://mobile.umeng.com/social"];
    
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}
#pragma mark - 用户通知(推送) _自定义方法

/** 注册远程通知 */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - Background Fetch 接口回调
//后台刷新数据
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - 远程通知(推送)回调



/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // 控制台打印接收APNs信息
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark - iOS 10中收到推送消息



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
    //保存clientId
    [UD setObject:clientId forKey:@"GTID"];
    [UD synchronize];;
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
    NSDictionary *totalDic = [self dictionaryWithJsonString:payloadMsg];
    if (totalDic.allKeys.count>0) {//后台消息
        [[YKMessageManager sharedManager]showMessageWithTitle:totalDic[@"title"] Content:totalDic[@"text"]];
    }else {//其它消息
        [[YKMessageManager sharedManager]showMessageWithTitle:@"消息提醒" Content:payloadMsg];
        
    }

}
//{"text":"您的订单，编号：【1111111111】已经发货，请注意签收。","type":1,"title":"发货通知"}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
//    self.contentHandler = contentHandler;
//    self.bestAttemptContent = [request.content mutableCopy];
//    //通知个推服务 APNs信息送达
//    [GeTuiExtSdk handelNotificationServiceRequest:request withComplete:^{
//        // Modify the notification content here...
//        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]
//                                         ", self.bestAttemptContent.title];
//                                         //返回新的通知内容,展示APNs通知。
//                                         self.contentHandler(self.bestAttemptContent);
//                                         }];
    }

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [TencentOAuth HandleOpenURL:url];
//}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
        else{
            result = window.rootViewController;
        }
    }
    else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if ([url.scheme isEqualToString:@"openyk"]) {
        NSString *l = [NSString stringWithFormat:@"%@",url];
        NSRange range = NSMakeRange(10, l.length-10);
        NSString *clothID  = [l substringWithRange:range];
        //跳到商品详情
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.titleS = @"商品详情";
        detail.productId = clothID;
        detail.isFromShare = YES;
        [[self getCurrentVC].navigationController pushViewController:detail animated:YES];
    }
    
    //qq登录
    if ([url.host isEqualToString:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    //支付宝支付
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic[@"memo"]);
            [NC postNotificationName:@"alipayres" object:nil userInfo:resultDic];

        }];

    }
    
    //微信相关
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;

}


//微信结果
-(void) onResp:(BaseResp*)resp{
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;

    //微信登录
    if ([resp isKindOfClass:[SendAuthResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0)
        {
            NSLog(@"code %@",aresp.code);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatDidLoginNotification" object:self userInfo:@{@"code":aresp.code}];
        }
    }
    //微信分享
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        
        if (resp.errCode == 0) {  //成功。
          
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatShareSuccessNotification" object:self userInfo:nil];
            
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
//            if (_wxDelegate) {
//                if([_wxDelegate respondsToSelector:@selector(shareSuccessByCode:)]){
//                    [_wxDelegate shareSuccessByCode:response.errCode];
//                }
//            }
        }else{ //失败
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"分享失败" delay:2];
        }
    }
    
    //微信支付
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                
                strMsg = @"微信支付结果：成功！";

                
                dispatch_async(dispatch_get_main_queue(), ^{
 
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpaysuc" object:nil userInfo:@{@"codeid":[NSString stringWithFormat:@"%d",resp.errCode]}];
                    
                });
                
                
                break;
                
            }
                
            default:{
                
                strMsg = [NSString stringWithFormat:@"+++++支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                
                //NSLog(@"微信支付错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpaysuc" object:nil userInfo:@{@"codeid":[NSString stringWithFormat:@"%d",resp.errCode]}];
                });
                
                
                
                break;
            }
        }
    }
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
