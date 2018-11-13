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

@interface YKHomeSegementVC ()<DXAlertViewDelegate>
{
    NSMutableArray *cacheArray;
    BOOL isNavHidden;
}
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

@property (nonatomic,strong)UIView *btnView;

@end

@implementation YKHomeSegementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cacheArray = [NSMutableArray array];
    [NC addObserver:self selector:@selector(navigationBarHidden) name:@"NavigationHidden" object:nil];
    [NC addObserver:self selector:@selector(navigationBarNotHidden) name:@"NavigationNotHidden" object:nil];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    //    btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"kefu-2"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
  
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
//    btn.hidden = YES;
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn1.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn1.adjustsImageWhenHighlighted = NO;
    //    btn.backgroundColor = [UIColor redColor];
    [btn1 setImage:[UIImage imageNamed:@"wuxiaoxi"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(toMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    
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

- (void)call{
    DXAlertView *al = [[DXAlertView alloc]initWithTitle:@"进入咨询" message:@"确认拨打客服电话吗？" cancelBtnTitle:@"暂不" otherBtnTitle:@"立即咨询"];
    al.delegate = self;
    [al show];
    
}
- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
//        YKChatVC *chatService = [[YKChatVC alloc] init];
//        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//        chatService.targetId = RoundCloudServiceId;
//        chatService.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController :chatService animated:YES];
    }else {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
            NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
            NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
            if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                /// 大于等于10.0系统使用此openURL方法
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
            return;
        }
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertview.delegate = self;
        [alertview show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//取消
        
    }
    if (buttonIndex==1) {//拨打
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}
- (void)toMessage{
    if ([Token length] == 0) {
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            
        }];
         //        YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
//        [self presentViewController:login animated:YES completion:^{
//
//        }];
//        login.hidesBottomBarWhenPushed = YES;
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
    
    //btnView
    self.btnView = [[UIView alloc]init];
    self.btnView.backgroundColor = [UIColor whiteColor];
    self.btnView.frame = CGRectMake(0, kNavgationBarHeight , WIDHT, kSuitLength_V(38));
    [self.view addSubview:self.btnView];
    
    self.buttonArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonArr = [NSMutableArray array];
    self.theLine = [[UILabel alloc]init];
    self.theLine.backgroundColor = YKRedColor;

    UIButton *clickButton = nil;
    for (NSInteger i = 0; i < self.titleArr.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = BtnTag + i;
        button.layer.masksToBounds = YES;
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [button setTitleColor:YKRedColor forState:UIControlStateSelected];
//        [button setBackgroundColor:[UIColor lightGrayColor]];
        button.titleLabel.font = PingFangSC_Medium(kSuitLength_V(12));
        
//        if (i == _currentPageIndex) {
//            button.selected = YES;
//            [button setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
//            clickButton = button;
//            [button addSubview:self.theLine];
//        }
        
        [button addTarget:self action:@selector(changeControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
//        button.backgroundColor = [UIColor greenColor];
        [_buttonArr addObject:button];
        
        button.frame = CGRectMake(self.btnView.frame.size.width/self.titleArr.count*i, kSuitLength_V(0), self.btnView.frame.size.width/self.titleArr.count, kSuitLength_V(38));
        
        if (i == _currentPageIndex) {
            button.selected = YES;
            [button setTitleColor:YKRedColor forState:UIControlStateNormal];
            clickButton = button;
            [button addSubview:self.theLine];
        }
        [self.btnView addSubview:button];

    }
    
    self.theLine.frame = CGRectMake(WIDHT/4-10.5,self.btnView.frame.size.height-2 , kSuitLength_H(21), 2);
    [self.btnView addSubview:self.theLine];
    
    //布局
//    [_buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
//    [_buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top).offset(kNavgationBarHeight+13);
//        make.height.mas_equalTo(30);
//    }];
    
    //横线
//    UILabel *line = [[UILabel alloc]init];
//    line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
//    [self.btnView addSubview:line];
//    line.frame = CGRectMake(0, self.btnView.height-1, WIDHT, 1);
    
    //竖线
    UILabel *Vline = [[UILabel alloc]init];
    Vline.backgroundColor = mainColor;
    Vline.frame = CGRectMake(WIDHT/2,kSuitLength_V(13),1, kSuitLength_V(13));
//    if (HEIGHT == 812) {
//        Vline.frame = CGRectMake(WIDHT/2,64+22+25,1, 12);
//    }
    [self.btnView addSubview:Vline];
}
//
- (void)addControllerToArr{
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    self.pageController.view.frame = CGRectMake(0,kNavgationBarHeight+kSuitLength_V(38) , WIDHT, self.view.frame.size.height);
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
        [_pageController setViewControllers:@[[self.controllerArr objectAtIndex:self.type]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageController;
}
//
- (void)changeControllerClick:(UIButton *)sender{
//    [self navigationBarNotHidden];
    NSInteger tempIndex = _currentPageIndex;
    __weak typeof(self) weakSelf = self;
    NSInteger nowTemp = sender.tag - BtnTag;
    if (nowTemp > tempIndex) {
        for (NSInteger i = tempIndex + 1; i <= nowTemp; i ++) {

            [weakSelf updateCurrentPageIndex:i];

            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
                if (finished) {
//                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }else if (nowTemp < tempIndex){
        for (NSInteger i = tempIndex; i >= nowTemp; i --) {

            [weakSelf updateCurrentPageIndex:i];

            [self.pageController setViewControllers:@[self.controllerArr[i]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
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
//    if (![cacheArray containsObject:@(newIndex)]) {
//        [self navigationBarNotHidden];
//        [cacheArray addObject:@(newIndex)];
//    }
    _currentPageIndex = newIndex;
    UIButton *button = [self.view viewWithTag:BtnTag + _currentPageIndex];
    button.selected = YES;
    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:.25f animations:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.theLine removeFromSuperview];
//        [strongSelf.btnView addSubview:strongSelf.theLine];
//        //
//        [strongSelf.theLine mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(button.mas_bottom).offset(-2);
//            //            make.left.right.equalTo(button);
//            make.centerX.equalTo(button.mas_centerX);
//            make.width.equalTo(@(kSuitLength_H(25)));
//            make.height.mas_equalTo(kSuitLength_V(2));
//        }];
    [UIView animateWithDuration:0.25 animations:^{
        if (newIndex==0) {
            self.theLine.frame = CGRectMake(WIDHT/4-10.5,self.btnView.frame.size.height-2 , kSuitLength_H(21), 2);
        }else {
            self.theLine.frame = CGRectMake(WIDHT/4*3-10.5,self.btnView.frame.size.height-2 , kSuitLength_H(21), 2);
        }
        
    }];
    for (UIButton *btn in _buttonArr) {
        if (button == btn) {
            btn.titleLabel.textColor = YKRedColor;
        }else {
            btn.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        }
    }
//    __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:.25f animations:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.theLine removeFromSuperview];
//        [strongSelf.btnView addSubview:strongSelf.theLine];
//        //
//        [strongSelf.theLine mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(button.mas_bottom).offset(-2);
////            make.left.right.equalTo(button);
//            make.centerX.equalTo(button.mas_centerX);
//            make.width.equalTo(@(kSuitLength_H(25)));
//            make.height.mas_equalTo(kSuitLength_V(2));
//        }];
    
//         [strongSelf.theLine.superview layoutIfNeeded];//强制绘制
//    }];
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

    NSInteger x = _currentPageIndex;

    UIButton *button = [self.view viewWithTag:BtnTag + x];
    [UIView animateWithDuration:.25f animations:^{
        UIView *line = [self.view viewWithTag:2000];
        CGRect sizeRect = line.frame;
        sizeRect.origin.x = button.frame.origin.x;
    }];
}

- (void)navigationBarHidden{

    [ self.navigationController setNavigationBarHidden : YES animated : YES ];
    isNavHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.btnView.frame = CGRectMake(0, kStatusnBarHeight , WIDHT, kSuitLength_V(38));
        self.pageController.view.frame = CGRectMake(0,self.btnView.frame.size.height + self.btnView.frame.origin.y , WIDHT, HEIGHT/4*3+75);
    }];
}

- (void)navigationBarNotHidden{
    [ self.navigationController setNavigationBarHidden : NO animated : YES ];
     isNavHidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.btnView.frame = CGRectMake(0, kNavgationBarHeight , WIDHT, kSuitLength_V(38));
        self.pageController.view.frame = CGRectMake(0,kNavgationBarHeight+kSuitLength_V(38) , WIDHT, HEIGHT);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
     [ self.navigationController setNavigationBarHidden : NO animated : NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [ self.navigationController setNavigationBarHidden : isNavHidden animated : NO ];
}

@end
