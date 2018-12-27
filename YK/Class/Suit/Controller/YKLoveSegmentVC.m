//
//  YKLoveSegmentVC.m
//  YK
//
//  Created by edz on 2018/11/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKLoveSegmentVC.h"
#import "YKMyLoveVC.h"

@interface YKLoveSegmentVC ()

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

@interface YKLoveSegmentVC ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArr;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, strong) UIPageViewController *pageController;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) UILabel *theLine;

@property (nonatomic,strong)NSMutableArray *buttonArr;

@property (nonatomic,strong)UIView *btnView;

@end

@implementation YKLoveSegmentVC

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
    
    [NC addObserver:self selector:@selector(up) name:@"up" object:nil];
    [NC addObserver:self selector:@selector(down) name:@"down" object:nil];
}

- (void)setConfig{
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonArr = [NSMutableArray array];
   
    self.btnView = [[UIView alloc]init];
    self.btnView.backgroundColor = [UIColor whiteColor];
    self.btnView.frame = CGRectMake(0, kNavgationBarHeight , WIDHT, kSuitLength_V(44));
    [self.view addSubview:self.btnView];

    for (NSInteger i = 0; i < self.titleArr.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = BtnTag + i;
        button.layer.masksToBounds = YES;
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:mainColor forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = PingFangSC_Regular(kSuitLength_V(14));
 
        
        button.frame = CGRectMake(kSuitLength_H(40)+(self.btnView.frame.size.width-kSuitLength_H(80))/self.titleArr.count*i, kSuitLength_V(0), (self.btnView.frame.size.width-kSuitLength_H(80))/self.titleArr.count, kSuitLength_V(44));
        [self.btnView addSubview:button];
        [_buttonArr addObject:button];
        
    }
    
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
            controllerTittle = @[@"YKMyLoveVC"];
        }else {
            controllerTittle = @[@"YKMyLoveVC"];
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
            _titleArr = [[NSMutableArray alloc] initWithObjects:@"心愿单",nil];
        }else {
            _titleArr = [[NSMutableArray alloc] initWithObjects:@"心愿单",nil];
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

- (void)up{
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.btnView.frame = CGRectMake(0, -kSuitLength_H(44) , WIDHT, kSuitLength_V(44));
        self.pageController.view.frame = CGRectMake(0,self.btnView.frame.size.height + self.btnView.frame.origin.y+ kStatusnBarHeight, WIDHT, HEIGHT);
    }];
}

- (void)down{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.btnView.frame = CGRectMake(0, kNavgationBarHeight , WIDHT, kSuitLength_V(44));
        self.pageController.view.frame = CGRectMake(0,kNavgationBarHeight+kSuitLength_V(44) , WIDHT, HEIGHT);
    }];
}


@end
