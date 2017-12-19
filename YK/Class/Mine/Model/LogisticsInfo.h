//
//  LogisticsInfo.h
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsInfo : NSObject

@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *info;

-(instancetype) initWithDict:(NSDictionary *)dict;

+(instancetype) logisticsWithDict:(NSDictionary *)dict;

@end
