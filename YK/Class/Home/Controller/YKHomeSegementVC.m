//
//  YKHomeSegementVC.m
//  YK
//
//  Created by LXL on 2018/3/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHomeSegementVC.h"
#import "YKHomeVC.h"
#import "YKCommunityVC.h"
#import "YKLoginVC.h"
#import "YKMessageVC.h"

@interface YKHomeSegementVC ()

@end


//状态栏高度
#define kStatusnBarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height)
// 导航栏高度
#define kNavgationBarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)
//字体
#define The_titleFont @"ZHSRXT--GBK1-0"

//#define The_MainColor [LUtils colorHex:@"#B6251E"]

// 设置颜色
#define BXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define The_TitleColor BXColor(85, 85, 85)     //标题文字颜色55555

#define BtnTag 1001

@interface YKHomeSegementVC ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArr;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) UIPageViewController *pageController;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) UILabel *theLine;

@property (nonatomic,strong)NSMutableArray *buttonArr;

@end

@implementation YKHomeSegementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [NC addObserver:self selector:@selector(navigationBarHidden) name:@"NavigationHidden" object:nil];
    [NC addObserver:self selector:@selector(navigationBarNotHidden:) name:@"NavigationNotHidden" object:nil];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 20, 20);
    [releaseButton addTarget:self action:@selector(toMessage) forControlEvents:UIControlEventTouchUpInside];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"wuxiaoxi"] forState:UIControlStateNormal];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    UIImage *titleImages = [UIImage imageNamed:@"title"];
    UIImageView *newTitleView = [[UIImageView alloc] initWithImage:titleImages];
    self.navigationItem.titleView = newTitleView;
    //
    [self setConfig];
    [self addControllerToArr];
    //
    [self updateCurrentPageIndex:self.type];
}
//
- (void)toMessage{
    if ([Token length] == 0) {
        YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
        [self presentViewController:login animated:YES completion:^{

        }];
        login.hidesBottomBarWhenPushed = YES;
        return;
    }
        YKMessageVC *mes = [YKMessageVC new];
        mes.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mes animated:YES];
    
    
//    YKChatVC *chatService = [[YKChatVC alloc] init];
//
//    //    chatService.NameStr = @"客服";
//    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//    chatService.targetId = RoundCloudServiceId;
//    //    chatService.title = chatService.NameStr;
//    chatService.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController :chatService animated:YES];
}
- (void)setConfig{
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonArr = [NSMutableArray array];
    self.theLine = [[UILabel alloc]init];
    self.theLine.backgroundColor = [UIColor colorWithHexString:@"ee2d2d"];
    UIButton *clickButton = nil;
    for (NSInteger i = 0; i < self.titleArr.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = BtnTag + i;
        button.layer.masksToBounds = YES;
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = PingFangSC_Semibold(16);
        
        if (i == _currentPageIndex) {
            button.selected = YES;
            [button setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
            clickButton = button;
            [self.view addSubview:self.theLine];
//
//                        [self.theLine mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.top.mas_equalTo(clickButton.mas_bottom);
//                            make.left.right.equalTo(clickButton);
//                            make.height.mas_equalTo(.5);
//                        }];
            
          
            
        }
        [button addTarget:self action:@selector(changeControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
//        button.backgroundColor = [UIColor greenColor];
        [_buttonArr addObject:button];

    }
    //布局
    [_buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
    [_buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kNavgationBarHeight+13);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.view addSubview:line];
    line.frame = CGRectMake(0,kNavgationBarHeight + 15 + 40-1 , WIDHT, 1);
    
    UILabel *Vline = [[UILabel alloc]init];
    Vline.backgroundColor = mainColor;
    Vline.frame = CGRectMake(WIDHT/2,64+22,1, 12);
    if (HEIGHT == 812) {
        Vline.frame = CGRectMake(WIDHT/2,64+22+25,1, 12);
    }
    [self.view addSubview:Vline];
}
//
- (void)addControllerToArr{
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(kNavgationBarHeight + 15 + 40);
        make.left.bottom.right.equalTo(self.view);
    }];
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
        NSArray *controllerTittle = @[@"YKHomeVC",@"NewDynamicsViewController"];
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
        _titleArr = [[NSMutableArray alloc] initWithObjects:@"推荐", @"晒图", nil];
        //        [_titleArr addObject:@"待收货"];
        //        [_titleArr addObject:@"待发货"];
        //        [_titleArr addObject:@"已收货"];
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
            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }else if (nowTemp < tempIndex){
        for (NSInteger i = tempIndex; i >= nowTemp; i --) {
            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf updateCurrentPageIndex:i];
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
    for (UIButton *btn in _buttonArr) {
        if (button == btn) {
            btn.titleLabel.textColor = mainColor;
        }else {
            btn.titleLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
        }
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.1f animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.theLine removeFromSuperview];
        [strongSelf.view addSubview:strongSelf.theLine];
        //
        [strongSelf.theLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_bottom);
//            make.left.right.equalTo(button);
            make.centerX.equalTo(button.mas_centerX);
            make.width.equalTo(@20);
            make.height.mas_equalTo(2);
        }];
        
//         [strongSelf.theLine.superview layoutIfNeeded];//强制绘制
    }];
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

- (void)navigationBarHidden{
    NSLog(@"hidden");
    
}

- (void)navigationBarNotHidden{
    NSLog(@"nothidden");
}

@end
