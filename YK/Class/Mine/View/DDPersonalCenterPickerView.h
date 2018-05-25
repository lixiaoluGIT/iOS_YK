//
//  DDPersonalCenterPickerView.h
//  dongdongcar
//
//  Created by Dongdong zhang on 2017/6/14.
//  Copyright © 2017年 softnobug. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol datePickerSelectDelegate <NSObject>

@optional
-(void)resultHour:(NSString *)hour min:(NSString *)min type:(NSInteger)isGoWork;

//首页快速发布时间选择代理方法
-(void)resultHour:(NSString *)hour min:(NSString *)min btn1:(UIButton *)btn btn2:(UIButton *)releaseBtn day:(NSString *)day;

//首页超级拼车群:筛选出时间,点确定开始搜索,type:乘客或车主,address:起点或终点,time:时间
- (void)setLabelText:(UILabel *)label hour:(NSString *)hour min:(NSString *)min StartSearch:(NSString *)type address:(NSString *)address time:(NSString *)time;
- (void)notSureWithType:(NSInteger)type;

@end
@interface DDPersonalCenterPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSArray *hourArray;
    NSArray *minateArray;
    
    UIView *backView;
    NSString *hoursel;
    NSString *minsel;
}
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger isGoWork; //1-上班  2-下班
@property (nonatomic, assign) BOOL isShareLine; //YES-超级拼车群  no-非超级拼车群
//首页快速发布
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIButton *releaseBtn;
@property (nonatomic,strong)NSString *day;

//首页超级拼车群
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *time;
//公用
@property (nonatomic,assign)NSInteger hour;
@property (nonatomic,assign)NSInteger min;

@property(nonatomic,assign)id<datePickerSelectDelegate> delegate;



- (void)show;
- (void)scroll;
- (void)setBtnType;
@end
