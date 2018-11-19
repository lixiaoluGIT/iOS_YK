//
//  YKSearchManager.m
//  YK
//
//  Created by LXL on 2017/12/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSearchManager.h"

@implementation YKSearchManager

+ (YKSearchManager *)sharedManager{
    static YKSearchManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//search page
- (void)getSelectClothPageDataWithNum:(NSInteger)Num Size:(NSInteger)Size
                      OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?num=1&size=%ld",selectClothPage_Url,Size];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
        
        
    }];
}

- (void)filterClothWithclothingTypeId:(NSInteger)clothingTypeId
                       clothingSortId:(NSInteger)clothingSortId
                           OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?clothingTypeId=%ld&clothingSortId=%ld",filterCloth_Url,clothingTypeId,clothingSortId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        if (array.count == 0) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"暂无相关商品" delay:1.2];
        }
        
        if (onResponse) {
            onResponse(dic);
        }
        
        
        
    }];
}

- (void)getPSListWithPage:(NSInteger)page Size:(NSInteger)size sid:(NSString *)sid OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url;
    if ([sid intValue] == 1 || [sid intValue] == 2) {//人气美衣
        url = [NSString stringWithFormat:@"%@?page=%ld&size=%ld&type=%@",@"/popularity/popularityClothingPage",page,size,sid];
    }else {
        url = [NSString stringWithFormat:@"%@?page=%ld&size=%ld",PSList_Url,page,size];
    }

    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (onResponse) {
            onResponse(dic);
        }
    }];
}

- (void)getPSDetailWithPSId:(NSString *)PSId UserId:(NSString *)userId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?ornamentId=%@&userId=%@",PSDetail_Url,PSId,userId];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (onResponse) {
            onResponse(dic);
        }
    }];
}

//获取筛选标签数据
- (void)getFilterDataOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
  [YKHttpClient Method:@"GET" apiName:filterData_Url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (onResponse) {
            onResponse(dic);
        }
    }];
}

@end
