//
//  YKDetailFootView.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKDetailFootView.h"

@interface YKDetailFootView()

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIButton *suitbtn;
@property (weak, nonatomic) IBOutlet UILabel *owendNumLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
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
}

- (IBAction)selectLike:(id)sender {
    if (_likeBtn.selected) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"您已喜欢该商品" delay:1.2];
        return;
    }
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
    
    if ([isCollect intValue] == 1) {//已收藏
        _likeBtn.selected = YES;
        _likeImage.image = [UIImage imageNamed:@"喜欢已选"];
        _likeLabel.text = @"喜欢";
        
    }else {//未收藏
        _likeBtn.selected = NO;
        _likeImage.image = [UIImage imageNamed:@"喜欢未选"];
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
