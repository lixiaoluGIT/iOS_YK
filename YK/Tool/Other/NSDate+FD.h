//
//  UIDate+FD.h
//  fuaidai
//
//  Created by 杨云 on 15/7/14.
//  Copyright (c) 2015年 bcjm. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface NSDate (FD)

+ (NSString*)getmmssFromSecond:(float)time;
- (NSString*)toStringYMDHM;
//2015-09-18
- (NSString*)toStringYMD;
- (NSString*)toStringGCTime;
- (NSString*)toStringYRTime;
//20150918
- (NSString*)toStringYMDWithNull;
//2015年9月22日
- (NSString*)toStringYMDWithWord;
//2015年9月
- (NSString*)toStringYMWithWord;
//取得毫秒字符串
- (NSString*)getSecondCount;
//判断是否是今天
+ (BOOL)isCurrentDay:(NSDate *)aDate;
//去处农历显示文本
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date;

//输出可读的时间字符串
- (NSString*)toStringMessage;

- (NSString*)toStringNSTimeInterval;

//输出可读的时间字符串 《预约时间》
- (NSString*)toStringWithReserve;

@end
