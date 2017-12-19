//
//  YKReturnVC.m
//  YK
//
//  Created by LXL on 2017/11/29.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKReturnVC.h"
#import "YKReturnView.h"
#import "YKReturnAddressView.h"

@interface YKReturnVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
    UIButton *_buttom;
}
@end

@implementation YKReturnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预约归还";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;
    
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 25, 25);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"tel"] forState:UIControlStateNormal];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[YKReturnAddressView class] forCellReuseIdentifier:@"address"];
     [tableView registerClass:[YKReturnView class] forCellReuseIdentifier:@"time"];
    tableView.estimatedRowHeight = 30;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttom.frame = CGRectMake(0, HEIGHT-50, WIDHT, 50);
    _buttom.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
    [self.view addSubview:_buttom];
    [_buttom setTitle:@"确认预约" forState:UIControlStateNormal];
    _buttom.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttom addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)releaseInfo{
    
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnClick{
    //确认预约
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
    }
    if (indexPath.row==1) {
        return 150;
    }
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        YKReturnView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKReturnView" owner:self options:nil][0];
        bagCell.selectionStyle = UITableViewCellEditingStyleNone;
        return bagCell;
    }
    if (indexPath.row == 2) {
        YKReturnAddressView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKReturnAddressView" owner:self options:nil][1];
         bagCell.selectionStyle = UITableViewCellEditingStyleNone;
        return bagCell;
    }
    YKReturnAddressView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKReturnAddressView" owner:self options:nil][0];
     bagCell.selectionStyle = UITableViewCellEditingStyleNone;
    return bagCell;
}

@end
