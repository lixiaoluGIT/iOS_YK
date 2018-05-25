//
//  YCPickerView.m
//  YCPickerView
//
//  Created by 袁灿 on 16/2/29.
//  Copyright © 2016年 yuancan. All rights reserved.
//

#define SCREEN_WIDTH                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT               [[UIScreen mainScreen] bounds].size.height
#define PICKERVIEW_HEIGHT           256


#import "YCPickerView.h"

@interface YCPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger selectRow;
}

@property (retain, nonatomic) UIView *baseView;
@property (retain, nonatomic) UIView *contentView;

@end

@implementation YCPickerView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:bgView];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT,  WIDHT,165)];
        
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
      UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50,SCREEN_HEIGHT-256,50, 40)];
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [btnOK setTitleColor:[UIColor colorWithHexString:@"ffba00"] forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(pickerViewBtnOK:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btnOK];
        
        
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-256+40, SCREEN_WIDTH, PICKERVIEW_HEIGHT-40)];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_pickerView];
    }
    
  //  [self popPickerView];
    return self;
}

#pragma mark - UIPickerViewDataSource

//返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _arrPickerData.count;
}

//每行显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *timeStr = [DDStringHelper changeStringWithStr:_arrPickerData[row] Num:9];
//    return _arrPickerData[row];
    //NSLog(@"%@-%@",_arrPickerData[row],timeStr);
    return timeStr;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        NSString *timeStr;
        if (self.isDelayPicker == YES) {
            timeStr = [DDStringHelper changeStringWithStr:_arrPickerData[row] Num:9];
        }else{
            timeStr = [self.arrPickerData objectAtIndex:row];
        }
        myView.text = timeStr;
        
        myView.font = [UIFont systemFontOfSize:14  weight:UIFontWeightThin];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)];
        
        NSString *timeStr;
        if (self.isDelayPicker == YES) {
            timeStr = [DDStringHelper changeStringWithStr:_arrPickerData[row] Num:9];
        }else{
            timeStr = [self.arrPickerData objectAtIndex:row];
        }
        myView.text = timeStr;
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    
    return myView;
    
}
#pragma mark - UIPickerViewDelegate

//选中pickerView的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow = row;
}

#pragma mark - Private Menthods

//弹出pickerView
- (void)popPickerView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _contentView.frame = CGRectMake(0, HEIGHT-165, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }];
    
}

//取消pickerView
- (void)dismissPickerView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }];
}

//确定
- (void)pickerViewBtnOK:(id)sender
{
    if (self.ensureBlock) {
        self.ensureBlock(_arrPickerData[selectRow],selectRow);
    }
    if (self.selectBlock) {
        self.selectBlock(_arrPickerData[selectRow]);
    }
    [self dismissPickerView];
}

//取消
- (void)pickerViewBtnCancel:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(nil);
    }
    
    [self dismissPickerView];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 165);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
