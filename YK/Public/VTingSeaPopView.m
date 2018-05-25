
//
//  VTingSeaPopView.m
//  WeibooDemo
//
//  Created by WillyZhao on 16/8/31.
//  Copyright © 2016年 WillyZhao. All rights reserved.
//

#import "VTingSeaPopView.h"

#import "VTingTimeView.h"


#define Width  [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

#define marginX 90 //左右边距
#define marginY 10 //上下间距
#define Row     40 //水平间距

#define itemW   (Width-2*Row-marginX*2)/3.0
#define itemH   (Width-2*Row-marginX*2)/3.0+30

#define itemY   Height/2-30  //最上面item的y坐标
#define distance 500

#define BOTTOM_INSTANCE 385


@interface VTingSeaPopView () {
    NSArray *images;
    NSArray *titles;
    CGFloat angle;
    
    UIImageView *bgImageView;
    UIImageView *imageCC;
    VTingTimeView *titleView;
}

@end

@implementation VTingSeaPopView

-(instancetype)initWithButtonBGImageArr:(NSArray *)imgArr andButtonBGT:(NSArray *)title {
    self = [super initWithFrame:CGRectMake(0, 0, Width, Height)];
    if (self) {
        images = [NSArray arrayWithArray:imgArr];
        titles = [NSArray arrayWithArray:title];
        angle = 0;
        [self loadSubViews];
    }
    return self;
}

#pragma mark getter
-(void)setImageUrl:(NSString *)imageUrl {
    self.imageUrl = imageUrl;
}

#pragma mark 子视图初始化
-(void)loadSubViews {
    //模糊效果
    UIBlurEffect *light = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _backGroundView = [[UIVisualEffectView alloc] initWithEffect:light];
    _backGroundView.frame = self.bounds;
    [self addSubview:_backGroundView];
    
    _isLeft = YES;
    
    bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"分享1"];
    bgImageView.userInteractionEnabled = YES;
    [_backGroundView.contentView addSubview:bgImageView];
    
    
    //右上角图片展示
    imageCC = [[UIImageView alloc] initWithFrame:CGRectMake(Width-120, 45+64, 100, 80)];
    if (self.imageUrl.length>0) {
        //TODO
        //显示图片用url
    }else{
        imageCC.image = [UIImage imageNamed:@"广告"];
    }
//    [bgImageView addSubview:imageCC];
    imageCC.alpha = 0;
    
    //label显示
    titleView = [[VTingTimeView alloc] initWithFrame:CGRectMake(10, 40+64, 200, 100) andDay:@"15" andWeek:@"星期一" andYear:@"08/2016"];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.alpha = 0;
//    [self addSubview:titleView];
    
    //左边的view
    _contentViewLeft = [[UIView alloc] initWithFrame:self.frame];
    [bgImageView addSubview:_contentViewLeft];
    
    //右边的view
    _contentViewRight = [[UIView alloc] initWithFrame:CGRectMake(Width, 0, Width, Height)];
    [bgImageView addSubview:_contentViewRight];
    
    //根据传入的图片数组进行初始化对应的点击item
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<images.count; j++) {
            UIView *item = [[UIView alloc] init];
            item.frame = CGRectMake(marginX*(j+1) +(Width-marginX*3)/2*j, itemY+distance, (Width-marginX*3)/2, (Width-marginX*3)/2+30);
//            item.backgroundColor = [UIColor redColor];
            //i=0：加载到左边的item。i=1：加载到右边隐藏视图的item
            if (i == 0) {
                item.tag = 100+j;
                [_contentViewLeft addSubview:item];
            }else{
                item.tag = 10+j;
                [_contentViewRight addSubview:item];
            }
            
            UIImageView *img = [[UIImageView alloc] initWithImage:images[j]];
//            img.backgroundColor = [UIColor cyanColor];
            img.frame = CGRectMake(0, 0, (Width-marginX*3)/2, (Width-marginX*3)/2);
            img.layer.masksToBounds = YES;
            img.layer.cornerRadius = itemW/2;
            [item addSubview:img];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, img.frame.size.height + img.frame.origin.y+10, (Width-marginX*3)/2, 21)];
            label.text = titles[j];
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            [item addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = item.bounds;
            if (i == 0) {
                button.tag = 1000+j;
            }else{
                button.tag = 110+j;
            }
            
            //弹出的对应item的点击事件
            [button addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [item addSubview:button];
        }
    }
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height-93, Width, 93)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_backGroundView.contentView addSubview:_bottomView];
    
    _exitImgvi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guanbi-1"]];
    _exitImgvi.frame = CGRectMake(Width/2-32/2, 10, 32, 32);
    [_bottomView addSubview:_exitImgvi];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSelfBtn:)];
    [_bottomView setUserInteractionEnabled:YES];
    [_bottomView addGestureRecognizer:tap];
    //左边关闭按钮
    _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.frame = _exitImgvi.frame;
    [_bottomBtn addTarget:self action:@selector(dismissSelfBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_bottomBtn];
    
    
    _centerLine = [[UILabel alloc] initWithFrame:CGRectMake(Width/2, 0, 0.5, 49)];
    _centerLine.backgroundColor = [UIColor lightGrayColor];
    _centerLine.alpha = 0;
    [_bottomView addSubview:_centerLine];
    
    //右边视图显示时候，返回左边视图按钮
    _bottomLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomLeftBtn.frame = CGRectMake(0, 0, Width/2, 49);
    [_bottomLeftBtn addTarget:self action:@selector(backToLeftViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    _bottomLeftBtn.hidden = YES;
    [_bottomView addSubview:_bottomLeftBtn];
    
    //右边视图关闭按钮
    _bottomRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomRightBtn.frame = CGRectMake(Width/2, 0, Width/2, 49);
    [_bottomRightBtn addTarget:self action:@selector(dismissSelfBtn:) forControlEvents:UIControlEventTouchUpInside];
    _bottomRightBtn.hidden = YES;
    [_bottomView addSubview:_bottomRightBtn];
    
    
    _leftImgvi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left"]];
    _leftImgvi.frame = CGRectMake(Width/4-29/2.0, 10, 29, 29);
    _leftImgvi.alpha = 0;
    [_bottomView addSubview:_leftImgvi];
    
    
    _rightImgvi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exit"]];
    _rightImgvi.frame = CGRectMake(Width/2 + Width/4-29/2.0, 10, 29, 29);
    _rightImgvi.alpha = 0;
    [_bottomView addSubview:_rightImgvi];
    
    
}

#pragma mark 返回左视图
-(void)backToLeftViewBtn:(UIButton *)btn{
    //每次返回时，恢复右边隐藏视图的所有item的frame。方便下次pop
    for (int i = 0; i<images.count; i++) {
        UIView *rItem = [_contentViewRight viewWithTag:i+10];
        rItem.transform = CGAffineTransformIdentity;
        rItem.frame = CGRectMake(rItem.frame.origin.x, rItem.frame.origin.y + BOTTOM_INSTANCE, rItem.frame.size.width, rItem.frame.size.height);
        
    }
    
    _bottomLeftBtn.hidden = YES;
    _bottomRightBtn.hidden = YES;
    _bottomBtn.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        //恢复左右视图的相关CGAffineTransform动画效果
        _contentViewLeft.transform = CGAffineTransformIdentity;
        _contentViewRight.transform = CGAffineTransformIdentity;
        
        _isLeft = YES;
        
        _exitImgvi.alpha = 1;
        _centerLine.alpha = 0;
        _leftImgvi.alpha = 0;
        _rightImgvi.alpha = 0;
        
        
    } completion:nil];
}

#pragma mark 关闭当前视图
-(void)dismissSelfBtn:(UIButton *)btn {
    //创建异步线程
    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
    dispatch_async(queue1, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
//                _exitImgvi.transform = CGAffineTransformIdentity;
                _rightImgvi.transform = CGAffineTransformIdentity;
            }];
        });
    });
   
    _bottomView.hidden = YES;
    
    //取出当前左边显示的所有item
    for (id vbc in _contentViewLeft.subviews) {
        if ([vbc isKindOfClass:[UIView class]]) {
            UIView *itemView = (UIView *)vbc;
            NSInteger index = itemView.tag - 100;
            
            [UIView animateWithDuration:1 delay:0.2-(0.06)*index/3 usingSpringWithDamping:0.5f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                itemView.frame = CGRectMake(itemView.frame.origin.x, itemView.frame.origin.y + BOTTOM_INSTANCE, itemView.frame.size.width, itemView.frame.size.height);
                
                self.alpha = 0;
                
            } completion:^(BOOL finished) {
            }];
            
        }
    }
    
}


#pragma mark item点击事件
-(void)itemBtnClick:(UIButton *)btn {
    [self.delegate itemDidSelected:(btn.tag - 1000)];
    if (btn.tag>=110 && btn.tag<116) {
        //TODO
        //右边隐藏视图触发方法。注：tag请打印自取,tag值乱的，未解决
    }else{
        if (btn.tag == 1005) {                                  //判断是否为左边视图的最后一个item
            //每次点击左边视图最后一个item时，对右边未显示的视图进行大小，以及位置信息修改
            for (int i = 0; i<images.count; i++) {
                UIView *rItem = [_contentViewRight viewWithTag:i+10];
                rItem.transform = CGAffineTransformScale(rItem.transform, .9f, .9f);
                rItem.frame = CGRectMake(rItem.frame.origin.x, rItem.frame.origin.y - BOTTOM_INSTANCE, rItem.frame.size.width, rItem.frame.size.height);
            }
            
            _rightImgvi.transform = CGAffineTransformIdentity;
            
            _bottomLeftBtn.hidden = NO;
            _bottomRightBtn.hidden = NO;
            _bottomBtn.hidden = YES;
            _exitImgvi.alpha = 0;
            
            [UIView animateWithDuration:0.3 animations:^{
                
                //左边移出屏幕，右边推进屏幕效果
                _contentViewLeft.transform = CGAffineTransformTranslate(_contentViewLeft.transform, -Width, 0);
                _contentViewRight.transform = CGAffineTransformTranslate(_contentViewRight.transform, -Width, 0);
                
                
                _centerLine.alpha = 1;
                _leftImgvi.alpha = 1;
                _rightImgvi.alpha = 1;
                _rightImgvi.transform = CGAffineTransformRotate(_rightImgvi.transform, M_PI_4);
                
            } completion:nil];
        }else{
            //点击左边视图item且非最后一个item时触发
            btn.layer.masksToBounds = YES;
            
            UIView *itemview = [btn superview];
            
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                itemview.alpha = 0;
                [UIView animateWithDuration:.2f animations:^{
                    //取出当前在左边视图显示的所有item。注：item为view，但点击事件在button上面
                    for (id vbc in _contentViewLeft.subviews) {
                        if ([vbc isKindOfClass:[UIView class]]) {
                            UIView *vbcc = (UIView *)vbc;
                            //判断是否为点击的item，如果是，则放大item。如果不是，则缩小item
                            if (vbcc.tag != itemview.tag) {
                                vbcc.layer.transform = CATransform3DMakeScale(.1f, .1f, 1);
                                vbcc.alpha = 0;
                            }else{
                                itemview.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1);
                            }
                        }
                    }
                } completion:^(BOOL finished) {
                    self.alpha = 0;
                }];
            } completion:^(BOOL finished) {
                
            }];

        }
    }
}

#pragma mark 弹出当前视图
-(void)show {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _backGroundView.alpha = 1;
//                _exitImgvi.transform = CGAffineTransformRotate(_exitImgvi.transform, M_PI_4);
                
            } completion:^(BOOL finished) {
                
            }];
        });
    });
    
    
    //取出当前左边视图显示的所有item
    for (id vbb in _contentViewLeft.subviews) {
        if ([vbb isKindOfClass:[UIView class]]) {
            UIView *itemview = (UIView *)vbb;
            itemview.transform = CGAffineTransformScale(itemview.transform, .9f, .9f);  //修改大小
            NSInteger index = itemview.tag - 100;
            _contentViewLeft.alpha = 0;

            [UIView animateWithDuration:.7f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _contentViewLeft.alpha = 1;
                [UIView animateWithDuration:.9f delay:(0.06)*index/3 usingSpringWithDamping:.6725f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    imageCC.alpha = 1;
                    titleView.alpha = 1;
                    itemview.frame = CGRectMake(itemview.frame.origin.x, itemview.frame.origin.y - BOTTOM_INSTANCE, itemview.frame.size.width, itemview.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    
                    
                    
                }];
            } completion:nil];
            
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
