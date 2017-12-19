//
//  YKAddress.h
//  YK
//
//  Created by LXL on 2017/12/5.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKAddress : NSObject

@property (nonatomic,strong)NSString *name;//收货人姓名
@property (nonatomic,strong)NSString *phone;//收货人电话
@property (nonatomic,strong)NSString *zone;//省市区
@property (nonatomic,strong)NSString *detail;//街道地址
@property (nonatomic,assign)NSString *isDefaultAddress;//是否是默认地址
@property (nonatomic,strong)NSString *addressId;

- (void)ininWithDictionary:(NSDictionary *)Dic;

@end
