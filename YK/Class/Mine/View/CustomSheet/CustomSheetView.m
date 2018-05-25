//
//  CustomSheetView.m
//  CustomSheet
//
//  Created by Frayda on 10/2/17.
//  Copyright © 2017 72.iJF4Ever. All rights reserved.
//

#import "CustomSheetView.h"
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

@interface CustomSheetView()
@property (nonatomic,strong) UIView * contentView;
@end
@implementation CustomSheetView
static NSArray * allbus = nil;
static NSInteger shouldBottomBtn = 0;
static NSInteger shouldLeftPoint = 0;
static float heigh4View = 0;
static float width4Btn = 0;
- (CustomSheetView*)initWithBottomBtn:(NSInteger)btnTitle leftPoint:(NSInteger)type rightTitleData:(NSArray*)rightTitles{
    allbus = rightTitles;
    shouldBottomBtn = btnTitle;
    shouldLeftPoint = type;
    for (int i = 0; i<allbus.count; i++) {
        NSString *str = allbus[i];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
        CGSize perSize = [str boundingRectWithSize:CGSizeMake(100, 180)
                                           options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        if (textSize.width<perSize.width) {
            textSize = perSize;
        }
        width4Btn = [self getLeft4Title];
    }
    heigh4View = 57*btnTitle + 51*allbus.count;
    CustomSheetView *sheet = [[CustomSheetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [sheet set];
    return  sheet;
}
- (void)set{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT-heigh4View, SCREEN_WIDTH, heigh4View);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:bgView];
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT,  SCREEN_WIDTH,heigh4View)];
        [self addSubview:_contentView];
        for (int i =0; i<allbus.count; i++) {
            UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
            bu.tag = i;
            bu.backgroundColor = [UIColor whiteColor];
            if (shouldLeftPoint==1) {
                if(i==0) {
                    [bu setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
                }
                if (i==1) {
                    [bu setImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
                }
            
                bu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
         
                bu.imageEdgeInsets = UIEdgeInsetsMake(0,-6,0,0);
            }
            bu.frame = CGRectMake(0, 51*i, [UIScreen mainScreen].bounds.size.width, 51);
            [_contentView addSubview:bu];
            [bu setTitle:allbus[i] forState:UIControlStateNormal];
            [bu setTitleColor:[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            [bu addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 1)];
            line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
            [bu addSubview:line];
            bu.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        if (shouldBottomBtn ==1) {
            UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 51*allbus.count, SCREEN_WIDTH, 60)];
            bottomBtn.tag = 72;
            [bottomBtn setTitle:@"取消" forState:UIControlStateNormal];
            bottomBtn.backgroundColor = [UIColor whiteColor];
            [bottomBtn setTitleColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00] forState:UIControlStateNormal];
            [bottomBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:bottomBtn];
            bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, heigh4View);
        self.alpha = 0;
    }completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
-(void)clickButton:(UIButton*)button{
    [self.delegate  actionSheetDidSelect:button.tag];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, heigh4View);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (float)getLeft4Title{
    float x = (SCREEN_WIDTH-textSize.width)/2;
    return x;
}
@end
