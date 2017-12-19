//
//  YKSuitManager.h
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKSuit.h"

@interface YKSuitManager : NSObject
@property (nonatomic,assign)NSInteger suitAccount;
@property (nonatomic,strong)NSMutableArray *suitArray;//所选的商品数据

+ (YKSuitManager *)sharedManager;

//添加到购物车
- (void)addToShoppingCartwithclothingId:(NSString *)clothingId
                            clothingStckType:(NSString *)clothingStckType
                      OnResponse:(void (^)(NSDictionary *dic))onResponse;
//购物车列表
- (void)getShoppingListOnResponse:(void (^)(NSDictionary *dic))onResponse;

//从购物车删除
- (void)deleteFromShoppingCartwithclothingId:(NSString *)clothingId
                                  OnResponse:(void (^)(NSDictionary *dic))onResponse;
//选中商品
- (void)selectCurrentPruduct:(YKSuit *)suit;

//取消选中商品
- (void)cancelSelectCurrentPruduct:(YKSuit *)suit;

//提交商品订单
- (void)postOrderwithSuits:(NSArray *)suits
                                  OnResponse:(void (^)(NSDictionary *dic))onResponse;

@end
