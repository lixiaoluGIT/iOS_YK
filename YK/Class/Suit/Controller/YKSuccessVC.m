//
//  YKSuccessVC.m
//  YK
//
//  Created by LXL on 2017/11/20.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuccessVC.h"
#import "YKMineVC.h"
#import "YKHomeVC.h"
#import "YKMySuitBagVC.h"

@interface YKSuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *scan;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@end

@implementation YKSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单成功";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = title;
    
    self.scan.layer.masksToBounds = YES;
    self.scan.layer.cornerRadius = 18;
    self.returnBtn.layer.masksToBounds = YES;
    self.returnBtn.layer.cornerRadius = 18;
 }
- (IBAction)scan:(id)sender {
//    YKMineVC *chatVC = [[YKMineVC alloc] init];
//    chatVC.hidesBottomBarWhenPushed = YES;
//    UINavigationController *nav = self.tabBarController.viewControllers[3];
//    chatVC.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.selectedViewController = nav;
//    [self.navigationController popToRootViewControllerAnimated:NO];
    YKMySuitBagVC *bag = [YKMySuitBagVC new];
    bag.isFromSuccess = YES;
    [self.navigationController pushViewController:bag animated:YES];
}
- (IBAction)return:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    YKHomeVC *chatVC = [[YKHomeVC alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = self.tabBarController.viewControllers[0];
    chatVC.hidesBottomBarWhenPushed = YES;
    self.tabBarController.selectedViewController = nav;
    [self.navigationController popToRootViewControllerAnimated:NO];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//        self.tabBarController.selectedIndex = 0;
//    });

    
}

@end
