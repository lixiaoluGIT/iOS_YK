//
//  YKHomeManager.m
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKHomeManager.h"

@implementation YKHomeManager

+ (YKHomeManager *)sharedManager{
    static YKHomeManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//home page
- (void)getMyHomePageDataWithNum:(NSInteger)Num Size:(NSInteger)Size
                      OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

    NSString *url = [NSString stringWithFormat:@"%@?num=1&size=%ld",GetHomePage_Url,Size];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
            
        
        
    }];
}

//品牌详情
- (void)getBrandDetailInforWithBrandId:(NSInteger)brandId
                            OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
//    NSDictionary *dic = @{@"brandId":@"12"};
    NSString *url = [NSString stringWithFormat:@"%@?brandId=%ld",GetBrandDetail_Url,brandId];
//    NSLog(@"%@",dic);
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

- (void)getBrandPageByCategoryWithBrandId:(NSInteger )brandId categoryId:(NSInteger)categoryId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
  
    NSString *url = [NSString stringWithFormat:@"%@?brandId=%ld&categoryId=%ld",GetBrandPageByCategory_Url,brandId,categoryId];
    
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

//获取品牌列表
- (void)getBrandListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
      [YKHttpClient Method:@"GET" apiName:getBrandList_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

//获取商品详情
- (void)getProductDetailInforWithProductId:(NSInteger )ProductId
                                OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

    NSString *url = [NSString stringWithFormat:@"%@?clothing_id=%ld",GetProductDetail_Url,ProductId];
   
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

- (void)requestForMoreProductsWithNumPage:(NSInteger)numPage OnResponse:(void (^)(NSArray *array))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?num=%ld",GetMoreProduct_Url,numPage];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        if (array.count == 0) {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"暂无更多商品" delay:1.2];
        }
        
        if (onResponse) {
            onResponse(array);
        }
        
    }];
}
@end
