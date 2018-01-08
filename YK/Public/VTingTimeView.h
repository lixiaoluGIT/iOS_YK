//
//  VTingTimeView.h
//  WeibooDemo
//
//  Created by WillyZhao on 16/9/1.
//  Copyright © 2016年 WillyZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTingTimeView : UIView

/**
 ***根据文本信息进行初始化***
 ***day：日期。week：星期数。year：年月（08/2016）***
 **/
-(instancetype)initWithFrame:(CGRect)frame andDay:(NSString *)day andWeek:(NSString *)week andYear:(NSString *)year;

@property (nonatomic, copy) NSString *day;

@property (nonatomic, copy) NSString *week;

@property (nonatomic, copy) NSString *year;

@end
