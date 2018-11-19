//
//  GetNewFilterOutPutDto.m
//  CoolBroker
//
//  Created by edz on 2018/9/23.
//  Copyright © 2018年 bxs. All rights reserved.
//

#import "GetNewFilterOutPutDto.h"

@implementation GetNewFilterOutPutDto

+ (NSDictionary *)objectClassInArray{
    return @{@"categoryList" : [category class],
             @"colourList" : [color class],
             @"elementList" : [element class],
             @"labelList" : [Tag class],
             @"seasonList" : [season class],
             @"styleList" : [style class],
             @"updateDay" : [updateTime class],
             };
}
@end

@implementation category
@end
@implementation color
@end
@implementation Tag
@end
@implementation element
@end
@implementation season
@end
@implementation style
@end
@implementation updateTime
@end



