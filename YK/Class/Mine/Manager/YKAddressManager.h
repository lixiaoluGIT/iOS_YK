//
//  YKAddressManager.h
//  YK
//
//  Created by LXL on 2017/12/5.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKAddress.h"

@interface YKAddressManager : NSObject

//@property (nonatomic,strong)YKAddress *address;
@property (nonatomic,strong)NSMutableArray *addressArray;//地址列表

+ (YKAddressManager *)sharedManager;

//添加地址
- (void)addAddressWithAddress:(YKAddress *)address
                    OnResponse:(void (^)(NSDictionary *dic))onResponse;
//获取地址列表
- (void)getAddressListOnResponse:(void (^)(NSDictionary *dic))onResponse;
//删除地址
- (void)deleteAddressWithAddress:(YKAddress *)address
                   OnResponse:(void (^)(NSDictionary *dic))onResponse;
//设为默认地址
- (void)setDetaultAddressWithAddress:(YKAddress *)address
                      OnResponse:(void (^)(NSDictionary *dic))onResponse;
//查询默认地址
- (void)queryDetaultAddressOnResponse:(void (^)(NSDictionary *dic))onResponse;
//更新地址
- (void)updateAddressWithAddress:(YKAddress *)address addressId:(NSString *)addressId OnResponse:(void (^)(NSDictionary *dic))onResponse;
@end
