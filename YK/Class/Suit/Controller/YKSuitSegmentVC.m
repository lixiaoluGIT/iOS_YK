//
//  YKSuitSegmentVC.m
//  YK
//
//  Created by edz on 2018/11/9.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSuitSegmentVC.h"
#import "YKCartVC.h"
#import "YKCartVC.h"
#import "YKHistorySuitVC.h"
@interface YKSuitSegmentVC ()

@end


//状态栏高度
#define kStatusnBarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height)
// 导航栏高度
#define kNavgationBarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height)
//字体
#define The_titleFont @"ZHSRXT--GBK1-0"

//#define The_MainColor [LUtils colorHex:@"#B6251E"]

// 设置颜色
#define BXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define The_TitleColor BXColor(85, 85, 85)     //标题文字颜色55555

#define BtnTag 1001

@interface YKSuitSegmentVC ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArr;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) UIPageViewController *pageController;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) UILabel *theLine;

@property (nonatomic,strong)NSMutableArray *buttonArr;

@property (nonatomic,strong)UIView *btnView;

@end

@implementation YKSuitSegmentVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setConfig];
    [self addControllerToArr];
    
    [self updateCurrentPageIndex:self.type];
}

- (void)setConfig{
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonArr = [NSMutableArray array];
    self.theLine = [[UILabel alloc]init];
    self.theLine.backgroundColor = YKRedColor;
    
    self.btnView = [[UIView alloc]init];
    self.btnView.backgroundColor = [UIColor whiteColor];
    self.btnView.frame = CGRectMake(0, kNavgationBarHeight , WIDHT, kSuitLength_V(44));
    [self.view addSubview:self.btnView];
    
    UIButton *clickButton = nil;
    for (NSInteger i = 0; i < self.titleArr.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = BtnTag + i;
        button.layer.masksToBounds = YES;
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [button setTitleColor:YKRedColor forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = PingFangSC_Medium(kSuitLength_V(14));
        //        button.backgroundColor = [UIColor redColor];
        
        if (i == _currentPageIndex) {
            button.selected = YES;
            [button setTitleColor:YKRedColor forState:UIControlStateNormal];
            clickButton = button;
            [self.view addSubview:self.theLine];
        }
        
        [button addTarget:self action:@selector(changeControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(kSuitLength_H(40)+(self.btnView.frame.size.width-kSuitLength_H(80))/self.titleArr.count*i, kSuitLength_V(0), (self.btnView.frame.size.width-kSuitLength_H(80))/self.titleArr.count, kSuitLength_V(44));
        
        [self.btnView addSubview:button];
        //        button.backgroundColor = [UIColor greenColor];
        [_buttonArr addObject:button];
        
    }
    
    CGFloat w = (WIDHT-kSuitLength_H(80))/self.titleArr.count;
    self.theLine.frame = CGRectMake(WIDHT/2-w/2-15,self.btnView.frame.size.height-4 , kSuitLength_H(30), 2);
    [self.btnView addSubview:self.theLine];
    
    //布局
    //    [_buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:60 tailSpacing:60];
    //    [_buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(self.view.mas_top).offset(kNavgationBarHeight+16);
    //        make.height.mas_equalTo(30);
    //    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self.btnView addSubview:line];
    line.frame = CGRectMake(0,kSuitLength_H(42), WIDHT, 2);
}
//
- (void)addControllerToArr{
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    self.pageController.view.frame = CGRectMake(0,kNavgationBarHeight+kSuitLength_V(44) , WIDHT, self.view.frame.size.height);
    //    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(self.view.mas_top).offset(kNavgationBarHeight + 15 + 40);
    //        make.left.bottom.right.equalTo(self.view);
    //    }];
    //
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *pageScrollView = (UIScrollView *)view;
            pageScrollView.delegate = self;
            pageScrollView.scrollsToTop = NO;
        }
    }
}

#pragma mark - controller
//控制器
- (NSMutableArray *)controllerArr{
    if (!_controllerArr) {
        NSString *s = [UD objectForKey:@"showTime"];
        NSArray *controllerTittle;
        if ([s intValue] != 3) {
            controllerTittle = @[@"YKCartVC",@"YKHistorySuitVC"];
        }else {
            controllerTittle = @[@"YKCartVC",@"YKHistorySuitVC"];
        }
        
        _controllerArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < controllerTittle.count; i ++) {
            NSString *controllerName = controllerTittle[i];
            Class className = NSClassFromString(controllerName);
            UIViewController *baseVC = [[className alloc] init];
            [_controllerArr addObject:baseVC];
        }
    }
    return _controllerArr;
}
//标题
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        NSString *s = [UD objectForKey:@"showTime"];
        
        if ([s intValue] != 3) {
            _titleArr = [[NSMutableArray alloc] initWithObjects:@"当前衣袋",@"历史衣袋",nil];
        }else {
            _titleArr = [[NSMutableArray alloc] initWithObjects:@"当前衣袋",@"历史衣袋",nil];
        }
        
    }
    return _titleArr;
}

- (UIPageViewController *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.delegate = self;
        _pageController.dataSource = self;
        [_pageController setViewControllers:@[[self.controllerArr objectAtIndex:self.type]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return _pageController;
}
//
- (void)changeControllerClick:(UIButton *)sender{
    NSInteger tempIndex = _currentPageIndex;
    __weak typeof(self) weakSelf = self;
    NSInteger nowTemp = sender.tag - BtnTag;
    if (nowTemp > tempIndex) {
        for (NSInteger i = tempIndex + 1; i <= nowTemp; i ++) {
            [weakSelf updateCurrentPageIndex:i];
            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if (finished) {
                    //                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }else if (nowTemp < tempIndex){
        for (NSInteger i = tempIndex; i >= nowTemp; i --) {
            [weakSelf updateCurrentPageIndex:i];
            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                if (finished) {
                    //                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }
}
//
- (NSInteger)currentIndexOfController:(UIViewController *)viewController{
    for (NSInteger i = 0; i < self.controllerArr.count; i ++) {
        if (viewController == self.controllerArr[i]) {
            return i;
        }
    }return NSNotFound;
}
//
- (void)updateCurrentPageIndex:(NSInteger)newIndex{
    _currentPageIndex = newIndex;
    UIButton *button = [self.view viewWithTag:BtnTag + _currentPageIndex];
    button.selected = YES;
   
    CGFloat w = (WIDHT-kSuitLength_H(80))/_titleArr.count;
    [UIView animateWithDuration:0.25 animations:^{
        if (newIndex==0) {
            
            self.theLine.frame = CGRectMake(WIDHT/2-w/2-15,self.btnView.frame.size.height-4, kSuitLength_H(30), 2);
        }else {
            self.theLine.frame = CGRectMake(WIDHT-kSuitLength_H(40)-w/2-15,self.btnView.frame.size.height-4 , kSuitLength_H(30), 2);
        }
        
    }];
    for (UIButton *btn in _buttonArr) {
        if (button == btn) {
            btn.titleLabel.textColor = YKRedColor;
        }else {
            btn.titleLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
        }
    }
}

#pragma mark - 无效代理方法
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [self currentIndexOfController:viewController];
    if ((currentIndex == NSNotFound) || (currentIndex == 0)) {
        return nil;
    }
    currentIndex --;
    return self.controllerArr[currentIndex];
}
//
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger currentIndex = [self currentIndexOfController:viewController];
    currentIndex ++;
    if (currentIndex == self.controllerArr.count) {
        return nil;
    }
    return self.controllerArr[currentIndex];
}
//
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        _currentPageIndex = [self currentIndexOfController:[pageViewController.viewControllers lastObject]];
        [self updateCurrentPageIndex:_currentPageIndex];
        NSLog(@"当前选中的是%ld", _currentPageIndex);
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //CGSize size = [self.titleArr[0] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:The_titleFont size:20]}];
    NSInteger x = _currentPageIndex;
    UIButton *button = [self.view viewWithTag:BtnTag + x];
    [UIView animateWithDuration:.1f animations:^{
        UIView *line = [self.view viewWithTag:2000];
        CGRect sizeRect = line.frame;
        sizeRect.origin.x = button.frame.origin.x;
        //        line.frame = CGRectMake(button.frame.origin.x, ((button.frame.size.width)/2 - (size.width)/2), size.width, .5);
    }];
}

@end
