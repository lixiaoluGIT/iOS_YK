//
//  YKProduct.m
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKProduct.h"
#import "YKProductType.h"

@implementation YKProduct

- (void)setClothingStockArray:(NSArray *)clothingStockArray{
    
}

- (void)initWithDic:(NSDictionary *)dic{
//    self.brandId = [NSString stringWithFormat:@"%@",dic[@"clothingBrandName"]];
    self.brandName = [NSString stringWithFormat:@"%@",dic[@"clothingBrandName"]];
//    self.catId = [NSString stringWithFormat:@"%@",dic[@"catId"]];
    self.goodsId  = [NSString stringWithFormat:@"%@",dic[@"clothingId"]];
    self.goodsName = [NSString stringWithFormat:@"%@",dic[@"clothingName"]];
    self.clothingStockId = [NSString stringWithFormat:@"%@",dic[@"clothingStockId"]];
    self.imageAttach  = [NSString stringWithFormat:@"%@",[self URLEncodedString:dic[@"clothingImgUrl"]]];
 
    self.clothingPrice = [NSString stringWithFormat:@"%@",dic[@"clothingPrice"]];
    if ( [[NSString stringWithFormat:@"%@",dic[@"classify"]] isEqual:@"1"]) {
        self.classify = 1;//衣服
    }
    if ( [[NSString stringWithFormat:@"%@",dic[@"classify"]] isEqual:@"2"]) {
        self.classify = 2;//配饰
    }
    
    
    //存储商品的不同型号模型
    NSArray *clothingStockArray = [NSArray arrayWithArray:dic[@"clothingStockDTOS"]];
    //遍历所有的型号
    for (NSDictionary *type in clothingStockArray) {
        if ([type[@"clothingStockNum"] intValue] != 0) {//如果有库存数量不为0的型号
            _isHadStock = YES;//有库存
        }
        //        }else {
        //            _isHadStock = NO;//无库存
        //        }
    }
    
    _collectionId = [NSString stringWithFormat:@"%@",dic[@"collectionId"]];
}
- (void)initWithDictionary:(NSDictionary *)dic{
    
    self.brandId = [NSString stringWithFormat:@"%@",dic[@"clothingBrandId"]];
    self.brandName = [NSString stringWithFormat:@"%@",dic[@"brandName"]];
    self.catId = [NSString stringWithFormat:@"%@",dic[@"catId"]];
    self.goodsId  = [NSString stringWithFormat:@"%@",dic[@"clothingId"]];
    self.goodsName = [NSString stringWithFormat:@"%@",dic[@"clothingName"]];
    self.goodsNo = [NSString stringWithFormat:@"%@",dic[@"goodsNo"]];
    self.imageAttach  = [NSString stringWithFormat:@"%@",[self URLEncodedString:dic[@"clothingImgUrl"]]];
    self.imageDetails = [NSString stringWithFormat:@"%@",dic[@"imageDetails"]];
    self.imageMaster = [NSString stringWithFormat:@"%@",dic[@"imageMaster"]];
    self.clothingPrice = [NSString stringWithFormat:@"%@",dic[@"clothingPrice"]];
    if ( [[NSString stringWithFormat:@"%@",dic[@"classify"]] isEqual:@"1"]) {
        self.classify = 1;//衣服
    }
    if ( [[NSString stringWithFormat:@"%@",dic[@"classify"]] isEqual:@"2"]) {
        self.classify = 2;//配饰
    }
   
    
    //存储商品的不同型号模型
    NSArray *clothingStockArray = [NSArray arrayWithArray:dic[@"clothingStockDTOS"]];
    //遍历所有的型号
    for (NSDictionary *type in clothingStockArray) {
        if ([type[@"clothingStockNum"] intValue] != 0) {//如果有库存数量不为0的型号
            _isHadStock = YES;//有库存
        }
//        }else {
//            _isHadStock = NO;//无库存
//        }
    }
    
    self.onLineTime = [NSString stringWithFormat:@"%@",dic[@"clothingCreatedate"]];
    
    //判断上新时间是否在48小时内
    [self formateDate:self.onLineTime];
    
    //明星同款
//    _isStarSame = [dic[@"starSameStyle"] intValue];
    NSString *s = [NSString stringWithFormat:@"%@",dic[@"starSameStyle"]];
    
    if ([s intValue] == 1){
        _isStarSame = YES;
    }else {
        _isStarSame = NO;
    }

    //占衣位数
    _OwenNum = [NSString stringWithFormat:@"%@",dic[@"occupySeat"]];
    
    
}

- (void)formateDate:(NSString *)dateString
{
   
    NSDate * nowDate = [NSDate date];
    NSTimeInterval interval    =[dateString doubleValue] / 1000.0;
    NSDate *needFormatDate               = [NSDate dateWithTimeIntervalSince1970:interval];
    /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
//    NSLog(@"hahhahhahahhahahha%@",needFormatDate);
    if (time<24*60*60*2) {
        self.isNew = YES;
    }else {
        self.isNew = NO;
    }

}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
- (void)setProductDetail:(YKProductDetail *)productDetail{
    _productDetail = productDetail;
    
    _bannerImages = [NSMutableArray arrayWithArray:productDetail.bannerImages];
    _product = [NSDictionary dictionaryWithDictionary:productDetail.product];
    _brand = [NSDictionary dictionaryWithDictionary:productDetail.brand];
    _pruductDetailImgs = [NSMutableArray arrayWithArray:productDetail.pruductDetailImgs];
    _productList = [NSMutableArray arrayWithArray:productDetail.productList];
    _isInCollectionFolder = productDetail.isInCollectionFolder;
    _occupiedClothes = productDetail.occupiedClothes;
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
    
    //是否收藏
    self.isInCollectionFolder = [NSString stringWithFormat:@"%@",dic[@"data"][@"isInCollectionFolder"]];
    
    //商品总数量
    self.occupiedClothes = [NSString stringWithFormat:@"%@",dic[@"data"][@"occupiedClothes"]];
}

@end
