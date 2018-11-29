//
//  GetNewFilterOutPutDto.h
//  CoolBroker
//
//  Created by edz on 2018/9/23.
//  Copyright © 2018年 bxs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FilterModel,category,color,element,Tag,season,style,updateDay;
@interface GetNewFilterOutPutDto : NSObject

@property (nonatomic, strong) NSDictionary *newfilter;
@property (nonatomic, strong) NSArray<category *> *categoryList;//分类
@property (nonatomic, strong) NSArray<color *> *colourList;//颜色数组
@property (nonatomic, strong) NSArray<element *> *elementList;//元素数组
@property (nonatomic, strong) NSArray<Tag *> *labelList;//标签数组
@property (nonatomic, strong) NSArray<season *> *seasonList;//季节数组
@property (nonatomic, strong) NSArray<style *> *styleList;//风格数组
@property (nonatomic, strong) NSArray<updateDay *> *timeList;//上新时间数组

- (void)initWithDic:(NSDictionary *)dic;
@end

@interface FilterModel : NSObject

@end
//分类
@interface category : NSObject
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic,assign)NSInteger sort;
@end
//颜色类型
@interface color : NSObject
@property (nonatomic, assign) NSInteger colourId;
@property (nonatomic, copy) NSString *colourName;
@property (nonatomic,assign)NSInteger sort;
@end
//元素
@interface element : NSObject
@property (nonatomic, copy) NSString *elementName;
@property (nonatomic, assign) NSInteger elementId;
@property (nonatomic,assign)NSInteger sort;
@end
//季节
@interface season : NSObject
@property (nonatomic, assign) NSInteger seasonId;
@property (nonatomic, copy) NSString *seasonName;
@property (nonatomic,assign)NSInteger sort;
//标签
@end

@interface Tag : NSObject
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, assign) NSInteger labelId;
@property (nonatomic,assign)NSInteger sort;
//风格
@end
@interface style : NSObject
@property (nonatomic, assign) NSInteger styleId;
@property (nonatomic, copy) NSString *styleName;
@property (nonatomic,assign)NSInteger sort;
@end
//上新时间
@interface updateDay : NSObject
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, copy) NSString *label;
@end


