//
//  LogisticsInfo.m
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import "LogisticsInfo.h"

@implementation LogisticsInfo

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dict];
        self.acceptTime = dict[@"acceptTime"];//时间
        self.acceptAddress = dict[@"acceptAddress"];//地址
        self.remark = dict[@"remark"];//描述
    }
    return self;
}

+(instancetype)logisticsWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
