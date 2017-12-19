//
//  YKUser.h
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKUser : NSObject

@property (nonatomic,strong)NSString *userId;//用户Id
@property (nonatomic,strong)NSString *nickname;//用户昵称
@property (nonatomic,strong)NSString *photo;//用户头像url
@property (nonatomic,strong)NSString *gender;//用户性别
@property (nonatomic,strong)NSString *phone;//用户手机号
@property (nonatomic,strong)NSString *isVIP;//是否是会员用户
@property (nonatomic,strong)NSString *VIPDay;//会员剩余天数

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
