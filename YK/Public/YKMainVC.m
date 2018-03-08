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

@interface YKMainVC ()

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
        
        YKHomeVC *homeVC = [YKHomeVC new];
        homeVC.tabBarItem.image = [UIImage imageNamed:@"home"];
        homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home1"];
        homeVC.tabBarItem.title = @"首页";
        homeVC.title = @"首页";
        
//        YKHomeSegementVC *homeVC = [YKHomeSegementVC new];
//        homeVC.tabBarItem.image = [UIImage imageNamed:@"home"];
//        homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home1"];
//        homeVC.tabBarItem.title = @"首页";
//        homeVC.title = @"首页";
        
        
        NSDictionary *dictMine = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [homeVC.tabBarItem setTitleTextAttributes:dictMine forState:UIControlStateSelected];
        home = [[UINavigationController alloc] initWithRootViewController:homeVC];
        //homeVC.tabBarItem
        
        YKSearchVC *orderVC = [[YKSearchVC alloc]init];
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

@end
