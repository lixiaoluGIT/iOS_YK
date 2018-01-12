//
//  steyHelper.h
//  STEY
//
//  Created by LXL on 17/10/31.
//  Copyright © 2017年 beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface steyHelper : NSObject

//判断手机号是否合法
+ (BOOL)isValidatePhone:(NSString *)phoneNumber;
//判断邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)email;
//判断身份证号是否有效
+ (BOOL)isValidateIDNumber:(NSString *)IDNumber;
//隐藏手机号中间四位
+(NSString *)hidePhoneNum:(NSString *)searchStr;
//获取当前时区时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
//date转string
+(NSString*)dateToStr:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date next:(NSInteger)next;
+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
+(NSDate *)stringTodate:(NSString *)str;
+ (NSInteger)hour:(NSDate *)date;
+ (NSInteger)min:(NSDate *)date;
//日期对应星期
+(NSString *)dateToWeek:(NSDate*)senddate;
//+(BOOL)ifequal:(NSDate *)date;
+(NSInteger)stringToInteger:(NSString *)week;
+(NSInteger)piancha:(NSDate *)lastDate current:(NSDate *)cureDate;
+(NSInteger)pianchaToNow:(NSDate *)lastDate;

+ (NSString*) mk_urlEncodedString;
@end
