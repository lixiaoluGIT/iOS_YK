//
//  YKDetailFootView.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKDetailFootView.h"

@interface YKDetailFootView()
{
    UIButton *buyBtn;
}

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIButton *suitbtn;
@property (weak, nonatomic) IBOutlet UILabel *owendNumLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yidai;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnW;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;


@end
@implementation YKDetailFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    _owendNumLable.layer.masksToBounds = YES;
    _owendNumLable.layer.cornerRadius = 5.5;
    _btnW.constant = kSuitLength_H(243);
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToCartSuccess) name:@"addToCartSuccess" object:nil];
    
    if (WIDHT==320) {
        _likeLabel.hidden = YES;
        _yidai.hidden = YES;
    }
}

- (void)setCanBuy:(BOOL)canBuy{
    _canBuy = canBuy;
//    CGRect frame = _addBtn.frame;
    if (canBuy) {
        _addBtn.hidden = YES;
        buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.backgroundColor = [UIColor colorWithHexString:@"333333"];
        buyBtn.frame = CGRectMake(WIDHT-kSuitLength_H(243), 0, kSuitLength_H(243)/2,kSuitLength_H(50));
        [buyBtn setTitle:@"买这件" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
        [self addSubview:buyBtn];
        
        UIButton *zuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zuBtn.backgroundColor = YKRedColor;
        zuBtn.frame = CGRectMake(WIDHT-kSuitLength_H(243)/2, 0, kSuitLength_H(243)/2,kSuitLength_H(50));
        [zuBtn setTitle:@"租这件" forState:UIControlStateNormal];
        [zuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        zuBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
        [self addSubview:zuBtn];
        
        [buyBtn addTarget:self action:@selector(toBuy) forControlEvents:UIControlEventTouchUpInside];
        [zuBtn addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setHadStock:(BOOL)hadStock{
    _hadStock = hadStock;
    if (!hadStock) {
        [UIView animateWithDuration:0.3 animations:^{
             [buyBtn setTitle:@"预约购买" forState:UIControlStateNormal];
        }];
       
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            [buyBtn setTitle:@"买这件" forState:UIControlStateNormal];
        }];
    }
}
//购买
- (void)toBuy{
    if (self.buyBlock) {
        self.buyBlock();
    }
}
- (IBAction)selectLike:(id)sender {
//    if (_likeBtn.selected) {
//        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"您已喜欢该商品" delay:1.2];
//        return;
//    }
    if (self.likeSelectBlock) {
        self.likeSelectBlock(_likeBtn.selected);
    }
}

- (IBAction)toCart:(id)sender {
    if (self.ToSuitBlock) {
        self.ToSuitBlock();
    }
    
}

- (IBAction)addToCart:(id)sender {
    if (self.AddToCartBlock) {
        self.AddToCartBlock();
    }
}

- (void)initWithIsLike:(NSString *)isCollect total:(NSString *)total{
    _owendNumLable.text = total;
    
    if ([total intValue] == 0) {
        _owendNumLable.hidden = YES;
    }else {
         _owendNumLable.hidden = NO;
    }
    
    if ([isCollect intValue] == 1) {//已收藏
        _likeBtn.selected = YES;
        _likeImage.image = [UIImage imageNamed:@"喜欢已选"];
        _likeLabel.text = @"已喜欢";
        
    }else {//未收藏
        _likeBtn.selected = NO;
        _likeImage.image = [UIImage imageNamed:@"心111"];
        _likeLabel.text = @"喜欢";
    }
    
}

//添加购物车动画(曲线动画)
- (void)addAnimatedWithFrame:(CGRect)frame {
    
}

//添加购物车动画
- (void)addToCartSuccess{
    [UIView animateKeyframesWithDuration:0.8 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/3.0 animations:^{
            _owendNumLable.transform = CGAffineTransformMakeScale(3.0, 3.0);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:2/3.0 animations:^{
            _owendNumLable.transform = CGAffineTransformIdentity;
        }];
    } completion:^(BOOL finished) {
        
    }];
}

@end
