//
//  DDPersonalCenterPickerView.m
//  dongdongcar
//
//  Created by Dongdong zhang on 2017/6/14.
//  Copyright © 2017年 softnobug. All rights reserved.
//

#import "DDPersonalCenterPickerView.h"

@interface DDPersonalCenterPickerView ()

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation DDPersonalCenterPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self show];
        
    }
    
    return self;
    
}

-(void)show{
    
    
    backView = [[UIView alloc]initWithFrame:self.frame];
    [self addSubview:backView];
    
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = .3;
    
    UITapGestureRecognizer *tapCan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewClick)];
    [backView addGestureRecognizer:tapCan];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-170, self.frame.size.width, 170)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self addSubview:self.pickerView];
    
    [self.pickerView reloadAllComponents];//刷新UIPickerView

    hourArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    
    minateArray = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-170-30, self.frame.size.width, 50)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(self.frame.size.width-70, self.frame.size.height-170-20, 50, 30);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn = cancelBtn;
    cancelBtn.frame = CGRectMake(20, self.frame.size.height-170-20, 120, 30);
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setBtnType{
    [self.cancelBtn setTitle:@"时间不确定" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void)scroll{
    [UIView animateWithDuration:0.3 animations:^{
        [self.pickerView selectRow:_hour inComponent:0 animated:YES]; //默认选中小时
        [self.pickerView selectRow:_min inComponent:1 animated:YES]; //默认选中分钟
    }];
}
//确定
-(void)sureAction{
    
    if ([self.delegate respondsToSelector:@selector(resultHour:min:type:)]) {
        
        if (hoursel.length == 0) {
            hoursel = [hourArray objectAtIndex:_hour];
        }
        
        if (minsel.length == 0) {
            minsel = [minateArray objectAtIndex:_min];
        }
        
        [self.delegate resultHour:hoursel min:minsel type:self.isGoWork];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(resultHour:min:btn1:btn2:day:)]) {
        
        if (hoursel.length == 0) {
            hoursel = [hourArray objectAtIndex:_hour];
        }
        
        if (minsel.length == 0) {
            minsel = [minateArray objectAtIndex:_min];
        }
        [self.delegate resultHour:hoursel min:minsel btn1:_btn btn2:_releaseBtn day:_day];
    }
    
    if ([self.delegate respondsToSelector:@selector(setLabelText:hour:min:StartSearch:address:time:)]) {
        
        if (hoursel.length == 0) {
            hoursel = [hourArray objectAtIndex:_hour];
        }
        
        if (minsel.length == 0) {
            minsel = [minateArray objectAtIndex:_min];
        }
        [self.delegate setLabelText:_timeLabel hour:hoursel min:minsel StartSearch:_type address:_address time:_time];
    }
    
    [self removeFromSuperview];
    
}

//取消
-(void)cancelAction{
    if (self.isShareLine == YES) {
        if ([self.delegate respondsToSelector:@selector(notSureWithType:)]) {
            [self.delegate notSureWithType:self.isGoWork];
        }
        [self removeFromSuperview];
    }else{
        [self removeFromSuperview];
    }
}

- (void)backViewClick{
    [self removeFromSuperview];
}

#pragma mark pickerview function

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  hourArray.count;
    }else{
        return [minateArray count];
    }
    
}

//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0f;
}


//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  self.frame.size.width/3;
}


// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/3, 30)];
    text.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        
        text.text = [hourArray objectAtIndex:row];
        
    }
    if (component == 1) {
        
        text.text = [minateArray objectAtIndex:row];
        
    }

    [view addSubview:text];
    
    return view;
}

//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str ;
    
    if (component == 0) {
        
        str = [hourArray objectAtIndex:row];
        
    }
    
    if (component == 1) {
        
        str = [minateArray objectAtIndex:row];
        
    }
    
    return str;
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str ;
    
    
    if (component == 0) {
        
        str = [hourArray objectAtIndex:row];
        
    }
    
    if (component == 1) {
        
        str = [minateArray objectAtIndex:row];
        
    }

    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}//NS_AVAILABLE_IOS(6_0);


//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //    //NSLog(@"%ld  %ld",component,row);
    
    if (component == 0) {
        hoursel  = [hourArray objectAtIndex:row];
    }
    
    if (component == 1) {
        
        minsel  = [minateArray objectAtIndex:row];
        
    }
    
    
}


@end
