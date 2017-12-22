//
//  LogisticsInfo.h
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsInfo : NSObject

@property(nonatomic,copy) NSString *acceptTime;//时间
@property(nonatomic,copy) NSString *acceptAddress;//地址
@property(nonatomic,copy) NSString *remark;//描述

-(instancetype) initWithDict:(NSDictionary *)dict;

+(instancetype) logisticsWithDict:(NSDictionary *)dict;

@end
