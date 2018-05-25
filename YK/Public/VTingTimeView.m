//
//  VTingTimeView.m
//  WeibooDemo
//
//  Created by WillyZhao on 16/9/1.
//  Copyright © 2016年 WillyZhao. All rights reserved.
//

#import "VTingTimeView.h"

@implementation VTingTimeView


-(instancetype)initWithFrame:(CGRect)frame andDay:(NSString *)day andWeek:(NSString *)week andYear:(NSString *)year{
    if (self = [super initWithFrame:frame]) {
        self.day = day;
        self.week = week;
        self.year = year;
        self.frame = [self loadSubViewsWith:frame];
    }
    return self;
}

/**
 ***加载所有子视图***
 ***返回self的新frame属性***
 **/

-(CGRect)loadSubViewsWith:(CGRect)frame {
    UILabel *day_l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self getWidthValueWith:_day andFont:45], [self getHeightValueWith:_day andFont:45])];
    [self addSubview:day_l];
    day_l.text = _day;
    day_l.font = [UIFont systemFontOfSize:45];
    day_l.textColor = [UIColor blackColor];
    
    UILabel *week_l = [[UILabel alloc] initWithFrame:CGRectMake(day_l.frame.size.width+15, 8, [self getWidthValueWith:_week andFont:13], [self getHeightValueWith:_week andFont:13])];
    [self addSubview:week_l];
    week_l.text = _week;
    week_l.font = [UIFont systemFontOfSize:13];
    week_l.textColor = [UIColor lightGrayColor];
    
    UILabel *year_l = [[UILabel alloc] initWithFrame:CGRectMake(week_l.frame.origin.x, week_l.frame.size.height+16, [self getWidthValueWith:_year andFont:13], [self getHeightValueWith:_year andFont:13])];
    [self addSubview:year_l];
    year_l.text = _year;
    year_l.font = [UIFont systemFontOfSize:13];
    year_l.textColor = [UIColor lightGrayColor];
    
    return CGRectMake(frame.origin.x, frame.origin.y, day_l.frame.size.width+15+year_l.frame.size.width, week_l.frame.size.height+8+year_l.frame.size.height);
}

/**
 ***计算文本宽度***
 **/

-(CGFloat)getWidthValueWith:(NSString *)str andFont:(CGFloat)font{
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        
    return size.width;
}

/**
 ***计算文本高度***
 **/

-(CGFloat)getHeightValueWith:(NSString *)str andFont:(CGFloat)font{
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake([self getWidthValueWith:str andFont:font], MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    NSLog(@"rect");
//}


@end
