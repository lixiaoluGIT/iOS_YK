//
//  NavViewController.m
//  bbkm
//
//  Created by liwenzhi on 15/10/12.
//  Copyright (c) 2015年 lwz. All rights reserved.
//

#import "NavViewController.h"
//#import "AccountManegerViewController.h"

static NSArray *loginAuthClassArray = nil;

@interface NavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation NavViewController
+ (void)initialize
{
    if (self == [NavViewController class]) {
        
        loginAuthClassArray = @[];
    }
}
- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    
    if (IOS7_OR_LATER) {
        self = [self initWithRootViewController:rootViewController setBarBack:[UIColor whiteColor]];
    }
    else
    {
        self = [self initWithRootViewController:rootViewController setBarBack:mainColor];
    }
    return self;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.backBarButtonItem = back;
    return YES;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController setBarBack:(id)barBack
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        if ([barBack isKindOfClass:[UIColor class]]) {
            [self setNavBarBackgoundWithColor:barBack];
        }else if ([barBack isKindOfClass:[UIImage class]]){
            [self setNavBarBackgoundWithImage:barBack];
        }
        self.view.layer.masksToBounds = YES;
        self.delegate = self;
        [self setTitleTextColor];
        if (!IOS7_OR_LATER) {
            self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //左边缘右划返回上一级功能
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

 -(UIFont *)mysystemFontOfSize:(CGFloat)fontSize{
    CGFloat size = fontSize;
    if (isIPhone6) {
        size = fontSize;
    }else if(isIPhone6p){
        size = fontSize + 2;
    }
    
    return [UIFont systemFontOfSize:size];
}
- (void)setTitleTextColor
{
    NSDictionary * dict =  [NSDictionary dictionaryWithObjectsAndKeys:[self mysystemFontOfSize:kSuitLength_H(14)],NSFontAttributeName,mainColor,NSForegroundColorAttributeName,[NSValue valueWithCGSize:CGSizeMake(0.1, 0.1)],UITextAttributeTextShadowOffset, nil];//[NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationBar.titleTextAttributes = dict;
}

- (void)setNavBarBackgoundWithImage:(UIImage *)image
{
    self.navigationBar.barTintColor = [UIColor clearColor];
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        self.navigationBar.layer.contents = (id)image.CGImage;
    }
}

- (void)setNavBarBackgoundWithColor:(UIColor *)color
{
    self.navigationBar.alpha = 0.8f;
    if (IOS7_OR_LATER)
    {
        self.navigationBar.barTintColor = color;
        self.navigationBar.translucent = NO;
    }
    else
    {
        UIImage *image ;
        if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
        {
            [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            self.navigationBar.layer.contents = (id)image.CGImage;
        }
    }
}


#pragma mark -
#pragma mark logon auth

- (BOOL)needLogonAuth:(UIViewController *)viewController{
	BOOL need = NO;
	for (id class in loginAuthClassArray) {
		if ([[viewController class] isSubclassOfClass:class]) {
			need = YES;
			break;
		}
	}
	
	return need;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
	if ([self needLogonAuth:viewController]) {
        
//        if (![[[Config currentConfig] isLogin] boolValue]) {
//            DLog(@"needLogonAuth \n");
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            loginVC.nextController = viewController;
//            loginVC.nextNavigationController = self;
//            //            loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            NavViewController *navController = [[NavViewController alloc] initWithRootViewController:loginVC];
//            TT_RELEASE_SAFELY(loginVC);
//
//            [self presentViewController:navController animated:YES completion:nil];
////            [self presentModalViewController:navController animated:YES];
//            TT_RELEASE_SAFELY(navController);
            
//            return;
//        }
        
        if ([self.viewControllers containsObject:viewController]) {
            //[viewController viewWillAppear:animated];
            return;
        }
    }
    //如果当前是正在pop的过程，就禁止左边缘右划手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
	[super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    //位于当前navgationController的第一个（[0]）viewController时需要设置手势代理，不响应。
    if ([viewController.class isSubclassOfClass:navigationController.childViewControllers[0].class]) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [super dismissViewControllerAnimated:flag completion:completion];
}
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent animated:flag completion:nil];
}

@end
