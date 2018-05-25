//
//  DDStringHelper.m
//  dongdongcar
//
//  Created by apple on 17/7/21.
//  Copyright © 2017年 softnobug. All rights reserved.
//

#import "DDStringHelper.h"

@implementation DDStringHelper

+ (NSString *)changeStringWithStr:(NSString *)str Num:(NSInteger)num{
    
    NSString *string = [str stringByReplacingCharactersInRange:NSMakeRange(0, str.length-num) withString:@""];
    NSString *totalStr = [string stringByReplacingCharactersInRange:NSMakeRange(string.length-3, 3) withString:@""];
    return totalStr;
}
@end
