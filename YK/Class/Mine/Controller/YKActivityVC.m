//
//  YKActivityVC.m
//  YK
//
//  Created by EDZ on 2018/3/22.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKActivityVC.h"
#import "YKWalletDetailCell.h"

@interface YKActivityVC (){
    YKNoDataView *NoDataView;
}

@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation YKActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"活动通知";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSpacer.width = -8;
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"xiaoxi"] statusDes:@"暂无活动通知" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{
        
    }];
    
    NoDataView.frame = CGRectMake(0, 98+BarH, WIDHT,HEIGHT-162);
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.view addSubview:NoDataView];
    NoDataView.hidden = YES;
    
    [[YKPayManager sharedManager]getWalletDetailPageOnResponse:^(NSDictionary *dic) {
        
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        [self.tableView reloadData];
        NoDataView.hidden = NO;
    }];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    return self.dataArray.count;
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKWalletDetailCell *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKWalletDetailCell" owner:self options:nil][0];
    [bagCell initWithDictionary:self.dataArray[indexPath.row]];
    bagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return bagCell;
}


@end
