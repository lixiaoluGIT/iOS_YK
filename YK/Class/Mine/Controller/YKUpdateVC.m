//
//  YKUpdateVC.m
//  YK
//
//  Created by LXL on 2018/2/8.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKUpdateVC.h"

@interface YKUpdateVC ()
@property (weak, nonatomic) IBOutlet UILabel *versionLable;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation YKUpdateVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self checkVersion];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"检查更新";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);//ios7以后右边距默认值18px，负数相当于右移，正数左移
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
}

- (NSString *)getVersionString:(NSString *)str{
    NSString *version = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    return version;
}

- (void)checkVersion{
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    _versionLable.text = [NSString stringWithFormat:@"当前版本:%@",localVersion];
    
    double localVersionDou = [[self getVersionString:localVersion] doubleValue];
    
    NSString *url = [NSString stringWithFormat:@"%@?appVersion=%@",@"/user/checkTheLatestVersion",@"1"];
    
    [YKHttpClient Method:@"GET" URLString:url paramers:nil success:^(NSDictionary *dict) {
        //如果新版本大于当前版本,更新
        double versionNumberMin = [[self getVersionString:dict[@"data"][@"firstVersion"]] doubleValue];
        double versionNumberMax = [[self getVersionString:dict[@"data"][@"newVersion"]] doubleValue];
        if (localVersionDou < versionNumberMin) {//当前版本小于最低版本
            [_updateBtn setTitle:@"去更新" forState:UIControlStateNormal];
            [_updateBtn setUserInteractionEnabled:YES];
            [_updateBtn addTarget:self action:@selector(toUpDate) forControlEvents:UIControlEventTouchUpInside];
        }
        if (localVersionDou > versionNumberMin && localVersionDou < versionNumberMax){//大于最低版本小于最高版本
            [_updateBtn setTitle:@"去更新" forState:UIControlStateNormal];
            [_updateBtn setUserInteractionEnabled:YES];
            [_updateBtn addTarget:self action:@selector(toUpDate) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if (localVersionDou>=versionNumberMax) {
            [_updateBtn setUserInteractionEnabled:NO];
            [_updateBtn setTitle:@"已是最新版本" forState:UIControlStateNormal];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toUpDate{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DownLoad_Url]];
}

@end
