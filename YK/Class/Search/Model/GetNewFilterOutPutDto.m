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
             @"timeList" : [updateDay class],
             };
}
- (void)initWithDic:(NSDictionary *)dic{
    self.categoryList = [NSArray arrayWithArray:dic[@"categoryList"]];
    self.colourList = [NSArray arrayWithArray:dic[@"colourList"]];
    self.elementList = [NSArray arrayWithArray:dic[@"elementList"]];
    self.labelList = [NSArray arrayWithArray:dic[@"labelList"]];
    self.seasonList = [NSArray arrayWithArray:dic[@"seasonList"]];
    self.timeList = [NSArray arrayWithArray:dic[@"newTimeVOList"]];
    self.styleList = [NSArray arrayWithArray:dic[@"styleList"]];
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
@implementation updateDay
@end



