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
    if (dic[@"clothingStockNum"]) {
        _clothingStockNum= [NSString stringWithFormat:@"%@",dic[@"clothingStockNum"]];
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
    
    if (dic[@"clothingStockType"] != [NSNull null]) {
        _clothingStockType = [NSString stringWithFormat:@"%@",dic[@"clothingStockType"]];
    }

    if (dic[@"clothingImgUrl"] != [NSNull null]) {
        _clothingImgUrl = [NSString stringWithFormat:@"%@",dic[@"clothingImgUrl"]];
    }
}

@end
