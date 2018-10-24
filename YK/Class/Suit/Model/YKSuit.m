//
//  YKSuit.m
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuit.h"

@implementation YKSuit

- (void)initWithDictionary:(NSDictionary *)dic{
    
    if (dic[@"clothingId"]) {
        _clothingId= [NSString stringWithFormat:@"%@",dic[@"clothingId"]];
    }
//    if (dic[@"clothingStockNum"]) {
//        _clothingStockNum= [NSString stringWithFormat:@"%@",dic[@"clothingStockNum"]];
//    }
   
    if (dic[@"clothingStockNum"] != [NSNull null] && dic[@"clothingStockNum"]!=nil) {
        _clothingStockNum = [NSString stringWithFormat:@"%@",dic[@"clothingStockNum"]];
    }else {
        //解决衣袋和心愿单字段不一样的问题
        _clothingStockNum = [NSString stringWithFormat:@"%@",dic[@"stockNumber"]];
    }
    
    if (dic[@"shoppingCartId"] != [NSNull null]) {
        _shoppingCartId = [NSString stringWithFormat:@"%@",dic[@"shoppingCartId"]];
    }
   
    if (dic[@"clothingId"] != [NSNull null]) {
        _clothingId = [NSString stringWithFormat:@"%@",dic[@"clothingId"]];
    }

    if (dic[@"clothingName"] != [NSNull null]) {
        _clothingName = [NSString stringWithFormat:@"%@",dic[@"clothingName"]];
    }
    
    if (dic[@"clothingExplain"] != [NSNull null]) {
        _clothingExplain = [NSString stringWithFormat:@"%@",dic[@"clothingExplain"]];
    }
    
    if (dic[@"clothingPrice"] != [NSNull null]) {
        _clothingPrice = [NSString stringWithFormat:@"%@",dic[@"clothingPrice"]];
    }
   
    if (dic[@"clothingBrandName"] != [NSNull null]) {
        _clothingBrandName = [NSString stringWithFormat:@"%@",dic[@"clothingBrandName"]];
    }
    
    if (dic[@"clothingStockId"] != [NSNull null]) {
        _clothingStockId = [NSString stringWithFormat:@"%@",dic[@"clothingStockId"]];
    }
    
    if (dic[@"clothingStockType"] != [NSNull null] && dic[@"clothingStockType"]!=nil) {
        _clothingStockType = [NSString stringWithFormat:@"%@",dic[@"clothingStockType"]];
    }else {
        //解决衣袋和心愿单字段不一样的问题
        _clothingStockType = [NSString stringWithFormat:@"%@",dic[@"stockType"]];
    }

    if (dic[@"clothingImgUrl"] != [NSNull null]) {
        _clothingImgUrl = [NSString stringWithFormat:@"%@",dic[@"clothingImgUrl"]];
    }
    
    if (dic[@"classify"] != [NSNull null]) {
        if ( [[NSString stringWithFormat:@"%@",dic[@"classify"]] isEqual:@"1"]) {
            self.classify = 1;//衣服
        }
        if ( [[NSString stringWithFormat:@"%@",dic[@"classify"]] isEqual:@"2"]) {
            self.classify = 2;//配饰
        }
    }
    //商品所占衣位数
    if (dic[@"ownedNum"] != [NSNull null]) {
        
        self.ownedNum = dic[@"occupySeat"];//衣服
    }
    
    //收藏id
    if (dic[@"collectionId"] != [NSNull null]) {
        
        self.collectId = dic[@"collectionId"];//衣服
    }

}

@end
