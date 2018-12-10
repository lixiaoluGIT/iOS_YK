//
//  YKSearchManager.m
//  YK
//
//  Created by LXL on 2017/12/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSearchManager.h"

@implementation YKSearchManager

- (NSMutableArray *)childIds{
    if (!_childIds) {
        _childIds = [NSMutableArray array];
    }
    return _childIds;
}
- (NSMutableArray *)categorys{
    if (!_categorys) {
        _categorys  = [NSMutableArray array];
    }
    return  _categorys;
}
- (NSMutableArray *)times{
    if (!_times) {
        _times  = [NSMutableArray array];
    }
    return  _times;
}
- (NSMutableArray *)colors{
    if (!_colors) {
        _colors  = [NSMutableArray array];
    }
    return  _colors;
}
- (NSMutableArray *)styles{
    if (!_styles) {
        _styles  = [NSMutableArray array];
    }
    return  _styles;
}
- (NSMutableArray *)seasons{
    if (!_seasons) {
        _seasons  = [NSMutableArray array];
    }
    return  _seasons;
}
- (NSMutableArray *)elements{
    if (!_elements) {
        _elements  = [NSMutableArray array];
    }
    return  _elements;
}

+ (YKSearchManager *)sharedManager{
    static YKSearchManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//search page
- (void)getSelectClothPageDataWithNum:(NSInteger)Num Size:(NSInteger)Size
                      OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?num=1&size=%ld",selectClothPage_Url,Size];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
        
        
    }];
}

- (void)filterClothWithclothingTypeId:(NSInteger)clothingTypeId
                       clothingSortId:(NSInteger)clothingSortId
                           OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?clothingTypeId=%ld&clothingSortId=%ld",filterCloth_Url,clothingTypeId,clothingSortId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        if (array.count == 0) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"暂无相关商品" delay:1.2];
        }
        
        if (onResponse) {
            onResponse(dic);
        }
        
        
        
    }];
}

- (void)getPSListWithPage:(NSInteger)page Size:(NSInteger)size sid:(NSString *)sid OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url;
    if ([sid intValue] == 1 || [sid intValue] == 2) {//人气美衣
        url = [NSString stringWithFormat:@"%@?page=%ld&size=%ld&type=%@",@"/popularity/popularityClothingPage",page,size,sid];
    }else {
        url = [NSString stringWithFormat:@"%@?page=%ld&size=%ld",PSList_Url,page,size];
    }

    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (onResponse) {
            onResponse(dic);
        }
    }];
}

- (void)getPSDetailWithPSId:(NSString *)PSId UserId:(NSString *)userId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?ornamentId=%@&userId=%@",PSDetail_Url,PSId,userId];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (onResponse) {
            onResponse(dic);
        }
    }];
}

//获取筛选标签数据
- (void)getFilterDataOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
  [YKHttpClient Method:@"GET" apiName:filterData_Url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (onResponse) {
            onResponse(dic);
        }
    }];
}

- (void)filterDataWithCategoryIdList:(NSArray *)CategoryIdList
                        colourIdList:(NSArray *)colourIdList
                       elementIdList:(NSArray *)elementIdList
                         labelIdList:(NSArray *)labelIdList
                        seasonIdList:(NSArray *)seasonIdList
                         styleIdList:(NSArray *)styleIdList
                           updateDay:(NSString *)updateDay
                                page:(NSInteger )page
                                size:(NSInteger )size
                               exist:(NSString *)exist
                          OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
//    NSRange range = NSMakeRange(0,updateDay.length-2);
//    NSString *day;
//    if (updateDay.length>0) {
//        day = [updateDay substringWithRange:range];//截取范围类的字符串]
//    }else {
//        day = @"";
//    }
    if (page<=1) {
        [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    }
   
    NSInteger exi = [exist intValue];
    NSDictionary *postDic = @{@"categoryIdList":CategoryIdList,
                              @"colourIdList":colourIdList,
                              @"elementIdList":elementIdList,
                              @"labelIdList":labelIdList,
                              @"seasonIdList":seasonIdList,
                              @"styleIdList":styleIdList,
                              @"updateDay":updateDay,
                              @"page":@(page),
                              @"size":@(size),
                              @"exist":exist,
                              @"classify":@"0"
                              };
    
    [YKHttpClient Method:@"POST" URLString:filter_Url paramers:postDic success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
//            NSLog(@"RESPONSE:%@",dict);
                if (onResponse) {
                    onResponse(dict);
                }
    } failure:^(NSError *error) {
        
    }];
}

- (void)filterDataWithCategoryIdList:(NSArray *)CategoryIdList
                        colourIdList:(NSArray *)colourIdList
                       elementIdList:(NSArray *)elementIdList
                         labelIdList:(NSArray *)labelIdList
                        seasonIdList:(NSArray *)seasonIdList
                         styleIdList:(NSArray *)styleIdList
                           updateDay:(NSString *)updateDay
                                page:(NSInteger )page
                                size:(NSInteger )size
                               exist:(NSString *)exist
                      clothingIdList:(NSArray *)clothingIdList
                          OnResponse:(void (^)(NSDictionary *dic))onResponse;{

    if (page<=1) {
        [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    }
  

    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(page) forKey:@"page"];
     [dic setObject:@(size) forKey:@"size"];
     [dic setObject:@"0" forKey:@"exist"];
     [dic setObject:@"0" forKey:@"classify"];
     [dic setObject:clothingIdList forKey:@"clothingIdList"];
    
    [YKHttpClient Method:@"POST" URLString:filter_Url paramers:dic success:^(NSDictionary *dict) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (onResponse) {
            onResponse(dict);
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
