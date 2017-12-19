//
//  YKProduct.m
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKProduct.h"

@implementation YKProduct

- (void)initWithDictionary:(NSDictionary *)dic{
    
    self.brandId = [NSString stringWithFormat:@"%@",dic[@"clothingBrandId"]];
    self.brandName = [NSString stringWithFormat:@"%@",dic[@"brandName"]];
    self.catId = [NSString stringWithFormat:@"%@",dic[@"catId"]];
    self.goodsId  = [NSString stringWithFormat:@"%@",dic[@"clothingId"]];
    self.goodsName = [NSString stringWithFormat:@"%@",dic[@"clothingName"]];
    self.goodsNo = [NSString stringWithFormat:@"%@",dic[@"goodsNo"]];
    self.imageAttach  = [NSString stringWithFormat:@"%@",dic[@"clothingImgUrl"]];
    self.imageDetails = [NSString stringWithFormat:@"%@",dic[@"imageDetails"]];
    self.imageMaster = [NSString stringWithFormat:@"%@",dic[@"imageMaster"]];
    self.clothingPrice = [NSString stringWithFormat:@"%@",dic[@"clothingPrice"]];
}

- (void)setProductDetail:(YKProductDetail *)productDetail{
    _productDetail = productDetail;
    
    _bannerImages = [NSMutableArray arrayWithArray:productDetail.bannerImages];
    _product = [NSDictionary dictionaryWithDictionary:productDetail.product];
    _brand = [NSDictionary dictionaryWithDictionary:productDetail.brand];
    _pruductDetailImgs = [NSMutableArray arrayWithArray:productDetail.pruductDetailImgs];
    _productList = [NSMutableArray arrayWithArray:productDetail.productList];
}



@end

@implementation YKProductDetail

- (void)setBannerImages:(NSMutableArray *)bannerImages{
    _bannerImages = bannerImages;
}

- (void)setProduct:(NSDictionary *)product{
    _product = product;
}

- (void)setBrand:(NSDictionary *)brand{
    _brand = brand;
}

- (void)setPruductDetailImgs:(NSMutableArray *)pruductDetailImgs{
    _pruductDetailImgs = pruductDetailImgs;
}

- (void)setProductList:(NSMutableArray *)productList{
    _productList = productList;
}

- (void)initWithDictionary:(NSDictionary *)dic{
    
    //banner图
    self.bannerImages = dic[@"data"][@"clothingBannerImg"];
    //商品信息
    self.product = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"clothingDetail"]];
    //品牌信息
    self.brand = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"brandDetail"]];
    //详情图
    self.pruductDetailImgs = [NSMutableArray arrayWithArray:dic[@"data"][@"clothingDetailImg"]];
    //相关推荐
    self.productList = [NSMutableArray arrayWithArray:dic[@"data"][@"productList"]];
}

@end
