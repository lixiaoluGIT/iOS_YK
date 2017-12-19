//
//  DDStringHelper.h
//  dongdongcar
//
//  Created by apple on 17/7/21.
//  Copyright © 2017年 softnobug. All rights reserved.
//

//字符串处理类,所有字符串的切割拼接在这里处理
#import <Foundation/Foundation.h>

@interface DDStringHelper : NSObject
//得到时间字符串,分秒格式 ,12:12
+ (NSString *)changeStringWithStr:(NSString *)str Num:(NSInteger)num;
@end
