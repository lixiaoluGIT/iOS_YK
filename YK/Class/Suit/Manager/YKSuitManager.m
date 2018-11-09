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

//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    //商品ID,库存ID
    NSString *url = [NSString stringWithFormat:@"%@?clothingId=%@&clothingStckId=%@",AddToShoppingCart_Url,clothingId,clothingStckType];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

        [MobClick event:@"__add_cart" attributes:@{@"item":@"衣库服饰",@"amount":@"200"}];
        
        if ([dic[@"status"] integerValue] == 200) {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"已成功添加至衣袋" delay:1.2];
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

//查询用户加衣劵
- (void)searchAddCCOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [YKHttpClient Method:@"GET" URLString:SearchCC_Url paramers:nil success:^(NSDictionary *dict) {
        
        if ([dict[@"status"] integerValue] == 200) {
            NSArray *array = [NSArray arrayWithArray:dict[@"data"]];
            if (array.count>0) {//有加衣劵
                _isHadCC = YES;
                _addClothingId = array[0][@"addClothingId"];
            }else {//没加衣劵
                _isHadCC = NO;
                _addClothingId = @"0";
            }
            
            if (onResponse) {
                onResponse(dict);
            }
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.2];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)useAddCCaddClothingVoucherId:(NSString *)addClothingVoucherId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    NSString *url = [NSString stringWithFormat:@"%@?addClothingVoucherId=%@",useCC_Url,addClothingVoucherId];
    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        
        if ([dict[@"status"] integerValue] == 200) {
            
          
            
            if (onResponse) {
                onResponse(dict);
            }
        }else {
//            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.2];
        }
        
    } failure:^(NSError *error) {
        
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
//    self.isUseCC = NO;
//    self.isHadCC = NO;
//    self.addClothingId = @"0";
}

- (void)searchOnceStatusOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [YKHttpClient Method:@"GET" URLString:onceStatus_Url paramers:nil success:^(NSDictionary *dict) {
        
        if ([dict[@"status"] integerValue] == 200) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
            if ([dic[@"surplusNumber"] intValue] == 0) {//次卡数为0
                _hadOnce = NO;//无次卡
            }else {
                _hadOnce = YES;//有次卡
            }
            
            if (onResponse) {
                onResponse(dict);
            }
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.2];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//收藏商品
- (void)collectWithclothingId:(NSString *)clothingId
             clothingStckType:(NSString *)clothingStckType
                   OnResponse:(void (^)(NSDictionary *dic))onResponse{
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    //商品ID,库存ID
//    NSString *url = [NSString stringWithFormat:@"%@?clothingId=%@&clothingStockId=%@",collect_Url,clothingId,clothingStckType];
    NSDictionary *d = @{@"clothingId":clothingId,@"clothingStockId":clothingStckType};
    
    [YKHttpClient Method:@"POST" URLString:collect_Url paramers:d success:^(NSDictionary *dict) {
        if ([dict[@"status"] integerValue] == 200) {
                        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"已添加至心愿单" delay:1.2];
            if (onResponse) {
                onResponse(dict);
            }
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:1.2];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//收藏列表
- (void)getCollectListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"GET" apiName:collectList_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

-(NSString*) removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}
//移除收藏
- (void)deleteCollecttwithShoppingCartId:(NSMutableArray *)shoppingCartIdList OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    NSDictionary *d = @{@"collectionList":shoppingCartIdList};
    NSString *s = [NSString stringWithFormat:@"%@?collectionList=",deCollect_Url];
    for (int i=0;i<shoppingCartIdList.count ; i++) {
      s =  [s stringByAppendingString:[NSString stringWithFormat:@"%@,",shoppingCartIdList[i]]];
    }
    s = [self removeLastOneChar:s];
    [YKHttpClient Method:@"GET" apiName:s Params:nil Completion:^(NSDictionary *dic) {

        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] intValue] == 200) {
            if (onResponse) {
                onResponse(dic);
            }
        }else{
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"message"] delay:1.4];
        }

        

    }];

}

- (void)CollecttwithShoppingCartId:(NSMutableArray *)shoppingCartIdList OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSDictionary *d = @{@"batchCartDTO":shoppingCartIdList};

    [YKHttpClient Method:@"POST" apiName:collectToCart_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] intValue] == 200) {
            if (onResponse) {
                onResponse(dic);
            }
        }else{
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"message"] delay:1.4];
        }
        
        
        
    }];
}

@end
