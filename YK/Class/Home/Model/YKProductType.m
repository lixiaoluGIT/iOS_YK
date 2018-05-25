//
//  YKProductType.m
//  YK
//
//  Created by LXL on 2018/1/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKProductType.h"

@implementation YKProductType

- (void)initWithDictionary:(NSDictionary *)dic{
    if (dic.allKeys.count>0) {
        _clothingId = dic[@"clothingId"];
        _clothingStockId = dic[@"clothingStockId"];
        _clothingStockNum = dic[@"clothingStockNum"];
        _clothingStockTotal = dic[@"clothingStockTotal"];
        _clothingStockType = dic[@"clothingStockType"];
        
        _isHadStock = [_clothingStockNum intValue]>0;
        
      
    }
//    [self setValuesForKeysWithDictionary:dic];
}
@end
