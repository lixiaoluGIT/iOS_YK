//
//  YKTotalSMSVC.m
//  YK
//
//  Created by LXL on 2017/12/18.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKTotalSMSVC.h"
#import "YKTotalSMSCell.h"
#import "YKSMSInforVC.h"

@interface YKTotalSMSVC (){
    YKNoDataView *NoDataView;
}

@property (nonatomic,strong)NSArray *SMSList;
@end

@implementation YKTotalSMSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"交易物流信息";
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
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"xiaoxi"] statusDes:@"暂无物流通知" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{
        
    }];
    
    NoDataView.frame = CGRectMake(0, 98+BarH, WIDHT,HEIGHT-162);
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:NoDataView];
    NoDataView.hidden = YES;

    [self getMessageList];
}

- (void)getMessageList{
    //物流消息
    [[YKMessageManager sharedManager]getMessageListMsgType:1 OnResponse:^(NSArray *array) {
        self.SMSList = [NSArray arrayWithArray:array];
        if (array.count == 0) {
            NoDataView.hidden = NO;
        }else {
            NoDataView.hidden = YES;
        }
        [self.tableView reloadData];
    }];
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.SMSList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKTotalSMSCell *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKTotalSMSCell" owner:self options:nil][0];
     NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.SMSList[indexPath.row]];
    [bagCell initWithDictionary:dic];
    bagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return bagCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKTotalSMSCell *smsCell = (YKTotalSMSCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.SMSList[indexPath.row]];
    YKSMSInforVC *infor = [YKSMSInforVC new];
//    infor.orderNo = @"238836512256";
    infor.orderNo = smsCell.orderNo;
    [self.navigationController pushViewController:infor animated:YES];
}
@end
