//
//  WMHCustomScroll.h
//  WMHScrollView
//
//  Created by Archer on 2017/3/21.
//  Copyright © 2017年 jiuji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMHCustomScroll;

@protocol WMHCustomScrollViewDelegate <NSObject>

@optional
-(void)scrollViewImageClick:(WMHCustomScroll *)WMHView;

@end

@interface WMHCustomScroll : UIView<UIScrollViewDelegate>

//传入的图片数组
@property(nonatomic,strong)NSArray *imgArr;
//是否显示pageControl
@property(nonatomic,assign)BOOL isHidePage;
//传入数组类型，0为图片，1为图片网址
@property(nonatomic,copy)NSString *imgType;
//UI控件
@property(nonatomic,strong)UIScrollView *WMHScroll;
@property(nonatomic,strong)UIPageControl *WMHPageCtr;
//定时器
@property(nonatomic,strong)NSTimer *timer;
//协议方法
@property(nonatomic,assign)id<WMHCustomScrollViewDelegate> delegate;

+(instancetype)scrollViewWithImageArray:(NSArray *)imageArr pageCtrIsHiden:(BOOL)isHiden ImgType:(NSString *)typeStr;

@end
