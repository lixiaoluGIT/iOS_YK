//
//  YKProductType.h
//  YK
//
//  Created by LXL on 2018/1/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

//商品不同型号的模型
@interface YKProductType : NSObject

@property (nonatomic,strong)NSString *clothingId;//商品ID
@property (nonatomic,strong)NSString *clothingStockId;//库存ID
@property (nonatomic,strong)NSString *clothingStockNum;//库存剩余数
@property (nonatomic,strong)NSString *clothingStockTotal;//库存总数
@property (nonatomic,strong)NSString *clothingStockType;//型号

@property (nonatomic,assign)BOOL isHadStock;//是否有库存状态

- (void)initWithDictionary:(NSDictionary *)dic;

@end
