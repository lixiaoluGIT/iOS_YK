//
//  YKPayManager.h
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//
typedef enum : NSInteger {
    AlIPAY = 1,//支付宝支付
    WXPAY = 2,//微信支付
}payMethod;

typedef enum : NSInteger {
    DEPOSIT = 0,//押金充值
    MONTH_CARD = 1,//月卡
    SEASON_CARD = 2,//季卡
    YEAR_CARD = 3,//年卡
}payType;

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Product.h"
#import "Order.h"
#import "DataSigner.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "payRequsestHandler.h"

@interface YKPayManager : NSObject

//支付调用(阿里和微信)
- (void)payWithPayMethod:(NSInteger )payMethod payType:(NSInteger )paytype
                   OnResponse:(void (^)(NSDictionary *dic))onResponse;

+ (YKPayManager *)sharedManager;

//申请退押金
- (void)refondDepositOnResponse:(void (^)(NSDictionary *dic))onResponse;
//押金退还
- (void)returnDepositOnResponse:(void (^)(NSDictionary *dic))onResponse;
//钱包界面
- (void)getWalletPageOnResponse:(void (^)(NSDictionary *dic))onResponse;
//明细界面
- (void)getWalletDetailPageOnResponse:(void (^)(NSDictionary *dic))onResponse;
//更新会员信息
- (void)updateVIPInforPageOnResponse:(void (^)(NSDictionary *dic))onResponse;

@end
