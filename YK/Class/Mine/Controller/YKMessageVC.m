//
//  YKMessageVC.m
//  YK
//
//  Created by LXL on 2017/12/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMessageVC.h"
#import "YKTotalMsgView.h"
#import "YKTotalSMSVC.h"
@interface YKMessageVC ()

@end

@implementation YKMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getMessageList];
    
    YKTotalMsgView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKTotalMsgView" owner:self options:nil][0];
    bagCell.selectionStyle = UITableViewCellEditingStyleNone;
    bagCell.frame = CGRectMake(0, 64,WIDHT,HEIGHT-64);
    bagCell.ToSMSBlock = ^(void){
        [self.navigationController pushViewController:[YKTotalSMSVC new] animated:YES];
    };
    [self.view addSubview:bagCell];
}

- (void)getMessageList{
    [[YKMessageManager sharedManager]getMessageListOnResponse:^(NSDictionary *dic) {
        
    }];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
