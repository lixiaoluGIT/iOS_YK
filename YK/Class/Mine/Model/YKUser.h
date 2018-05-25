//
//  YKUser.h
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKUser : NSObject

//用户信息

@property (nonatomic,strong)NSString *rongToken;//融云token
@property (nonatomic,strong)NSString *userId;//用户Id
@property (nonatomic,strong)NSString *nickname;//用户昵称
@property (nonatomic,strong)NSString *photo;//用户头像url
@property (nonatomic,strong)NSString *gender;//用户性别
@property (nonatomic,strong)NSString *phone;//用户手机号
//会员卡押金信息
@property (nonatomic,strong)NSString *cardNum;//会员卡号
@property (nonatomic,strong)NSString *cardType;//会员卡类型 0季卡1月卡2年卡
@property (nonatomic,strong)NSString *depositEffective;//押金状态 0>未交,不是VIP,1>有效,2>退还中,3>无效
@property (nonatomic,strong)NSString *effective;//会员卡状态 1>使用中,2>已过期,3>无押金,4>未开通
@property (nonatomic,strong)NSString *validity;//会员剩余天数
@property (nonatomic,strong)NSString *isShare;//是否分享过 (0,1)
@property (nonatomic,strong)NSString *inviteCode;//我的邀请码
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
