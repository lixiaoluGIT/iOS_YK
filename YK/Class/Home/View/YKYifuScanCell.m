//
//  YKYifuScanCell.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKYifuScanCell.h"
#import "LMLGestureHeadImageScrollView.h"
@interface YKYifuScanCell()<UIScrollViewDelegate>
{
    UIScrollView *background;
    LMLGestureHeadImageScrollView *imageScroll;
}
@property(nonatomic)BOOL zoomOut_In;
@property(nonatomic,strong)UIImageView *image;
@end

@implementation YKYifuScanCell

- (void)setImageView:(UIImageView *)imageView{
    _imageView = imageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageView.userInteractionEnabled = YES;
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [_imageView addGestureRecognizer:tapGesture];
   
}
- (void) tapAction{
    
    imageScroll = [[LMLGestureHeadImageScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT) andHeadImage:_imageView.image];

    [[UIApplication sharedApplication].keyWindow addSubview:imageScroll];
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    background = bgView;

    [background setBackgroundColor:[UIColor blackColor]];
    [[UIApplication sharedApplication].keyWindow addSubview:background];
    [background addSubview:imageScroll];

    background.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];

    [background addGestureRecognizer:tapGesture];

    [self shakeToShow:background];//放大过程中的动画
}

-(void)closeView{
    [UIView animateWithDuration:0.2 animations:^{
        background.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView transitionFromView:background toView:background duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            [background removeFromSuperview];
            
        }];
    }];
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
