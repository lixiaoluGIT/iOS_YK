//
//  YKSettingVC.m
//  YK
//
//  Created by LXL on 2017/11/24.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSettingVC.h"
#import "YKHomeVC.h"
#import "YKWebVC.h"

@interface YKSettingVC ()
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;

@end

@implementation YKSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 11) {
        _gap.constant = 20;
    }
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.title = @"常见问题";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = title;
    self.exitBtn.layer.masksToBounds = YES;
    self.exitBtn.layer.cornerRadius = self.exitBtn.frame.size.height/2;
    // Do any additional setup after loading the view from its nib.
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exit:(id)sender {
    [[YKUserManager sharedManager]exitLoginWithPhone:@"" VetifyCode:@"" OnResponse:^(NSDictionary *dic) {
//        [self.tabBarController setSelectedIndex:0];
        YKHomeVC *chatVC = [[YKHomeVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[0];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}
- (IBAction)clear:(id)sender {
    [smartHUD alertText:self.view alert:@"清除缓存" delay:1.2];
}
- (IBAction)update:(id)sender {
    [smartHUD alertText:self.view alert:@"检查更新" delay:1.2];
}
- (IBAction)about:(id)sender {
    YKWebVC *web = [YKWebVC new];
    web.imageName = @"";
    web.titleStr = @"关于我们";
    [self.navigationController pushViewController:web animated:YES];
}

@end
