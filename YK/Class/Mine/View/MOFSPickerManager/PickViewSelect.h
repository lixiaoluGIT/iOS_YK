//
//  PickViewSelect.h
//  时间选择器
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pickViewStrDelegate <NSObject>

-(void)pickViewdelegateWith:(NSString *)dateStr AndHourStr:(NSString *)hourStr;

@end


@interface PickViewSelect : UIView<UIPickerViewDataSource,UIPickerViewDelegate>{
   
    NSString *dateStr;
    NSString *hourStr;
    UIButton *cancel;
    UIButton *sureBtn;
}

//背景视图
@property(nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)UIPickerView *pickView;
//日期
@property(nonatomic,strong)NSMutableArray *pickDate;
//时间
@property(nonatomic,strong)NSMutableArray *pickHour;

@property(nonatomic,assign)id<pickViewStrDelegate>delegate;
@end
