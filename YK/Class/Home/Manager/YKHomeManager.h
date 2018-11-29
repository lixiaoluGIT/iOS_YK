//
//  YKHomeManager.h
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKHomeManager : NSObject

@property (nonatomic,strong)NSMutableArray *brandList;//总数据
@property (nonatomic,strong)NSArray *sections;//分好组的数据源
@property (nonatomic,strong)NSArray *searchBtnArr;

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
- (void)getProductDetailInforWithProductId:(NSInteger )ProductId type:(NSInteger)type
                            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取品牌列表
- (void)getBrandListStatus:(NSInteger)status OnResponse:(void (^)(NSDictionary *dic))onResponse;

//请求更多商品
- (void)requestForMoreProductsWithNumPage:(NSInteger)numPage typeId:(NSString *)typeId sortId:(NSString *)sortId sytleId:(NSString *)sytleId brandId:(NSString *)brandId OnResponse:(void (^)(NSArray *array))onResponse;

//判断弹框是否弹出
- (void)showAleartViewToShare;

//衣库尺码表
- (NSArray *)getSizeArray:(NSArray *)array;

//得到用户尺码表
- (NSArray *)getUserSizeArray:(NSDictionary *)dic;

//弹框
- (void)showAleart;

//悬浮框
- (void)showPoint;

//TODO:接口应整合成一个，按分类id请求相应数据，而不是这样单独的接口,这样架构的接口真的懒得接，太小学生了

//请求搭配成套 || 时尚穿搭 || ...
- (void)getList:(NSInteger)page cid:(NSString *)cid OnResponse:(void (^)(NSArray *array))onResponse;

//请求时尚穿搭
//- (void)getFashionList:(NSInteger)page OnResponse:(void (^)(NSArray *array))onResponse;

//请求人气美衣和配饰

//请求首页新人优惠劵弹框图片
- (void)getHomeAleartImageOnResponse:(void (^)(NSDictionary *d))onResponse;

@end
