//
//  YKMessageManager.m
//  YK
//
//  Created by LXL on 2017/12/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMessageManager.h"
#import "YKMessageVC.h"

@interface YKMessageManager()<DXAlertViewDelegate>
@end

@implementation YKMessageManager

+ (YKMessageManager *)sharedManager{
    static YKMessageManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (void)showMessageWithTitle:(NSString *)title Content:(NSString *)content{
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:title message:content cancelBtnTitle:@"取消" otherBtnTitle:@"确定"];
    alertView.delegate = self;
    [alertView show];
}

- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
//        YKMessageVC *message = [YKMessageVC new];
//        message.hidesBottomBarWhenPushed = YES;
//        [[self getCurrentVC].navigationController pushViewController:message animated:YES];
    }
    
}
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
//消息列表
- (void)getMessageListMsgType:(NSInteger)MsgType OnResponse:(void (^)(NSArray *array))onResponse{
    
     [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@?type=%ld",GetMessageList_Ur,MsgType];
    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSArray *msgList = [NSArray arrayWithArray:dict[@"data"]];
        if (msgList.count!=0) {
            if (onResponse) {
                onResponse(msgList);
            }
        }else {
            if (onResponse) {
                onResponse(nil);
            }
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)getMessageListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"GET" URLString:GetMessageList_Ur paramers:nil success:^(NSDictionary *dict) {
        
      
        NSArray *msgList = [NSArray arrayWithArray:dict[@"data"]];
        if (msgList.count!=0) {
            //分组
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

@end
