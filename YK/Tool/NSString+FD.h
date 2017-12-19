//
//  NSString+FD.h
//  fuaidai
//
//  Created by 杨云 on 15/7/2.
//  Copyright (c) 2015年 bcjm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FD)
//把时间戳字符串转化位时间
- (NSDate*)toDateFromDataString;
//取得docment文件夹存放地址
+ (NSString*)docmentFilePathWithFileName:(NSString*)fileName;
//是否为空
- (BOOL)validateEmpty;
//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//是否为正整数
+ (BOOL)validatePositiveInteger:(NSString*)str;
//密码的加密解密
-(NSString *)desEncrypt;
-(NSString *)desDecrypt;

- (NSString*) mk_urlEncodedString;

//取得Cache文件夹存放地址
+ (NSString*)cacheFilePathWithFileName:(NSString*)fileName;

- (NSString *) md5;

/**
 * 格式化时间戳(秒),如几分钟前
 */
+ (NSString *)formatDateStr:(NSTimeInterval)ti;

//根据输入的NSString 取得首字母 （中文为拼音首字母）
+ (NSString*)getInitialsFromString:(NSString*)string;
//获取字符串的拼音
- (NSString *)phonetic;
@end
