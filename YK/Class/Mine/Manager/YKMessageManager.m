//
//  YKMessageManager.m
//  YK
//
//  Created by LXL on 2017/12/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMessageManager.h"

@implementation YKMessageManager

+ (YKMessageManager *)sharedManager{
    static YKMessageManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)getMessageListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"GET" URLString:GetMessageList_Ur paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if (dict[@"data"] != [NSNull null]) {
            if (onResponse) {
                onResponse(dict);
            }
        }else {
            if (onResponse) {
                onResponse(nil);
            }
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

@end
