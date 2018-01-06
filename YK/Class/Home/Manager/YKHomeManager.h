//
//  YKHomeManager.h
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKHomeManager : NSObject

+ (YKHomeManager *)sharedManager;

//获取首页数据
- (void)getMyHomePageDataWithNum:(NSInteger)Num
                            Size:(NSInteger)Size
                      OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取品牌详情
- (void)getBrandDetailInforWithBrandId:(NSInteger )brandId
                            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//品牌详情页根据类目查找相关商品
- (void)getBrandPageByCategoryWithBrandId:(NSString *)brandId categoryId:(NSString *)categoryId OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取商品详情
- (void)getProductDetailInforWithProductId:(NSInteger )ProductId
                            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取品牌列表
- (void)getBrandListOnResponse:(void (^)(NSDictionary *dic))onResponse;

//请求更多商品
- (void)requestForMoreProductsWithNumPage:(NSInteger)numPage typeId:(NSString *)typeId sortId:(NSString *)sortId brandId:(NSString *)brandId OnResponse:(void (^)(NSArray *array))onResponse;

//判断弹框是否弹出
- (void)showAleartViewToShare;

@end
