//
//  YKOrderManager.h
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#define receiveSection @"0"
#define backSection @"1"
#define hadBackSection @"2"

typedef enum : NSInteger {
    totalBag = 0,//全部
    toReceive = 2,//待签收
    toBack = 3,//待归还
    hadBack = 5,//已归还
}suitBagStatus;

#import <Foundation/Foundation.h>

@interface YKOrderManager : NSObject

@property (nonatomic,strong)NSMutableArray *totalOrderList;//全部衣袋的数据源(数组套数组结构)
@property (nonatomic,strong)NSMutableArray *sectionArray;//存储有哪几组数据(0:待签收;1:待归还;2:已归还)
@property (nonatomic,strong)NSString *orderNo;//订单号:(待签收,待归还只有一种)
@property (nonatomic,strong)NSString *ID;//订单ID
@property (nonatomic,strong)NSString *SMSStatus;//物流状态

+ (YKOrderManager *)sharedManager;

//提交订单
- (void)releaseOrderWithAddress:(YKAddress *)address
                       shoppingCartIdList:(NSMutableArray *)shoppingCartIdList
                             OnResponse:(void (^)(NSDictionary *dic))onResponse;

/*!
 查询订单
 订单状态码
 0 - 全部 1 - 待发货 2 - 待签收 3 - 待归还 4 - 质检中 41 - 通过 42 - 未通过 5 - 已归还 6 - 已取  7 - 已删除
 */
- (void)searchOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSMutableArray *array))onResponse;

//查询物流信息
- (void)searchForSMSInforWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSArray *array))onResponse;

//确认收货
- (void)ensureReceiveWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse;

//预约归还
- (void)orderReceiveWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse;


- (void)clear;
@end
