//
//  YKSizeTitleView.m
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSizeTitleView.h"
@interface YKSizeTitleView()

@end
@implementation YKSizeTitleView

- (void)setRecSize:(NSString *)recSize{

    _recSize = recSize;
    UILabel *l1 = [[UILabel alloc]init];
    l1.text = @"尺码详情";
    l1.font = PingFangSC_Regular(kSuitLength_H(14));
    l1.textColor = mainColor;
    [self addSubview:l1];
    
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(20));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    UIButton *_editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    [_editBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    _editBtn.layer.masksToBounds = YES;
    _editBtn.layer.cornerRadius = _editBtn.frame.size.height/2;
    [self addSubview:_editBtn];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(l1.mas_right).offset(kSuitLength_H(20));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(22);
    }];
    if (_hasEditSize) {//已添加尺码
        
        if (recSize.length==0) {//没有推荐
            [_editBtn setTitle:@"暂无推荐尺码" forState:UIControlStateNormal];
            [_editBtn setImage:[UIImage imageNamed:@"右-2尺码详情"] forState:UIControlStateNormal];
            [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -165)];
            [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
            _editBtn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
            [_editBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            _editBtn.layer.masksToBounds = YES;
            _editBtn.layer.cornerRadius = 11;
        }else {
            [_editBtn setTitle:[NSString stringWithFormat:@"为我推荐%@",recSize] forState:UIControlStateNormal];
            [_editBtn setImage:[UIImage imageNamed:@"右-2 尺码详情"] forState:UIControlStateNormal];
            [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -165)];
            [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
            _editBtn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
            [_editBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            _editBtn.layer.masksToBounds = YES;
            _editBtn.layer.cornerRadius = 11;
            
        }
    }else {
        [_editBtn setTitle:@"编辑我的尺码" forState:UIControlStateNormal];
        [_editBtn setImage:[UIImage imageNamed:@"右-2编辑尺码"] forState:UIControlStateNormal];
        [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -165)];
        [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        _editBtn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        [_editBtn setTitleColor:YKRedColor forState:UIControlStateNormal];
        _editBtn.layer.masksToBounds = YES;
        _editBtn.layer.cornerRadius = 11;
    }
}

- (void)click{
    if (self.toEditSizeBlock) {
        self.toEditSizeBlock();
    }
}
@end
