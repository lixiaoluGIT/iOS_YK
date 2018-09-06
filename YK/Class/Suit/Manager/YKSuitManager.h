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
@property (nonatomic,assign)NSInteger suitAccount;//商品数量
@property (nonatomic,strong)NSMutableArray *suitArray;//所选的商品数据
@property (nonatomic,assign)BOOL isHadCC;//是否有加衣劵
@property (nonatomic,strong)NSString *addClothingId;//加衣劵id
@property (nonatomic,assign)BOOL isUseCC;//是否使用加衣劵

+ (YKSuitManager *)sharedManager;

//添加到购物车
- (void)addToShoppingCartwithclothingId:(NSString *)clothingId
                            clothingStckType:(NSString *)clothingStckType
                      OnResponse:(void (^)(NSDictionary *dic))onResponse;
//购物车列表
- (void)getShoppingListOnResponse:(void (^)(NSDictionary *dic))onResponse;

//从购物车删除
- (void)deleteFromShoppingCartwithShoppingCartId:(NSMutableArray *)shoppingCartIdList OnResponse:(void (^)(NSDictionary *dic))onResponse;

//选中商品
- (void)selectCurrentPruduct:(YKSuit *)suit;

//取消选中商品
- (void)cancelSelectCurrentPruduct:(YKSuit *)suit;

//提交商品订单
- (void)postOrderwithSuits:(NSArray *)suits
                                  OnResponse:(void (^)(NSDictionary *dic))onResponse;

//查询用户加衣劵
- (void)searchAddCCOnResponse:(void (^)(NSDictionary *dic))onResponse;

//清除缓存
- (void)clear;

@end
