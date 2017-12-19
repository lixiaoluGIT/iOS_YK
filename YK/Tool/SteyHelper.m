//
//  steyHelper.m
//  STEY
//
//  Created by LXL on 17/10/31.
//  Copyright © 2017年 beyondsoft. All rights reserved.
//

#import "steyHelper.h"

@implementation steyHelper
#pragma mark 判断手机号是否合法
+ (BOOL)isValidatePhone:(NSString *)phoneNumber{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    if (!isMatch){
        return NO;
    }
    return YES;
}

#pragma mark 判断邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 判断身份证号是否合法
+ (BOOL)isValidateIDNumber:(NSString *)IDNumber
{
    if (IDNumber.length!=18) {
        return NO;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:IDNumber];
    
    if (!flag) {
        return flag;
    }else {
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[IDNumber substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        NSInteger idCardMod=idCardWiSum%11;
        
        NSString * idCardLast= [IDNumber substringWithRange:NSMakeRange(17, 1)];
        
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
}



+(NSString *)dateToWeek:(NSDate*)senddate{
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyy"];
    [dateformatter setDateFormat:@"MM"];
    [dateformatter setDateFormat:@"dd"];
    [dateformatter setDateFormat:@"EEE"];
    
    NSString *  weekString = [dateformatter stringFromDate:senddate];
    return weekString;
}


+(NSInteger)stringToInteger:(NSString *)week{
    
    NSString *sub = [week substringWithRange:NSMakeRange(1, 1)];
    NSInteger weekNum = 0 ;
    
    if ([sub isEqualToString:@"一"]) {
        weekNum = 1;
    }
    if ([sub isEqualToString:@"二"]) {
        weekNum = 2;
    }
    if ([sub isEqualToString:@"三"]) {
        weekNum = 3;
    }
    if ([sub isEqualToString:@"四"]) {
        weekNum = 4;
    }
    if ([sub isEqualToString:@"五"]) {
        weekNum = 5;
    }
    if ([sub isEqualToString:@"六"]) {
        weekNum = 6;
    }
    if ([sub isEqualToString:@"日"]) {
        weekNum = 7;
    }
    
    return weekNum;
}

+(NSString *)hidePhoneNum:(NSString *)searchStr{
    
    NSString * regExpStr = @"[0-9A-Z].";
    NSString * replacement = @"**";
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSString *resultStr = searchStr;
    // 替换匹配的字符串为 searchStr
    resultStr = [regExp stringByReplacingMatchesInString:searchStr
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(4,5)
                                            withTemplate:replacement];
    
    return resultStr;
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    
    return destinationDateNow;
}


+(NSInteger)piancha:(NSDate *)lastDate current:(NSDate *)cureDate{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval start = [lastDate timeIntervalSince1970]*1;
    NSTimeInterval end = [cureDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value /60;//秒
    
    return second;
}


+(NSInteger)pianchaToNow:(NSDate *)lastDate{
    return  [self piancha:lastDate current:[self getNowDateFromatAnDate:[NSDate date]]];
}

+(NSString*)dateToStr:(NSDate *)date{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* s1 = [df stringFromDate:date];
    return s1;
}

+(NSDate *)stringTodate:(NSString *)str{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";//指定转date得日期格式化形式
    return  [self getNowDateFromatAnDate:[dateFormatter dateFromString:str]];
}

+ (NSDate*)nextMonth:(NSDate *)date next:(NSInteger)next{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +next;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


+ (NSInteger)day:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


+ (NSInteger)month:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

+ (NSInteger)year:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

+ (NSInteger)hour:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    return [components hour];
}

+ (NSInteger)min:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    return [components minute];
}

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

@end
