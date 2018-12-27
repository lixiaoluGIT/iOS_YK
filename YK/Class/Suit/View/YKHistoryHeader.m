//
//  YKHistoryHeader.m
//  YK
//
//  Created by edz on 2018/11/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHistoryHeader.h"

@interface YKHistoryHeader()
@property (nonatomic,strong)UILabel *totalNum;
@property (nonatomic,strong)UILabel *totalPrice;

@end
@implementation YKHistoryHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (!self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    //已穿过
    UILabel *label = [[UILabel alloc]init];
    label.text = @"已穿过";
    label.textColor = mainColor;
    label.font = PingFangSC_Regular(kSuitLength_H(14));
    [self addSubview:label];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(kSuitLength_H(30), 0, WIDHT-kSuitLength_H(30)*2, self.frame.size.height)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    for (int i =0; i<2; i++) {
        //背景视图
        UIView *childView = [[UIView alloc]initWithFrame:CGRectMake((WIDHT-kSuitLength_H(30)*2)/2, 0, WIDHT-kSuitLength_H(30)*2, self.frame.size.height)];
        [backView addSubview:childView];
        
        //描述
        UILabel *lableDes = [[UILabel alloc]init];
        lableDes.font = PingFangSC_Regular(kSuitLength_H(14));
        lableDes.frame = CGRectMake(0, kSuitLength_H(9), childView.frame.size.width/2,kSuitLength_H(20));
        lableDes.centerX = childView.centerX;
        [childView addSubview:lableDes];
        
       //数量
        UILabel *lableNum = [[UILabel alloc]init];
        lableNum.font = PingFangSC_Regular(kSuitLength_H(12));
        lableNum.frame = CGRectMake(0, lableDes.bottom + kSuitLength_H(5), childView.frame.size.width/2,kSuitLength_H(20));
        lableNum.centerX = childView.centerX;
        lableNum.text = @"88";
        [childView addSubview:lableDes];
        
        if (i==0) {
            lableDes.text = @"已穿过";
            self.totalNum = lableNum;
        }else {
            lableDes.text = @"总价值";
            self.totalPrice = lableNum;
        }
        
    }
}

@end
