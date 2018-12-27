//
//  YKLoveNoDataView.m
//  YK
//
//  Created by edz on 2018/11/22.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKLoveNoDataView.h"

@interface YKLoveNoDataView()<UIScrollViewDelegate>
{
    UIButton *toSelectBtn;
}
@end
@implementation YKLoveNoDataView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    //
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"Group 2-1",@"2",@"Group-1"];
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0,WIDHT, kSuitLength_H(275));
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(WIDHT*3, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollView];
    
    for (int i=0; i<3; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(WIDHT*i, 0, WIDHT, kSuitLength_H(275));
        [scrollView addSubview:image];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        image.image = [UIImage imageNamed:imageArray[i]];
    }
    
    toSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toSelectBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(80)/2, scrollView.frame.size.height + scrollView.frame.origin.y+kSuitLength_H(23), kSuitLength_H(80), kSuitLength_H(32));
    [toSelectBtn setTitle:@"去选衣" forState:UIControlStateNormal];
    [toSelectBtn setBackgroundColor:YKRedColor];
    [toSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    toSelectBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(14));
    [toSelectBtn addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];
    toSelectBtn.layer.cornerRadius = kSuitLength_H(32)/2;
    [self addSubview:toSelectBtn];
}

- (void)reSetTitle{
    [toSelectBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
}
- (void)sel{
    if (self.selectClothes) {
        self.selectClothes();
    }
}
@end
