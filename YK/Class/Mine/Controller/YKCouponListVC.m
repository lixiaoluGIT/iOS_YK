//
//  YKCouponListVC.m
//  YK
//
//  Created by edz on 2018/7/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCouponListVC.h"
#import "YKCouponView.h"
#import "YKToBeVIPVC.h"
#import "YKCouponCodeView.h"

@interface YKCouponListVC (){
    NSInteger couponType;
}
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)YKNoDataView *NoDataView;

@end

@implementation YKCouponListVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.title = @"衣库优惠券";
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
    _NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [_NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"zanwu"] statusDes:@"暂无卡劵" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{
        
    }];
    
    _NoDataView.frame = CGRectMake(0, 98+BarH, WIDHT,HEIGHT-162);
//    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:_NoDataView];
    _NoDataView.hidden = YES;
}

- (void)getData{
    //可使用,显示兑换码
    if ([UD boolForKey:@"effectiveCoupun"] == YES) {
        couponType = 1;//可使用
        YKCouponCodeView *headView = [[NSBundle mainBundle] loadNibNamed:@"YKCouponCodeView" owner:self options:nil][0];
        headView.selectionStyle = UITableViewCellSelectionStyleNone;
        headView.frame = CGRectMake(0, 0, WIDHT, 100);
        UIView * view = [[UIView alloc] initWithFrame:headView.frame];
        headView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [view addSubview:headView];
 
        self.tableView.tableHeaderView = view;
    }else {
        couponType = 2;//不可使用
    }
    
    if (_isFromPay) {
        couponType = 1;//可使用
    }
    
    [[YKUserManager sharedManager]getWalletDetailPageOnResponse:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];
    
        self.dataArray = [NSArray arrayWithArray:dic[@"data"]];
      
        
        NSMutableArray *currentArray = [NSMutableArray array];
        if (couponType==1) {//可使用
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"couponStatus"] intValue] == 1){//可使用
                    [currentArray addObject:dic];
                }
            }
            self.dataArray = [NSArray arrayWithArray:currentArray];
        }else {//已过期
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"couponStatus"] intValue] == 3){//已过期
                    [currentArray addObject:dic];
                }
            }
            self.dataArray = [NSArray arrayWithArray:currentArray];
        }
        
        if (self.dataArray.count == 0) {
            _NoDataView.hidden = NO;
        }else {
            _NoDataView.hidden = YES;
        }
        
        [self.tableView reloadData];
    }];
    
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKCouponView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][0];
    [bagCell initWithDic:self.dataArray[indexPath.row]];
    bagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return bagCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKCouponView *cell = (YKCouponView *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.couponStatus==2) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"已使用" delay:1.5];
        return;
    }
    if (cell.couponStatus==3) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"已过期" delay:1.5];
        return;
    }
    if (cell.couponType==1) {//加时卡
        [[YKUserManager sharedManager]useCouponId:[[NSNumber numberWithInteger:cell.couponID]stringValue] OnResponse:^(NSDictionary *dic) {
                [self getData];//刷新数据
        }];
        return;
    }
    if (cell.couponType==2) {//优惠劵
        if (_isFromPay) {
            if (self.selectCoupon) {
                self.selectCoupon(cell.couponNum,cell.couponID);
            }
            [self leftAction];
            return;
        }
        YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
        [YKUserManager sharedManager].couponNum = cell.couponNum;
        [YKUserManager sharedManager].couponID = cell.couponID;
        [YKUserManager sharedManager].isFromCoupon = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
        [self presentViewController:nav animated:YES completion:^{
        }];
    }
}
@end
