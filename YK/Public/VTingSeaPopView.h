//
//  VTingSeaPopView.h
//  WeibooDemo
//
//  Created by WillyZhao on 16/8/31.
//  Copyright © 2016年 WillyZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VTingPopItemSelectDelegate <NSObject>
@optional
/**
 ***点击弹出的button后回调***
 **/
-(void)itemDidSelected:(NSInteger)index;

@end

@interface VTingSeaPopView : UIView

@property (nonatomic, assign) id<VTingPopItemSelectDelegate> delegate;


//模糊效果视图，已放弃但未删除
@property (nonatomic, strong) UIVisualEffectView *backGroundView;

//弹出的左边视图
@property (nonatomic, strong) UIView *contentViewLeft;

//弹出左边视图时，右边隐藏视图
@property (nonatomic, strong) UIView *contentViewRight;


//类tabbar
@property (nonatomic, strong) UIView *bottomView;

//关闭当前视图
@property (nonatomic, strong) UIButton *bottomBtn;

//返回左边图片容器
@property (nonatomic, strong) UIImageView *exitImgvi;

//返回左边按钮
@property (nonatomic, strong) UIButton *bottomLeftBtn;

//关闭
@property (nonatomic, strong) UIButton *bottomRightBtn;

//右视图显示时button间分割线
@property (nonatomic, strong) UILabel *centerLine;

//图片容器
@property (nonatomic, strong) UIImageView *leftImgvi;

//图片容器
@property (nonatomic, strong) UIImageView *rightImgvi;

/**
 ***图片地址***
 **/
@property (nonatomic, copy) NSString *imageUrl;


@property (nonatomic, assign) BOOL isLeft;

/**
 ***初始化方法***
 ***imgArr：显示图片数组，不可为空***
 ***title：显示名称数组，不可为空***
 **/
-(instancetype)initWithButtonBGImageArr:(NSArray *)imgArr andButtonBGT:(NSArray *)title;

-(void)show;

@end
