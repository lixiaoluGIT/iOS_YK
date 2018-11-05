//
//  GetNewFilterOutPutDto.h
//  CoolBroker
//
//  Created by edz on 2018/9/23.
//  Copyright © 2018年 bxs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FilterModel,houseareaRanges,houseareas,housebuildingType,housebusincessCirlces,toOpenDays,housepriceRanges,housepropertyTypes,houseroomTypes,housesaleStatus,housetags, houseyears;
@interface GetNewFilterOutPutDto : NSObject

@property (nonatomic, strong) NSDictionary *newfilter;

@property (nonatomic, strong) NSArray<houseareaRanges *> *areaRanges;//面积数组
@property (nonatomic, strong) NSArray<houseareas *> *areas;//区域数组
@property (nonatomic, strong) NSArray<housebuildingType *> *buildingType;//建筑类型数组
@property (nonatomic, strong) NSArray<housebusincessCirlces *> *busincessCirlces;//商圈数组
@property (nonatomic, strong) NSArray<toOpenDays *> *daysToOpen;//开盘时间数组
@property (nonatomic, strong) NSArray<housepriceRanges *> *priceRanges;//均价数组
@property (nonatomic, strong) NSArray<housepropertyTypes *> *propertyTypes;//类型数组
@property (nonatomic, strong) NSArray<houseroomTypes *> *roomTypes;//户型数组
@property (nonatomic, strong) NSArray<housesaleStatus *> *saleStatus;//在售状态数组
@property (nonatomic, strong) NSArray<housetags *> *tags;//标签数组
@property (nonatomic, strong) NSArray<houseyears *> *years;//产权年限数组
@end

@interface FilterModel : NSObject

@end
//面积
@interface houseareaRanges : NSObject
@property (nonatomic, assign) NSInteger high;
@property (nonatomic, assign) NSInteger low;
@property (nonatomic, copy) NSString *value;
@end
//城市区域
@interface houseareas : NSObject
@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *value;
@end
//建筑类型
@interface housebuildingType : NSObject
@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *value;
@end
//商圈
@interface housebusincessCirlces : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger sliceAreaId;
@property (nonatomic, assign) NSInteger tenantId;
@property (nonatomic, copy) NSString *name;
- (void)initWithDictionary:(NSDictionary *)Dic;
@end
//开盘时间
@interface toOpenDays : NSObject

//todo:
@property (nonatomic, assign) NSInteger daysHigh;
@property (nonatomic, assign) NSInteger daysLow;
@property (nonatomic, copy) NSString *descprition;
@property (nonatomic, assign) NSInteger ID;
- (void)initWithDictionary:(NSDictionary *)Dic;
@end
//价格
@interface housepriceRanges : NSObject
@property (nonatomic, assign) NSInteger low;
@property (nonatomic, assign) NSInteger high;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger propertyTypeId;
- (void)initWithDictionary:(NSDictionary *)Dic;
//类型
@end
@interface housepropertyTypes : NSObject
@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *value;
//户型
@end
@interface houseroomTypes : NSObject
@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *value;
//售卖状态
@end
@interface housesaleStatus : NSObject
@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *value;
//标签
@end
@interface housetags : NSObject
@property (nonatomic, copy) NSString *descprition;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger houseResourcesType;
//产权年限
@end

@interface houseyears : NSObject
@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *value;

@end


