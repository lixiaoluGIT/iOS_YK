//
//  YKAboutUsVC.m
//  YK
//
//  Created by LXL on 2018/1/10.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKAboutUsVC.h"
#import "YKAboutView.h"
#import "YKWebVC.h"

@interface YKAboutUsVC ()

@property (nonatomic,strong)YKAboutView *aboutUSView;

@end

@implementation YKAboutUsVC

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
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
    title.font = PingFangSC_Regular(17);
    
    _aboutUSView = [[NSBundle mainBundle] loadNibNamed:@"YKAboutView" owner:self options:nil][0];
    _aboutUSView.selectionStyle = UITableViewCellSelectionStyleNone;
    _aboutUSView.frame = CGRectMake(0, 64, WIDHT, HEIGHT-64);
    WeakSelf(weakSelf)
    _aboutUSView.toXieYi = ^(void){
        YKWebVC *web = [YKWebVC new];
        web.titleStr = @"用户协议";
        web.imageName = @"用户协议";
        [weakSelf.navigationController pushViewController:web animated:YES];
    };
    [self.view addSubview:_aboutUSView];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
