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
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)logisticsWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
