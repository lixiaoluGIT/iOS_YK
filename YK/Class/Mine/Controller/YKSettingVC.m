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
#import "YKAboutUsVC.h"
#import "YKCacheManager.h"

@interface YKSettingVC ()<DXAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;

@end

@implementation YKSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 11) {
        _gap.constant = 84;
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
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Semibold(20);
    
    self.navigationItem.titleView = title;
    self.exitBtn.layer.masksToBounds = YES;
    self.exitBtn.layer.cornerRadius = self.exitBtn.frame.size.height/2;
    
    self.cacheLabel.text = [NSString stringWithFormat:@"%.1fM",[[YKCacheManager sharedManager]getFolderSize]];

}


- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exit:(id)sender {
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"温馨提示" message:@"确定要退出登录吗?" cancelBtnTitle:@"取消" otherBtnTitle:@"确定"];
    alertView.delegate = self;
    [alertView show];

}
- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[YKUserManager sharedManager]exitLoginWithPhone:@"" VetifyCode:@"" OnResponse:^(NSDictionary *dic) {
           
            YKHomeVC *chatVC = [[YKHomeVC alloc] init];
            chatVC.hidesBottomBarWhenPushed = YES;
            UINavigationController *nav = self.tabBarController.viewControllers[0];
            chatVC.hidesBottomBarWhenPushed = YES;
            self.tabBarController.selectedViewController = nav;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    
}
- (IBAction)clear:(id)sender {
    [[YKCacheManager sharedManager] removeCacheOnResponse:^(NSDictionary *dic) {
        self.cacheLabel.text = [NSString stringWithFormat:@"%.1fM",[[YKCacheManager sharedManager]getFolderSize]];
    }];
}

- (IBAction)update:(id)sender {

    [self.navigationController pushViewController:[YKAboutUsVC new] animated:YES];
}

- (IBAction)about:(id)sender {

    [self.navigationController pushViewController:[YKAboutUsVC new] animated:YES];
    
}

@end
