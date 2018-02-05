//
//  PickViewSelect.m
//  时间选择器
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//

#import "PickViewSelect.h"

@implementation PickViewSelect

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        
        _backView =[[UIView alloc]initWithFrame:CGRectMake(0,  0,WIDHT, HEIGHT)];
        _backView.backgroundColor =[UIColor blackColor];
        _backView.alpha = 0.5;
        [_backView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(diss)];
        [_backView addGestureRecognizer:tap];
        
        [self addSubview:_backView];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT ,WIDHT, HEIGHT*0.3+30)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0,  0,HEIGHT, 30)];
        view.backgroundColor =[UIColor whiteColor];
        [_contentView addSubview:view];
        
        _pickView =[[UIPickerView alloc]initWithFrame:CGRectMake(0,30, WIDHT, HEIGHT*0.3)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor =[UIColor whiteColor];
        _pickView.showsSelectionIndicator = YES;
        [_contentView addSubview:_pickView];
        cancel =[[UIButton alloc]initWithFrame:CGRectMake(15*WIDHT/414, 5, 50, 25)];
        [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [view addSubview:cancel];
        
        sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDHT-50-15*WIDHT/414, 5, 50, 25)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view addSubview:sureBtn];
        
        
        [_pickView reloadAllComponents];
        [self timeDate];
        [self appear];

    }
    return self;
}

-(void)timeDate
{
    //获取一个月之内的时间
    NSMutableArray *pickerData = [NSMutableArray array];
    for (int i=0;i<3; i++) {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:+(24*60*60)*i];
        NSDateFormatter  *dateformat=[[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"YYYY-MM-dd"];
        NSString *  loString=[dateformat stringFromDate:yesterday];
        [pickerData addObject:loString];
    }
    
   NSMutableArray *pickerHour=[NSMutableArray arrayWithObjects:@"10:00-11:00",@"11:00-12:00",@"12:00-13:00",@"13:00-14:00",@"14:00-15:00",@"15:00-16:00",@"16:00-17:00",@"17:00-18:00",@"18:00-19:00",@"19:00-20:00", nil];
    self.pickDate = pickerData;
    self.pickHour = pickerHour;
}

- (void)appear{
    [UIView animateWithDuration:0.3 animations:^{
      _contentView.frame =
        CGRectMake(0,HEIGHT*0.7-30, WIDHT, HEIGHT - HEIGHT*0.3+30);
    }];
}

- (void)diss{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame =
        CGRectMake(0,HEIGHT, WIDHT, HEIGHT - 380);
        _backView.alpha  = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _pickDate.count;
    }
    return _pickHour.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        dateStr = [NSString stringWithFormat:@"%@",_pickDate[row]];
        return dateStr;
    }
    hourStr = _pickHour[row];
    return _pickHour[row];
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 25;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        dateStr = [NSString stringWithFormat:@"%@",_pickDate[row]];
        
    }
    if (component == 1) {
        hourStr = _pickHour[row];
    }
}

-(void)cancel:(UIButton *)btn
{
        [self diss];
}

-(void)sureBtn:(UIButton *)btn
{
    [self diss];
    if ([self.delegate respondsToSelector:@selector(pickViewdelegateWith:AndHourStr:)]) {
        [self.delegate pickViewdelegateWith:dateStr AndHourStr:hourStr];
    }
}


@end
