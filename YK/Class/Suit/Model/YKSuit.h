//
//  YKSuit.h
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKSuit : NSObject

@property (nonatomic,strong)NSString *clothingStockNum;//库存数量
@property (nonatomic,copy)NSString *shoppingCartId;//购物车Id
@property (nonatomic,copy)NSString *clothingId;//商品Id
@property (nonatomic,copy)NSString *clothingName;//商品名
@property (nonatomic,copy)NSString *clothingExplain;//商品描述
@property (nonatomic,copy)NSString *clothingPrice;//商品价钱
@property (nonatomic,copy)NSString *clothingBrandName;//品牌名称
@property (nonatomic,strong)NSString *clothingStockId;//商品库存Id
@property (nonatomic,strong)NSString *clothingStockType;//商品型号(X,XL..)
@property (nonatomic,strong)NSString *clothingImgUrl;//商品图标
@property (nonatomic,assign)NSInteger classify;


- (void)initWithDictionary:(NSDictionary *)dic;

@end
