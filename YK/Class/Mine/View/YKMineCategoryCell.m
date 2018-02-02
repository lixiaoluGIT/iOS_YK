//
//  YKMineCategoryCell.m
//  YK
//
//  Created by LXL on 2018/2/1.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKMineCategoryCell.h"

@implementation YKMineCategoryCell

- (void)setUpUITitleArray:(NSArray *)title ImageArray:(NSArray *)imageArray{
   
    CGFloat h = WIDHT/3*108/124;
    CGFloat gap = 26*WIDHT/375;
    
    for (int i=0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(WIDHT/3*(i%3),h*(i/3) , WIDHT/3, h);
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        //图片
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:imageArray[i]];
        [btn addSubview:image];
        [image sizeToFit];
        
        //文字
        UILabel *lable = [[UILabel alloc]init];
        lable.text  = title[i];
        lable.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        lable.font = PingFangSC_Regular(14);
        [btn addSubview:lable];
        
        //布局
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.top.equalTo(@(26*WIDHT/375));
        }];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(image.mas_centerX);
            make.bottom.equalTo(btn.mas_bottom).offset((-26*WIDHT/375));
        }];
    
    }
    
    //竖线
    for (int i=0; i<2; i++) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WIDHT/3*(i+1), 0, 1,h*2)];
        line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        [self addSubview:line];
    }
    //横线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, h, WIDHT,1)];
    line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self addSubview:line];
}

- (void)initWithTitleArray:(NSArray *)title ImageArray:(NSArray *)imageArray{
    [self setUpUITitleArray:title ImageArray:imageArray];
}

- (void)click:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
}

@end
