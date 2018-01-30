//
//  NSString+FD.m
//  fuaidai
//
//  Created by 杨云 on 15/7/2.
//  Copyright (c) 2015年 bcjm. All rights reserved.
//
#import "pinyin.h"

#import "NSString+FD.h"
//#import "NSData+FD.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

@implementation NSString (FD)
//
////把时间戳字符串转化位时间
- (NSDate*)toDateFromDataString
{
    long long t =[self longLongValue];
    NSDate *sendDate = [[NSDate alloc]initWithTimeIntervalSince1970:t];
    return sendDate;
}
//
////取得docment文件夹存放地址
//+ (NSString*)docmentFilePathWithFileName:(NSString*)fileName
//{
//    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
//}
//
////是否为空
//- (BOOL)validateEmpty
//{
//    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (str.length == 0 || str == nil)
//    {
//        return YES;
//    }
//    return NO;
//}
//
////手机号码验证
//+ (BOOL) validateMobile:(NSString *)mobile
//{
//    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}
////身份证号
//+ (BOOL) validateIdentityCard: (NSString *)identityCard
//{
//    BOOL flag;
//    if (identityCard.length <= 0)
//    {
//        flag = NO;
//        return flag;
//    }
//    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
//    return [identityCardPredicate evaluateWithObject:identityCard];
//}
////是否为正整数
//+ (BOOL)validatePositiveInteger:(NSString*)str
//{
//    NSString *passWordRegex = @"^[1-9]\\d*$";
//    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
//    return [passWordPredicate evaluateWithObject:str];
//}
//
//#define DES_KEY @"HALMA*76" //des加密解密的密匙
////密码的加密解密
//-(NSString *)desEncrypt
//{
//    return [self doCipher:self key:DES_KEY context:kCCEncrypt];
//}
//
//-(NSString *)desDecrypt
//{
//    return [self doCipher:self key:DES_KEY context:kCCDecrypt];
//}
//
//-(NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt
//{
//    
//    NSMutableData * dTextIn=nil;
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        dTextIn = (NSMutableData*)[[sTextIn dataUsingEncoding:NSUTF8StringEncoding] base64Decoded];
//    }
//    else
//    {
//        dTextIn = [[sTextIn dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
//    }
//    NSMutableData * dKey = [[sKey dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
//    [dKey setLength:kCCBlockSizeDES];
//    uint8_t *bufferPtr1 = NULL;
//    size_t bufferPtrSize1 = 0;
//    size_t movedBytes1 = 0;
//    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
//    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
//    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
//    CCCrypt(encryptOrDecrypt, // CCOperation op
//            kCCAlgorithmDES, // CCAlgorithm alg
//            kCCOptionPKCS7Padding, // CCOptions options
//            [dKey bytes], // const void *key
//            [dKey length], // size_t keyLength
//            [dKey bytes], // const void *iv
//            [dTextIn bytes], // const void *dataIn
//            [dTextIn length],  // size_t dataInLength
//            (void *)bufferPtr1, // void *dataOut
//            bufferPtrSize1,     // size_t dataOutAvailable
//            &movedBytes1);      // size_t *dataOutMoved
//    
//    NSString * sResult=nil;
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        sResult = [[ NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1 length:movedBytes1] encoding:NSUTF8StringEncoding];
//    }
//    else
//    {
//        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
//        sResult = [dResult base64Encoded];
//    }
//    free(bufferPtr1);
//    return sResult;
//}

- (NSString*) mk_urlEncodedString
{ // mk_ prefix prevents a clash with a private api
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) self,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    
    if(!encodedString)
        encodedString = @"";
    
    return encodedString;
}
//取得Cache文件夹存放地址
+ (NSString*)cacheFilePathWithFileName:(NSString*)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];      
}
/**
 * 格式化时间戳(秒),如几分钟前
 */
+ (NSString *)formatDateStr:(NSTimeInterval)ti
{
    @try
    {
        NSString *formate = @"yyyy-MM-dd HH:mm:ss";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        
        NSDate *nowDate = [NSDate date];
        
        NSDate *needFormatDate = [NSDate dateWithTimeIntervalSince1970:ti];
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        NSString *dateStr = @"";
        
        if (time <= 60) {
            // 1分钟以内的
            dateStr = @"刚刚";
        } else if (time <= 60*60) {
            // 一个小时以内的
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前", mins];
        } else if (time <= 60*60*24) {
            // 在两天内的
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                // 在同一天
                dateStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:needFormatDate]];
            } else {
                // 昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:needFormatDate]];
            }
        } else if (time <= 60*60*24*30) {
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            dateStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:needFormatDate]];
        } else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                // 在同一年
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            } else {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception)
    {
        return @"";
    }
}
//获取字符串的拼音
- (NSString *)phonetic
{
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

//根据输入的NSString 取得首字母 （中文为拼音首字母）
+ (NSString*)getInitialsFromString:(NSString*)string
{
    NSString *str = @"";
    if(string != nil && string.length > 0)
    {
        str = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])]uppercaseString];
        NSString *userNameRegex = @"^[A-Z]$";
        NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
        BOOL B = [userNamePredicate evaluateWithObject:str];
        if (B)
        {
            return str;
        }
        else
        {
            return @"#";
        }
        
    }
    else
    {
        return @"#";
    }
}

@end
