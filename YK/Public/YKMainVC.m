//
//  YKMainVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMainVC.h"
#import "YKHomeVC.h"
#import "YKSearchVC.h"
#import "YKSuitVC.h"
#import "YKMineVC.h"
#import "YKHomeSegementVC.h"
#import "YKSearchSegmentVC.h"

@interface YKMainVC ()<UITabBarControllerDelegate>
{
    NSInteger _currentIndex;
}

@end

@implementation YKMainVC

- (id)init{
    if (self = [super init]) {


        self.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBar.alpha = 1;
//        self.tabBarController.tabBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
//
//        UIImage *homeImageSel = [UIImage imageNamed:@"home_a.png"];
//        homeImageSel = [homeImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UITabBarItem *homeItem = [self.tabBar.items objectAtIndex:0];
//        homeItem.selectedImage = homeImageSel;
        
        UINavigationController *home;
        UINavigationController *near;
        
//        YKHomeVC *homeVC = [YKHomeVC new];
//        homeVC.tabBarItem.image = [UIImage imageNamed:@"home"];
//        homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home1"];
//        homeVC.tabBarItem.title = @"首页";
//        homeVC.title = @"首页";
        
        YKHomeSegementVC *homeVC = [YKHomeSegementVC new];
        homeVC.tabBarItem.image = [UIImage imageNamed:@"home"];
        homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home1"];
        homeVC.tabBarItem.title = @"首页";
        homeVC.title = @"首页";
        
        
        NSDictionary *dictMine = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [homeVC.tabBarItem setTitleTextAttributes:dictMine forState:UIControlStateSelected];
        home = [[UINavigationController alloc] initWithRootViewController:homeVC];
        //homeVC.tabBarItem
        
        YKSearchSegmentVC *orderVC = [[YKSearchSegmentVC alloc]init];
        orderVC.tabBarItem.image = [UIImage imageNamed:@"xuanyi"];
        orderVC.tabBarItem.selectedImage = [UIImage imageNamed:@"xuanyi1"];
        orderVC.tabBarItem.title = @"选衣";
        orderVC.title = @"选衣";
        near = [[UINavigationController alloc] initWithRootViewController:orderVC];
        [orderVC.tabBarItem setTitleTextAttributes:dictMine forState:UIControlStateSelected];
        
        YKSuitVC *shareLineController = [[YKSuitVC  alloc] init];
        shareLineController.title = @"衣袋";
 
        shareLineController.tabBarItem.image = [UIImage imageNamed:@"yidai"];
        shareLineController.tabBarItem.selectedImage = [UIImage imageNamed:@"yidai1"];
        shareLineController.tabBarItem.title = @"衣袋";
        UINavigationController *meaaage = [[UINavigationController alloc] initWithRootViewController:shareLineController];
        [shareLineController.tabBarItem setTitleTextAttributes:dictMine forState:UIControlStateSelected];
        
        YKMineVC  *welfareController = [YKMineVC  new];
        welfareController.title = @"我的";
        welfareController.tabBarItem.image = [UIImage imageNamed:@"wode"];
        welfareController.tabBarItem.selectedImage = [UIImage imageNamed:@"wode1"];
        welfareController.tabBarItem.title = @"我的";
        UINavigationController *list = [[UINavigationController alloc] initWithRootViewController:welfareController];
        
        [welfareController.tabBarItem setTitleTextAttributes:dictMine forState:UIControlStateSelected];

        self.viewControllers = @[home, near, meaaage, list];
        
        self.delegate = self;
        self.selectedIndex = 0;
//        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        
        for (UITabBarItem *item in self.tabBar.items) {
            item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            //item.title
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 3) {
        
    }
    
    //点击tabBarItem动画
    if (self.selectedIndex != _currentIndex)[self tabBarButtonClick:[self getTabBarButton]];
    
    
}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    /*
     "<_UITabBarBackgroundView: 0x7fddb21236e0; frame = (0 0; 375 49); autoresize = W; userInteractionEnabled = NO; layer = <CALayer: 0x7fddb21297d0>>",
     "<UITabBarButton: 0x7fddb23bb500; frame = (2 1; 90 48); opaque = NO; layer = <CALayer: 0x7fddb2130880>>",
     "<UITabBarButton: 0x7fddb217e1a0; frame = (96 1; 90 48); opaque = NO; layer = <CALayer: 0x7fddb217eec0>>",
     "<UITabBarButton: 0x7fddb2184700; frame = (190 1; 89 48); opaque = NO; layer = <CALayer: 0x7fddb2184e20>>",
     "<UITabBarButton: 0x7fddb21893c0; frame = (283 1; 90 48); opaque = NO; layer = <CALayer: 0x7fddb2189b60>>",
     "<UIImageView: 0x7fddb217ea70; frame = (0 -0.5; 375 0.5); autoresize = W; userInteractionEnabled = NO; layer = <CALayer: 0x7fddb219fa40>>"
     */
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    /*
     "<UITabBarSwappableImageView: 0x7fd7ebc52760; frame = (32 5.5; 25 25); opaque = NO; userInteractionEnabled = NO; tintColor = UIDeviceWhiteColorSpace 0.572549 1; layer = <CALayer: 0x7fd7ebc52940>>",
     "<UITabBarButtonLabel: 0x7fd7ebc4f360; frame = (29.5 35; 30 12); text = '\U8d2d\U7269\U8f66'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x7fd7ebc4e090>>" a
     */
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
    _currentIndex = self.selectedIndex;
}
@end
