//
//  CatRefresh.h
//  Cat
//
//  Created by dzmmac on 15/11/5.
//  Copyright © 2015年 dzmmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YyxCircleView.h"
#define CATWEAKSELF typeof(self) __weak weakSelf = self;
// 控件的刷新状态
typedef enum {
    YyxRefreshStateNormal     = 1, // 普通状态
    YyxRefreshStatePulling    = 2, // 松开就可以进行刷新的状态
    YyxRefreshStateRefreshing = 3, // 正在刷新中的状态
    YyxRefreshStateWillRefreshing = 4
} YyxRefreshState;

@class YyxHeaderRefresh;

// 开始进入刷新状态就会调用
typedef void (^BeginRefreshingBlock)(YyxHeaderRefresh *refreshView);

@interface YyxHeaderRefresh : UIView

+ (instancetype)header;

@property (nonatomic, assign) UIEdgeInsets scrollViewInitInset;
@property (nonatomic, strong) UIImageView *catImageView;
@property (nonatomic, weak)   UICollectionView *tableView;
@property (nonatomic, strong) UIView  *catRefreshBackgroundView;
@property (nonatomic, assign) YyxRefreshState state;
@property (nonatomic, strong) YyxCircleView *yyxCircleView;


@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;

- (void)endRefreshing;
-(void)free;
@end
