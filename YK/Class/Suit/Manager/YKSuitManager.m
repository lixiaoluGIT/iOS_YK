//
//  YKSuitManager.m
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuitManager.h"

@implementation YKSuitManager

+ (YKSuitManager *)sharedManager{
    static YKSuitManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//加入购物车
- (void)addToShoppingCartwithclothingId:(NSString *)clothingId
                       clothingStckType:(NSString *)clothingStckType
                             OnResponse:(void (^)(NSDictionary *dic))onResponse{

    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    //商品ID,库存ID
    NSString *url = [NSString stringWithFormat:@"%@?clothingId=%@&clothingStckId=%@",AddToShoppingCart_Url,clothingId,clothingStckType];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

        if ([dic[@"status"] integerValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"已成功添加至衣袋" delay:1.2];
            if (onResponse) {
                onResponse(dic);
            }
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
        }
        
    }];
}

- (void)getShoppingListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

    [YKHttpClient Method:@"GET" apiName:ShoppingCartList_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

- (void)deleteFromShoppingCartwithShoppingCartId:(NSMutableArray *)shoppingCartIdList OnResponse:(void (^)(NSDictionary *dic))onResponse{


//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSDictionary *dic = @{@"cartIdList":shoppingCartIdList};
    
    [YKHttpClient Method:@"POST" URLString:DeleteFromShoppingCart_Url paramers:dic success:^(NSDictionary *dict) {
        if ([dict[@"status"] integerValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.2];
            if (onResponse) {
                onResponse(dic);
            }
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.2];
        }
       
    } failure:^(NSError *error) {
        
    }];
//    [YKHttpClient Method:@"POST" apiName:DeleteFromShoppingCart_Url Params:dic Completion:^(NSDictionary *dic) {
//
////        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//
//        if ([dic[@"status"] integerValue] == 200) {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
//            if (onResponse) {
//                onResponse(dic);
//            }
//        }else {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.2];
//        }
//
//
//    }];
}

- (void)selectCurrentPruduct:(YKSuit *)suit{
   
    [self.suitArray addObject:suit];
}

- (void)cancelSelectCurrentPruduct:(YKSuit *)suit{
    
    [self.suitArray removeObject:suit];
}

- (void)postOrderwithSuits:(NSArray *)suits
                OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

    
    [YKHttpClient Method:@"GET" apiName:releaseOrder_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
            
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (onResponse) {
                        onResponse(dic);
                    }
                    
                });
                
            });
        }
    }];
}

- (NSMutableArray *)suitArray{
    if (!_suitArray) {
        _suitArray = [NSMutableArray array];
    }
    return _suitArray;
}

- (void)clear{
    [self.suitArray removeAllObjects];
    self.suitAccount = 0;
}

@end
