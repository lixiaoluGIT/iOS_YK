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

#import <GTSDK/GeTuiSdk.h> // GetuiSdk头 件应
// iOS10 及以上需导  UserNotifications.framework
 #import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<WXApiDelegate,UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[YKMainVC alloc]init];
    
    if ([Token length]>0) {//已登录
        [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
            
        }];
    }
    //微信支付
    [WXApi registerApp:@"wxb4188a08e56b21a0" withDescription:@"meng"];
    
    //个推
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注:该 法需要在主线程中调
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    
    [self registerRemoteNotification];
//
//    application.statusBarHidden=NO;
//
//    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [self.window makeKeyAndVisible];
//    self.window.rootViewController=[[WelcomeViewController alloc]init];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)registerRemoteNotification {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
                if (!error) {
                    NSLog(@"request authorization succeeded!");
                } }];
        } else {
            // Fallback on earlier versions
        }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
} else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
} else {
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    
                                                                   }

}

//向个推服务注册DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    // 向个推服务 注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

// iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    [GeTuiSdk setBadge:1]; //同步本地 标值到服务
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    NSLog(@"willPresentNotification:%@", notification.request.content.userInfo);
    // 根据APP需要，判断是否要提示 户Badge、Sound、Alert
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *) taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString * )appId {
    //收到个推消息
    NSString *payloadMsg = nil; if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg :%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (!url) {
        return NO;
    }

    if ([url.host isEqualToString:@"safepay"]) {//支付宝支付
      [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger resultCode = [resultDic[@"resultStatus"] intValue];
//            switch (resultCode) {
//                case 9000://支付成功
//                     [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"支付成功" delay:2];
//                    break;
//                case 6001://支付成功
//                     [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"取消了支付" delay:2];
//                    break;
//
//                default://支付失败
//                     [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"支付失败" delay:2];
//                    break;
//            }
          [NC postNotificationName:@"alipayres" object:nil userInfo:resultDic];
            NSLog(@"支付结果result=%@",resultDic[@"memo"]);
        }];
    }
    
    if ([url.description hasSuffix:@"wx"]) {
        
        //微信
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    

    
    
    return YES;
}

//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//
//    if (!url) {
//        return NO;
//    }
//
//    NSString *urlString = [url absoluteString];
//
//    // 从QQ的分享进入行程详情
//    if([urlString rangeOfString:@"travelDetail"].location !=NSNotFound)
//    {
//
//        NSArray *array = [urlString componentsSeparatedByString:@"="];
//        NSDictionary *travelIdDict = @{@"travelId":array[1]};
//
//        [NC postNotificationName:@"changerootvc" object:nil userInfo:@{@"dop":@"passenger"}];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [NC postNotificationName:@"pushTravelDetailVC" object:nil userInfo:travelIdDict];
//        });
//
//    }
//
//    // H5点击邀TA订座跳转置顶聊天页
//    if ([url.host isEqualToString:@"chatView"]) {
//
//        NSArray *array = [urlString componentsSeparatedByString:@"="];
//
//        NSDictionary *phoneNumDict = @{@"phoneNum":array[1]};
//
//        [NC postNotificationName:@"pushChatView" object:nil userInfo:phoneNumDict];
//
//    }
//
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //NSLog(@"result = %@",resultDic[@"memo"]);
//
//            [NC postNotificationName:@"alipayres" object:nil userInfo:resultDic];
//
//        }];
//
//    }
//
//
//    if ([url.host isEqualToString:@"pay"]) {
//
//        //        //NSLog(@"========w============");
//        //微信
//        return [WXApi handleOpenURL:url delegate:self];
//
//
//
//    }
//
//    return YES;
//
//}

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
                
                strMsg = @"微信支付结果：成功！";
                //NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //NSLog(@"caonima");
                    
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
