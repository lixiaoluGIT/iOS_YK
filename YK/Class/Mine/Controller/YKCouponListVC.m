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
#import "YKSuitVC.h"
#import "YKCartVC.h"

@interface YKCouponListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger couponType;
}
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)YKNoDataView *NoDataView;

//@property (nonatomic,assign) NSInteger couponStatus;
@property (nonatomic,strong) UILabel *line;
@property (nonatomic,strong) UIButton *Button0;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation YKCouponListVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self getData];
        if (_couponStatus==2) {//加衣劵
            //请求加衣劵
            [self getAddCC];
        }else {//加时卡，优惠劵
            [self getData];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.title = @"我的卡劵";
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
    title.font = PingFangSC_Medium(kSuitLength_H(14));
    self.navigationItem.titleView = title;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [_NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"zanwu"] statusDes:@"暂无卡劵" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{
        
    }];
    
    _NoDataView.frame = CGRectMake(0, 98+BarH, WIDHT,HEIGHT-162);
//    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:_NoDataView];
    _NoDataView.hidden = YES;
    
    [self settingButtons];
}


-(void)settingButtons{
//    _couponStatus = 1;
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, BarH , WIDHT, 50*WIDHT/375)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    NSArray *arr  =[NSArray arrayWithObjects:@"加时卡",@"优惠劵",@"加衣劵", nil];
    int index = 0;
    if (self.selectedIndex == 100) {
        index = 0;
        _couponStatus = 0;
    }
    if (self.selectedIndex == 101) {
        _couponStatus = 1;
        index = 1;
    }
    if (self.selectedIndex == 102) {
        index = 2;
        _couponStatus = 2;
    }
   
    _line.frame = CGRectMake(WIDHT/6+WIDHT/3*index-kSuitLength_H(30), kSuitLength_H(45), kSuitLength_H(30), 1);
    //查询数据
//    [self searchOrders:self.selectedIndex];
    if (_couponStatus==2) {//加衣劵
        //请求加衣劵
        [self getAddCC];
    }else {//加时卡，优惠劵
        [self getData];
    }
    
    
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WIDHT/3*i, 0, WIDHT /3, kSuitLength_H(50));
        button.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
        [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        //        button.titleLabel setf
        [button setTitleColor:YKRedColor forState:UIControlStateSelected];
        //        button.clipsToBounds = YES;
        //        button.layer.cornerRadius = 15;
        button.tag = 100+i;
        
        if (i == index) {
            button.selected = YES;
            button.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
            [button setTitleColor:YKRedColor forState:UIControlStateNormal];
            self.Button0 = button;
        }

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(WIDHT/8-kSuitLength_H(30)/2, kSuitLength_H(50)-1, kSuitLength_H(30), 1)];
    _line.backgroundColor = YKRedColor;
    _line.frame = CGRectMake(WIDHT/6+WIDHT/3*index-kSuitLength_H(30)/2, kSuitLength_H(45), kSuitLength_H(30), 1);
    [backView addSubview:_line];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,backView.bottom, WIDHT, HEIGHT-kSuitLength_H(50)-BarH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)getAddCC{
    [[YKSuitManager sharedManager]searchAddCCOnResponse:^(NSDictionary *dic) {
        //得到总衣位数
        [self.tableView.mj_header endRefreshing];
       
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        
        self.dataArray = [NSArray arrayWithArray:array];
        if (self.dataArray.count == 0) {
            _NoDataView.hidden = NO;
            self.tableView.hidden = YES;
        }else {
            _NoDataView.hidden = YES;
            self.tableView.hidden = NO;
            
        }
        [self.tableView reloadData];
    }];
       
}
-(void)buttonAction:(UIButton *)button{
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    
    int index = 0;
    if (button.tag == 100) {
        index=0;
        _couponStatus = 0;
    }
    if (button.tag == 101) {
        index=1;
        _couponStatus = 1;
    }
    if (button.tag == 102) {
        index=2;
        _couponStatus = 2;
    }
  
    
    [UIView animateWithDuration:0.3 animations:^{
        _line.frame = CGRectMake(WIDHT/6+WIDHT/3*index-kSuitLength_H(30)/2, kSuitLength_H(45), kSuitLength_H(30), 1);
    }];
    
    if (self.Button0 != button) {
        self.Button0.selected = NO;
        button.selected = YES;
        button.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
        [button setTitleColor:YKRedColor forState:UIControlStateNormal];
        [self.Button0 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        self.Button0.titleLabel.font =  PingFangSC_Medium(kSuitLength_H(14));
    }
    self.Button0 = button;
//    [self searchOrders:button.tag];
    if (_couponStatus==2) {//加衣劵
        //请求加衣劵
        [self getAddCC];
    }else {//加时卡，优惠劵
        [self getData];
    }
}
- (void)getData{
    //可使用,显示兑换码
//    if ([UD boolForKey:@"effectiveCoupun"] == YES) {
//        couponType = 1;//可使用
//        YKCouponCodeView *headView = [[NSBundle mainBundle] loadNibNamed:@"YKCouponCodeView" owner:self options:nil][0];
//        headView.selectionStyle = UITableViewCellSelectionStyleNone;
//        headView.frame = CGRectMake(0, 0, WIDHT, 100);
//        UIView * view = [[UIView alloc] initWithFrame:headView.frame];
//        headView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [view addSubview:headView];
//
//        self.tableView.tableHeaderView = view;
//    }else {
//        couponType = 2;//不可使用
////    }
//
//    if (_isFromPay) {
//        couponType = 1;//可使用
//    }
    
    [[YKUserManager sharedManager]getWalletDetailPageOnResponse:^(NSDictionary *dic) {
        [self.tableView.mj_header endRefreshing];

        self.dataArray = [NSArray arrayWithArray:dic[@"data"]];
      
        
        NSMutableArray *currentArray = [NSMutableArray array];
        if (_couponStatus==1) {//优惠劵
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"couponStatus"] intValue] == 1){//可使用
                    if ([dic[@"couponType"] intValue] == 2) {//优惠劵
                        [currentArray addObject:dic];
                    }
                    
                }
            }
            self.dataArray = [NSArray arrayWithArray:currentArray];
        }
        if (_couponStatus==0) {//加时卡
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"couponStatus"] intValue] == 1){//可使用
                  
                    if ([dic[@"couponType"] intValue] == 1) {//加时卡
                        [currentArray addObject:dic];
                    }
                }
            }
            self.dataArray = [NSArray arrayWithArray:currentArray];
        }
//        else {//已过期
//            for (NSDictionary *dic in self.dataArray) {
//                if ([dic[@"couponType"] intValue] == 3){//已过期
//                    [currentArray addObject:dic];
//                }
//            }
//            self.dataArray = [NSArray arrayWithArray:currentArray];
//        }
        
        if (self.dataArray.count == 0) {
            _NoDataView.hidden = NO;
            self.tableView.hidden = YES;
        }else {
            _NoDataView.hidden = YES;
            self.tableView.hidden = NO;
        }
        
        [self.tableView reloadData];
    }];
    
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSuitLength_H(120);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKCouponView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][0];
    if (_couponStatus==2) {
        [bagCell initWithD:self.dataArray[indexPath.row]];
    }else {
        [bagCell initWithDic:self.dataArray[indexPath.row]];
    }
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
    if (cell.couponType==5) {//加衣券
        //到衣袋页
        if (_isFromSuit) {
            if (self.selectCoupon) {
                self.selectCoupon(cell.couponNum,cell.couponID);
            }
//            [self leftAction];
//            return;
        }
        YKCartVC *search = [[YKCartVC alloc] init];
                        search.hidesBottomBarWhenPushed = YES;
                        UINavigationController *nav = self.tabBarController.viewControllers[3];
                        search.hidesBottomBarWhenPushed = YES;
                        self.tabBarController.selectedViewController = nav;
                        [self.navigationController popToRootViewControllerAnimated:YES];
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
