//
//  UIDate+FD.m
//  fuaidai
//
//  Created by 杨云 on 15/7/14.
//  Copyright (c) 2015年 bcjm. All rights reserved.
//

#import "NSDate+FD.h"

@implementation NSDate (FD)

+ (NSString*)getmmssFromSecond:(float)time
{
    int i = (int)time;
    return [NSString stringWithFormat:@"%02d:%02d",i/60,i%60];
}
- (NSString*)toStringYMDHM
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormat stringFromDate:self];
}
- (NSString*)toStringYMD
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:self];
}
- (NSString*)toStringYMDWithNull
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    return [dateFormat stringFromDate:self];
}
//2015年9月22日
- (NSString*)toStringYMDWithWord
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年M月d日"];
    return [dateFormat stringFromDate:self];
}
//2015年9月
- (NSString*)toStringYMWithWord
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年M月"];
    return [dateFormat stringFromDate:self];
}
- (NSString*)toStringGCTime
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM月dd日 EEEE HH:mm"];
    return [dateFormat stringFromDate:self];
}
- (NSString*)toStringYRTime
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM月dd日 HH:mm"];
    return [dateFormat stringFromDate:self];
}
- (NSString*)getSecondCount
{
    double d = [self timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",d*1000];
}

//判断是否是今天
+ (BOOL)isCurrentDay:(NSDate *)aDate
{
    if (aDate==nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate])
        return YES;
    
    return NO;
}
//去处农历显示文本
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date
{
    /*
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    */
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    
    
//    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
//    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@",d_str];
    
    
    
    return chineseCal_str;
}
//输出可读的时间字符串 《消息时间》
- (NSString*)toStringMessage
{
    
    NSString *formate = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval time = [nowDate timeIntervalSinceDate:self];
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
        NSString *need_yMd = [dateFormatter stringFromDate:self];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            // 在同一天
            dateStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
        } else {
            // 昨天
            dateStr = [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
        }
    } else if (time <= 60*60*24*30) {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        dateStr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
    } else {
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearStr = [dateFormatter stringFromDate:self];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            // 在同一年
            [dateFormatter setDateFormat:@"MM-dd"];
            dateStr = [dateFormatter stringFromDate:self];
        } else {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateStr = [dateFormatter stringFromDate:self];
        }
    }
    
    return dateStr;
    
}
//输出可读的时间字符串 《预约时间》
- (NSString*)toStringWithReserve
{
    
     NSString *dateStr = @"";
    

    NSDate *nowDate = [NSDate date];
    NSDate *mtDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    NSDate *htDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *need_yMd = [dateFormatter stringFromDate:self];
    NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
    NSString *mt_yMd = [dateFormatter stringFromDate:mtDate];
    NSString *ht_yMd = [dateFormatter stringFromDate:htDate];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    if ([need_yMd isEqualToString:now_yMd])
    {
        // 在同一天
        dateStr = [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:self]];
    }
    else if ([need_yMd isEqualToString:mt_yMd])
    {
        //明天
         dateStr = [NSString stringWithFormat:@"明天 %@", [dateFormatter stringFromDate:self]];
    }
    else if ([need_yMd isEqualToString:ht_yMd])
    {
        //后天
        dateStr = [NSString stringWithFormat:@"后天 %@", [dateFormatter stringFromDate:self]];
    }
    else
    {
        dateStr = [self toStringYMDHM];
    }
    
    
    return dateStr;
    
}

- (NSString*)toStringNSTimeInterval
{
    NSTimeInterval t = self.timeIntervalSince1970*1000;
    
    return [NSString stringWithFormat:@"%.0f",t];
}

@end
