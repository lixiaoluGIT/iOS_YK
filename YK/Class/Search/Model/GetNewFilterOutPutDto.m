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
    return @{@"areaRanges" : [houseareaRanges class],
             @"areas" : [houseareas class],
             @"buildingType" : [housebuildingType class],
             @"busincessCirlces" : [housebusincessCirlces class],
             @"daysToOpen" : [toOpenDays class],
             @"priceRanges" : [housepriceRanges class],
             @"propertyTypes" : [housepropertyTypes class],
             @"roomTypes" : [houseroomTypes class],
             @"saleStatus" : [housesaleStatus class],
             @"tags" : [housetags class],
             @"years" : [houseyears class]};
}
@end

@implementation houseareaRanges@end
@implementation houseareas@end
@implementation housebuildingType@end
@implementation housebusincessCirlces
- (void)initWithDictionary:(NSDictionary *)Dic{
    _name = Dic[@"name"];
    _ID = [Dic[@"id"] intValue];
    _sliceAreaId = [Dic[@"sliceAreaId"] intValue];
    _tenantId = [Dic[@"sliceAreaId"] intValue];
}
@end
@implementation toOpenDays
- (void)initWithDictionary:(NSDictionary *)Dic{
    _daysLow = [Dic[@"daysLow"] intValue];;
    _daysHigh = [Dic[@"daysHigh"] intValue];
//    _ID = [Dic[@"sliceAreaId"] intValue];
    _descprition = Dic[@"descprition"];
}
@end
@implementation housepriceRanges
- (void)initWithDictionary:(NSDictionary *)Dic{
    _low = [Dic[@"low"] intValue];;
    _high = [Dic[@"high"] intValue];
    _ID = [Dic[@"sliceAreaId"] intValue];
    _propertyTypeId = [Dic[@"propertyTypeId"] intValue];
}
@end

@implementation housepropertyTypes@end
@implementation houseroomTypes@end
@implementation housesaleStatus@end
@implementation housetags@end
@implementation houseyears@end

