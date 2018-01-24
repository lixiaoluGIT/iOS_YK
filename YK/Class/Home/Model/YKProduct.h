//
//  YKProduct.h
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKProduct.h"

@class YKProductDetail;
//商品
@interface YKProduct : NSObject

@property (nonatomic,strong)YKProductDetail *productDetail;

@property (nonatomic,copy)NSString *brandId;//品牌ID
@property (nonatomic,copy)NSString *brandName;//品牌名
@property (nonatomic,copy)NSString *catId;//类目(所属类)
@property (nonatomic,copy)NSString *goodsId;//商品ID
@property (nonatomic,copy)NSString *goodsName;//商品名
@property (nonatomic,copy)NSString *goodsNo;;//商品编号
@property (nonatomic,copy)NSString *imageAttach;
@property (nonatomic,copy)NSString *imageDetails;
@property (nonatomic,copy)NSString *imageMaster;
@property (nonatomic,copy)NSString *clothingPrice;//推荐价格

@property (nonatomic,assign)BOOL isHadStock;//有无库存

//

@property (nonatomic,strong)NSMutableArray *bannerImages;//轮播图
@property (nonatomic,strong)NSDictionary *product;//商品信息和库存
@property (nonatomic,strong)NSDictionary *brand;//品牌信息
@property (nonatomic,strong)NSMutableArray *pruductDetailImgs;//详情图
@property (nonatomic,strong)NSMutableArray *productList;//相关推荐

- (void)initWithDictionary:(NSDictionary *)dic;

@end

//商品详情
@interface YKProductDetail : NSObject
@property (nonatomic,strong)NSMutableArray *bannerImages;//轮播图
@property (nonatomic,strong)NSDictionary *product;//商品信息和库存
@property (nonatomic,strong)NSDictionary *brand;//品牌信息
@property (nonatomic,strong)NSMutableArray *pruductDetailImgs;//详情图
@property (nonatomic,strong)NSMutableArray *productList;//相关推荐

- (void)initWithDictionary:(NSDictionary *)dic;
@end
