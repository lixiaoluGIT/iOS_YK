//
//  YKSelectTimeView.m
//  YK
//
//  Created by EDZ on 2018/4/10.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSelectTimeView.h"

@interface YKSelectTimeView()
@property (weak, nonatomic) IBOutlet UIButton *todayBtn;
@property (weak, nonatomic) IBOutlet UIButton *tomorrowBtn;

@property (weak, nonatomic) IBOutlet UIButton *time1;
@property (weak, nonatomic) IBOutlet UIButton *time2;
@property (weak, nonatomic) IBOutlet UIButton *time3;

@property (nonatomic,assign)NSInteger btnStatus;

@property (nonatomic,strong)NSString *dayStr;
@property (nonatomic,strong)NSString *timeStr;

@end
@implementation YKSelectTimeView

- (IBAction)ensure:(id)sender {
    if ([_dayStr length] == 0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请选择日期" delay:1.5];
        return;
    }
    if ([_timeStr length] == 0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请选择时间段" delay:1.5];
        return;
    }
    if (self.BtnClickBlock) {
        NSString *total = [NSString stringWithFormat:@"%@!%@",_dayStr,_timeStr];
        self.BtnClickBlock(total);
    }
}
- (IBAction)cancle:(id)sender {
    if (self.BtnClickBlock) {
        
        self.BtnClickBlock(@"请选择归还时间");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBtnStatus];//初始化按钮状态
    
    
    [_todayBtn addTarget:self action:@selector(selectDay:) forControlEvents:UIControlEventTouchUpInside];
    [_tomorrowBtn addTarget:self action:@selector(selectDay:) forControlEvents:UIControlEventTouchUpInside];
    
    [_time1 addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [_time2 addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [_time3 addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setDayBtn:_todayBtn];
    
}

- (NSString *)getDate{
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    return dateStr;
}

- (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

- (void)selectDay:(UIButton *)btn{
    
    if ([btn isEqual:_todayBtn]) {//如果选的是今天
        _todayBtn.userInteractionEnabled = NO;
        _tomorrowBtn.userInteractionEnabled = YES;
        _btnStatus = 1;
        [self setBtn:_todayBtn status:3];//选中
        [self setBtn:_tomorrowBtn status:1];//未选中
        [self setTimeBtn];//判断时间段按钮状态
        _dayStr = [self getDate];
        _timeStr = @"";
    }else {//如果选的是明天
        _dayStr = [self GetTomorrowDay:[NSDate date]];
        _timeStr = @"";
        _todayBtn.userInteractionEnabled = YES;
        _tomorrowBtn.userInteractionEnabled = NO;
        _btnStatus = 2;
        [self setBtn:_tomorrowBtn status:3];//选中
        if ([[self getCurrentTime]intValue]>15) {//如果当前时间大于16
            [self setBtn:_todayBtn status:2];//不可选
        }else {
            [self setBtn:_todayBtn status:1];//可选
        }
        [self setTimeBtn2];
    }
}

- (void)selectTime:(UIButton *)btn{
    
    if ([btn isEqual:_time1]) {//时间段1
        _timeStr = @"10:00-12:00";
        [self setBtn:_time1 status:3];//选中
        [self setBtn:_time2 status:1];//可选
        [self setBtn:_time3 status:1];//可选
    }
    if ([btn isEqual:_time2]) {//时间段2
        _timeStr = @"12:00-14:00";
        
        [self setBtn:_time2 status:3];//选中
        
        if (_btnStatus==2) {
            [self setBtn:_time1 status:1];//可选
        }else {
        if ([[self getCurrentTime]intValue]>11) {//如果当前时间大于16
            [self setBtn:_time1 status:2];//不可选
        }else {
            [self setBtn:_time1 status:1];//可选
        }}
        
        [self setBtn:_time3 status:1];//可选
        
        
    }
    if ([btn isEqual:_time3]) {//时间段3
        
        _timeStr = @"14:00-16:00";
        
        [self setBtn:_time3 status:3];//选中
        
        if (_btnStatus==2) {
            [self setBtn:_time1 status:1];//可选
        }else {
        if ([[self getCurrentTime]intValue]>11) {//如果当前时间大于16
            [self setBtn:_time1 status:2];//不可选
        }else {
            [self setBtn:_time1 status:1];//可选
        }
        }
        
        if (_btnStatus==2) {
            [self setBtn:_time2 status:1];//可选
        }else {
        if ([[self getCurrentTime]intValue]>13) {//如果当前时间大于16
            [self setBtn:_time2 status:2];//不可选
        }else {
            [self setBtn:_time2 status:1];//可选
        }}
    }
}

- (void)setBtnStatus{
    [self setBtn:_todayBtn status:1];
    [self setBtn:_tomorrowBtn status:1];
    [self setBtn:_time1 status:2];
    [self setBtn:_time2 status:2];
    [self setBtn:_time3 status:2];
}

- (void)setDayBtn:(UIButton *)btn{
    //当前时间大于16
    if ([[self getCurrentTime]intValue]>15) {
        [self setBtn:btn status:2];
    }
}
//如果选的是今天,判断时间段按钮
- (void)setTimeBtn{
    
    //当前时间大于14
    if ([[self getCurrentTime]intValue]>13) {
        [self setBtn:_time1 status:2];
        [self setBtn:_time2 status:2];
    }else {
        [self setBtn:_time1 status:1];
        [self setBtn:_time2 status:1];
        [self setBtn:_time3 status:1];
        
    }
    //当前时间大于12
    if ([[self getCurrentTime]intValue]>11) {
        [self setBtn:_time1 status:2];
    }else {
        [self setBtn:_time1 status:1];
        [self setBtn:_time2 status:1];
        [self setBtn:_time3 status:1];
    }
    
    [self setBtn:_time3 status:1];
    
    
}

- (void)setTimeBtn2{
    [self setBtn:_time1 status:1];
    [self setBtn:_time2 status:1];
    [self setBtn:_time3 status:1];
}

-(NSString*)getCurrentTime {
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"HH"];
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (void)setBtn:(UIButton *)btn status:(NSInteger)status{
    if (status==1) {//可选
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = mainColor.CGColor;
        btn.layer.borderWidth = 1;
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.textColor = mainColor;
        btn.userInteractionEnabled = YES;
    }
    if (status==2) {//不可选
        btn.userInteractionEnabled = NO;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = mainColor.CGColor;
        btn.layer.borderWidth = 0;
        btn.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        btn.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        
    }
    if (status==3) {//选中
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = mainColor.CGColor;
        btn.layer.borderWidth = 0;
        btn.backgroundColor = mainColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        btn.userInteractionEnabled = YES;
    }
}

@end
