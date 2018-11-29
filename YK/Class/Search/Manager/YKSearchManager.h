//
//  YKSearchManager.h
//  YK
//
//  Created by LXL on 2017/12/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKSearchManager : NSObject

+ (YKSearchManager *)sharedManager;

//选衣界面
- (void)getSelectClothPageDataWithNum:(NSInteger)Num
                            Size:(NSInteger)Size
                      OnResponse:(void (^)(NSDictionary *dic))onResponse;

//筛选商品 品类ID,排序ID
- (void)filterClothWithclothingTypeId:(NSInteger)clothingTypeId
                          clothingSortId:(NSInteger)clothingSortId
                    OnResponse:(void (^)(NSDictionary *dic))onResponse;

//请求配饰列表
- (void)getPSListWithPage:(NSInteger)page Size:(NSInteger)size sid:(NSString *)sid OnResponse:(void (^)(NSDictionary *dic))onResponse;

//配饰详情
- (void)getPSDetailWithPSId:(NSString *)PSId UserId:(NSString *)userId OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取筛选标签数据
- (void)getFilterDataOnResponse:(void (^)(NSDictionary *dic))onResponse;

//筛选
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
                       OnResponse:(void (^)(NSDictionary *dic))onResponse;

@end
