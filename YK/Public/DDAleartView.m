//
//  DDAleartView.m
//  dongdongcar
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 softnobug. All rights reserved.
//

#import "DDAleartView.h"

@interface DDAleartView ()
@property (nonatomic,copy)void (^noBlock)();
@property (nonatomic,copy)void (^yesBlock)();
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIView *aleartView;
@property (nonatomic,strong)UIButton *noBtn;
@property (nonatomic,strong)UIButton *yesBtn;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *line2;
@end

@implementation DDAleartView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        [self setLayOut];
    }
    return self;
}

- (void)setUpUI{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    self.backView = [[UIView alloc]initWithFrame:self.frame];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    [self addSubview:self.backView];
    
    self.aleartView = [[UIView alloc]init];
    self.aleartView = [[UIView alloc]initWithFrame:CGRectMake(WIDHT/2,HEIGHT/2,0,0)];
//    self.aleartView = [[UIView alloc]init];
//
//    CGRect rect;
//    rect.size.height = 0;
//    rect.size.width = 0;
    self.aleartView.center = self.center;
//    self.aleartView.frame = rect;
    self.aleartView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.aleartView];
    
    self.aleartView.layer.masksToBounds = YES;
    self.aleartView.layer.cornerRadius = 8;
    self.image = [[UIImageView alloc]init];
    self.image.image = [UIImage imageNamed:@""];
    [self.aleartView addSubview:self.image];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = PingFangSC_Semibold(17)
    [self.aleartView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.numberOfLines =0;
    self.detailLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.aleartView addSubview:self.detailLabel];
    self.detailLabel.font = PingFangSC_Regular(16);
    
    self.noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.noBtn setTitleColor:[UIColor colorWithHexString:@"676869"] forState:UIControlStateNormal];
    [self.aleartView addSubview:self.noBtn];
    [self.noBtn addTarget:self action:@selector(no) forControlEvents:UIControlEventTouchUpInside];
    self.noBtn.titleLabel.font = PingFangSC_Regular(14);
    
    
    self.yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.aleartView addSubview:self.yesBtn];
    [self.yesBtn addTarget:self action:@selector(yes) forControlEvents:UIControlEventTouchUpInside];
    [self.yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.yesBtn.titleLabel.font = PingFangSC_Regular(14);
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.aleartView addSubview:line1];
    self.line1 = line1;
    
    self.line2 = [[UILabel alloc]init];
    self.line2.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.aleartView addSubview:self.line2];

}
- (void)showWithImage:(UIImage *)imgge title:(NSString *)title detailTitle:(NSString *)detailTitle notitle:(NSString *)notitle yestitle:(NSString *)yestitle color:(UIColor *)aleartColor type:(NSInteger)type cancelBlock:(void (^)(void))cancelBlock ensureBlock:(void (^)(void))ensureBlock{
  
        [self setLayOut];
    
    [self show];
    self.noBlock = cancelBlock;
    self.yesBlock = ensureBlock;
    self.image.image = imgge;
    self.titleLabel.text = title;
    self.detailLabel.text = detailTitle;
    //设置部分字体颜色
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:detailTitle];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:@"200"];
    NSRange range2=[[hintString string]rangeOfString:@"延长"];
    [hintString addAttribute:NSForegroundColorAttributeName value:mainColor range:range1];
    [hintString addAttribute:NSForegroundColorAttributeName value:mainColor range:range2];
 
    self.detailLabel.attributedText=hintString;

    self.titleLabel.textColor = aleartColor;
    [self.noBtn setTitle:notitle forState:UIControlStateNormal];
    [self.yesBtn setTitle:yestitle forState:UIControlStateNormal];
    [self.yesBtn setTitleColor:aleartColor forState:UIControlStateNormal];
}

- (void)setLayOut{
    
    WeakSelf(weakSelf)
    [self.image mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.aleartView.mas_centerX);
        make.top.equalTo(weakSelf.aleartView.mas_top).offset(30);
//        make.width.equalTo(@60);
//        make.height.equalTo(@60);
        
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.aleartView.mas_centerX);
        make.top.equalTo(weakSelf.image.mas_bottom).offset(0);
    }];
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.right.equalTo(@(-8));
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(24);
    }];
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detailLabel.mas_bottom).offset(24);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line1.mas_bottom);
        make.centerX.equalTo(weakSelf.aleartView.mas_centerX);
        make.height.equalTo(@46);
        make.width.equalTo(@1);
        make.bottom.equalTo(weakSelf.aleartView.mas_bottom);
    }];
    
    [self.noBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line1.mas_bottom);
        make.left.equalTo(@0);
        make.right.equalTo(weakSelf.line2.mas_left);
        make.height.equalTo(@46);
//        make.bottom.equalTo(weakSelf.aleartView.mas_bottom);
    }];
    
    [self.yesBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.line2.mas_right);
        make.top.equalTo(weakSelf.line1.mas_bottom);
        make.right.equalTo(@0);
        make.height.equalTo(@46);
//        make.bottom.equalTo(weakSelf.aleartView.mas_bottom);
    }];
    
    [self.aleartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(@50);
        make.right.equalTo(@(-50));
        make.top.equalTo(weakSelf.image.mas_top);
        make.bottom.equalTo(weakSelf.line2.mas_bottom);
    }];
    
    
    
}


- (void)no{
    self.noBlock();
    [self dissmiss];
}
- (void)yes{
    self.yesBlock();
    [self dissmiss];
}
- (void)show{
    CGFloat w = self.frame.size.width;


    [UIView animateWithDuration:0.3 animations:^{

        CGRect rect;
        rect.size.height = 400;
        rect.size.width = w-100*WIDHT/414;
        self.aleartView.frame = rect;
        self.aleartView.center = self.center;
    }completion:^(BOOL finished) {
    
    }];
}
- (void)dissmiss{
    //[UIView animateWithDuration:0.3 animations:^{
      //  self.aleartView.frame = CGRectMake(20,self.frame.size.height, self.frame.size.width-40, 230);
    //}completion:^(BOOL finished) {
        [self removeFromSuperview];
    //}];
}
@end

