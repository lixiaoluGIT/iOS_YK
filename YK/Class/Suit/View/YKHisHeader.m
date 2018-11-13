//
//  YKHisHeader.m
//  YK
//
//  Created by edz on 2018/11/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHisHeader.h"
@interface YKHisHeader()
@property (nonatomic,strong)UILabel *totalNum;
@property (nonatomic,strong)UILabel *totalPrice;
@end
@implementation YKHisHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    
     [self setUpUI];
}

- (void)setUpUI{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(59))];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    for (int i =0; i<2; i++) {
        //背景视图
        CGFloat w = (WIDHT - kSuitLength_H(18)*2)/2;
        UIView *childView = [[UIView alloc]initWithFrame:CGRectMake(kSuitLength_H(18) + w*i, 0, w, kSuitLength_H(59))];
        childView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:childView];
        
        //描述
        UILabel *lableDes = [[UILabel alloc]init];
        lableDes.font = PingFangSC_Regular(kSuitLength_H(14));
        lableDes.frame = CGRectMake(kSuitLength_H(18) + w*i, kSuitLength_H(9), childView.frame.size.width/2,kSuitLength_H(20));
        lableDes.centerX = childView.centerX;
        lableDes.textAlignment = NSTextAlignmentCenter;
        lableDes.font = PingFangSC_Regular(kSuitLength_H(14));
        lableDes.textColor = mainColor;
        lableDes.text = @"已穿过";
        [backView addSubview:lableDes];
        
        //数量
        UILabel *lableNum = [[UILabel alloc]init];
        
        lableNum.frame = CGRectMake(kSuitLength_H(18) + w*i, lableDes.bottom + kSuitLength_H(5), childView.frame.size.width/2,kSuitLength_H(20));
        
        lableNum.centerX = childView.centerX;
        lableNum.text = @"88";
        lableNum.font = PingFangSC_Medium(kSuitLength_H(12));
        lableNum.textColor = mainColor;
        lableNum.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:lableNum];
        
        
        
        if (i==0) {
            lableDes.text = @"已穿过";
            self.totalNum = lableNum;
        }else {
            lableDes.text = @"总价值";
            self.totalPrice = lableNum;
        }
        
    }
    
    //线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    line.frame = CGRectMake(0, backView.frame.size.height-5, WIDHT, 5);
    [backView addSubview:line];
}

- (void)setClothList:(NSMutableArray *)clothList{
    _clothList = clothList;
    //计算总数和总价
    _totalNum.text = [NSString stringWithFormat:@"%ld件",clothList.count];
    int totalP = 0;
    for (NSDictionary *dic in clothList) {
        totalP = totalP + [dic[@"clothingPrice"] intValue];
    }
    _totalPrice.text = [NSString stringWithFormat:@"¥ %d",totalP];
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
}
@end
