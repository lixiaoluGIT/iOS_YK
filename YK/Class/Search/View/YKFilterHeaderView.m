//
//  YKFilterHeaderView.m
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKFilterHeaderView.h"

@interface YKFilterHeaderView(){
    UIButton *seLabel;
}
@property (nonatomic,strong)UIView *staticView;//静态view
@property (nonatomic,strong)UIScrollView *scrollView;//选择出来的标签滚动图
@end

@implementation YKFilterHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    _staticView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(47))];
    _staticView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_staticView];
    
    //单品推荐
    UILabel *reLabel = [[UILabel alloc]init];
    reLabel.text = @"单品推荐";
    reLabel.textColor = mainColor;
    reLabel.font = PingFangSC_Medium(kSuitLength_H(12));
    [_staticView addSubview:reLabel];
    
    [reLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(15));
        make.centerY.equalTo(_staticView.mas_centerY);
    }];
    
    //单品推荐
    seLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [seLabel setTitle:@"在架优先" forState:UIControlStateNormal];
    [seLabel setTitle:@"全部单品" forState:UIControlStateSelected];
    [seLabel setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    seLabel.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
    [seLabel addTarget:self action:@selector(changeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_staticView addSubview:seLabel];
    
    [seLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reLabel.mas_right).offset(kSuitLength_H(37));
        make.centerY.equalTo(_staticView.mas_centerY);
    }];
    
    //箭头图标
    UIImageView *jiImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"在架优先"]];
    [jiImage sizeToFit];
    [_staticView addSubview:jiImage];
    
    [jiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seLabel.mas_right).offset(kSuitLength_H(6));
        make.centerY.equalTo(_staticView.mas_centerY);
    }];
    
    //全部筛选按钮
    UIButton *filertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filertBtn setTitle:@"全部筛选" forState:UIControlStateNormal];
    [filertBtn setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
    [filertBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -100)];
    [filertBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [filertBtn setTitleColor:YKRedColor forState:UIControlStateNormal];
    filertBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    [filertBtn addTarget:self action:@selector(filterAction) forControlEvents:UIControlEventTouchUpInside];
    [_staticView addSubview:filertBtn];
    
    [filertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-(kSuitLength_H(10))));
        make.centerY.equalTo(_staticView.mas_centerY);
    }];
    
    //线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [_staticView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_staticView.mas_bottom);
        make.width.equalTo(_staticView.mas_width);
        make.height.equalTo(@1);
    }];
}

- (void)setFilterKeys:(NSArray *)filterKeys{
    
    if (filterKeys.count==0) {//静态按钮
        
        
    }else{//滚动图
        
    }
}

//切换单品推荐类型
- (void)changeTypeAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.changeTypeBlock) {
        self.changeTypeBlock(btn.selected);
    }
}

//弹出筛选界面
- (void)filterAction{
    if (self.filterActionDid) {
        self.filterActionDid();
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    seLabel.selected = isSelected;
//    if (isSelected) {
//        [seLabel setTitle:@"全部单品" forState:UIControlStateNormal];
//    }else {
//        [seLabel setTitle:@"在架优先" forState:UIControlStateNormal];
//    }
//    seLabel.selected = isSelected;
}

@end
