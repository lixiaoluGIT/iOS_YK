//
//  YKMySuitBagVC.m
//  YK
//
//  Created by LXL on 2017/11/20.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMySuitBagVC.h"
#import "YKSuitEnsureCell.h"
#import "YKMyBagSMSCell.h"
#import "YKReturnVC.h"
#import "YKSMSInforVC.h"
#import "YKSuitHeader.h"
#import "YKProductDetailVC.h"

@interface YKMySuitBagVC ()<UITableViewDelegate,UITableViewDataSource>
{
    YKNoDataView *NoDataView;
}
@property (nonatomic,strong) UIButton *Button0;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *buttom;
@property (nonatomic,assign) suitBagStatus bagStatus;
@property (nonatomic,strong) NSMutableArray *orderList;//待签收
@property (nonatomic,strong) NSString *orderNo;//订单号
@end

@implementation YKMySuitBagVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [[YKOrderManager sharedManager]clear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[YKOrderManager sharedManager]clear];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.title = @"衣袋";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];

    [self settingButtons];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+HEIGHT/10+15, WIDHT, HEIGHT-64-HEIGHT/10-15) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    _buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttom.frame = CGRectMake(0, HEIGHT-50, WIDHT, 50);
    _buttom.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
    [self.view addSubview:_buttom];
    [_buttom setTitle:@"\\\\" forState:UIControlStateNormal];
    _buttom.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttom addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _buttom.hidden = YES;
    self.tableView.hidden = YES;
   
    
    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"dingdan"] statusDes:@"暂无订单" hiddenBtn:YES actionTitle:@"" actionBlock:^{
        
    }];
  
    NoDataView.frame = CGRectMake(0, 64+HEIGHT/4, WIDHT,HEIGHT-212);
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    NoDataView.backgroundColor = self.view.backgroundColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:NoDataView];
}

-(void)settingButtons{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDHT, HEIGHT/10)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    NSArray *arr  =[NSArray arrayWithObjects:@"全部衣袋",@"待签收",@"待归还",@"已归还", nil];
    int index = 0;
    if (self.selectedIndex == 100) {
        index = 0;
        _bagStatus = totalBag;
    }
    if (self.selectedIndex == 101) {
        _bagStatus = toReceive;
        index = 1;
    }
    if (self.selectedIndex == 102) {
        index = 2;
        _bagStatus = toBack;
    }
    if (self.selectedIndex == 103) {
        index = 3;
        _bagStatus = hadBack;
    }
    //查询订单
    [self searchOrders:self.selectedIndex];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+((WIDHT-50)/4+10)*i, 64+(HEIGHT/10-30)/2, (WIDHT -50)/4, 30);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 15;
        button.tag = 100+i;
        
        if (i == index) {
            button.selected = YES;
            self.Button0 = button;
        }
        [button setBackgroundImage:[UIImage imageNamed:@"白.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"主题红.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)searchOrders:(NSInteger)orderStatus{

    WeakSelf(weakSelf)
  
    [[YKOrderManager sharedManager]searchOrderWithOrderStatus:orderStatus OnResponse:^(NSMutableArray *array) {
        [self.orderList removeAllObjects];
        self.orderList = [NSMutableArray arrayWithArray:array];
        [weakSelf reloadUI];
    }];
}

-(void)buttonAction:(UIButton *)button{
    
    self.tableView.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    
    if (button.tag == 100) {
        
        _bagStatus = totalBag;
    }
    if (button.tag == 101) {
        _bagStatus = toReceive;
        
    }
    if (button.tag == 102) {
        _bagStatus = toBack;
    }
    if (button.tag == 103) {
        _bagStatus = hadBack;
    }
    if (self.Button0 != button) {
        self.Button0.selected = NO;
        button.selected = YES;
    }
    self.Button0 = button;
    [self searchOrders:button.tag];
}

- (void)btnClick{
    if (_bagStatus==toReceive) {
        //确认收货
        [[YKOrderManager sharedManager]ensureReceiveOnResponse:^(NSDictionary *dic) {
            
        }];
    }
    if (_bagStatus==toBack) {
        //预约归还,push
        YKReturnVC *r = [YKReturnVC new];
        [self.navigationController pushViewController:r animated:YES];
    }
}

- (void)reloadUI{

    if (_bagStatus == totalBag) {
        if ([YKOrderManager sharedManager].totalOrderList.count==0) {
            self.tableView.hidden = YES;
            NoDataView.hidden = NO;
            _buttom.hidden = YES;
        }else {
            self.tableView.frame = CGRectMake(0, 64+HEIGHT/10+15, WIDHT, HEIGHT-64-HEIGHT/10-15);
            self.tableView.hidden = NO;
            _buttom.hidden = YES;
            NoDataView.hidden = YES;
        }
        [self.tableView reloadData];
        return;
    }
    
        if (self.orderList.count==0) {
            self.tableView.hidden = YES;
            NoDataView.hidden = NO;
            _buttom.hidden = YES;
        }else {
            self.tableView.hidden = NO;
            _buttom.hidden = NO;
            NoDataView.hidden = YES;
        }
        //请求成功后
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if ((_bagStatus==toReceive||_bagStatus==toBack)&&self.orderList.count!=0) {
                _buttom.hidden = NO;
                self.tableView.frame = CGRectMake(0, 64+HEIGHT/10+15, WIDHT, HEIGHT-64-HEIGHT/10-15-50);
                if (_bagStatus==toReceive) {
                    [_buttom setTitle:@"确认收货" forState:UIControlStateNormal];
                }else {
                    [_buttom setTitle:@"预约归还" forState:UIControlStateNormal];
                }
            }else {
                self.tableView.frame = CGRectMake(0, 64+HEIGHT/10+15, WIDHT, HEIGHT-64-HEIGHT/10-15);
                _buttom.hidden = YES;
            }
    
            [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0&&_bagStatus==toReceive) {
        return 64;
    }
    return 145;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_bagStatus==totalBag) {
        NSArray *array = [NSArray arrayWithArray:[YKOrderManager sharedManager].totalOrderList[section]];
        return array.count;
    }
    if (_bagStatus==toReceive) {
        return self.orderList.count+1;
    }
    if (_bagStatus==toBack) {
        return self.orderList.count;
    }
    if (_bagStatus==hadBack) {
        return self.orderList.count;
    }
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_bagStatus==totalBag) {
       
        return [YKOrderManager sharedManager].totalOrderList.count;

    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_bagStatus==totalBag) {
        if ([[YKOrderManager sharedManager].sectionArray containsObject:receiveSection]) {
            if (section==0) {
                return 55;
            }
        }
        return 70;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_bagStatus==totalBag) {
        NSInteger headerSection = [[YKOrderManager sharedManager].sectionArray[section] integerValue];
        YKSuitHeader *header = [[NSBundle mainBundle] loadNibNamed:@"YKSuitHeader" owner:self options:nil][headerSection];
        header.SMSBlock = ^(void){
             [self.navigationController pushViewController:[YKSMSInforVC new] animated:YES];
        };
        header.ensureReceiveBlock = ^(void){
            [[YKOrderManager sharedManager]ensureReceiveOnResponse:^(NSDictionary *dic) {
                
            }];
        };
        header.orderBackBlock = ^(void){
            YKReturnVC *r = [YKReturnVC new];
            [self.navigationController pushViewController:r animated:YES];
        };
         return header;
    }
    
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_bagStatus == totalBag) {
        static NSString *ID = @"cell1";
        YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
        }
        YKSuit *suit = [[YKSuit alloc]init];
         NSArray *array = [NSArray arrayWithArray:[YKOrderManager sharedManager].totalOrderList[indexPath.section]];//数据源
     
        [suit initWithDictionary:array[indexPath.row]];
        mycell.suit = suit;
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    if (_bagStatus == toBack) {
        static NSString *ID = @"cell2";
        YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
        }
        YKSuit *suit = [[YKSuit alloc]init];
        if (indexPath.row<self.orderList.count) {
            [suit initWithDictionary:self.orderList[indexPath.row]];
        }
        mycell.suit = suit;
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    if (_bagStatus == hadBack) {
        static NSString *ID = @"cell3";
        YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
        }
        YKSuit *suit = [[YKSuit alloc]init];
        if (indexPath.row<self.orderList.count) {
            [suit initWithDictionary:self.orderList[indexPath.row]];
        }
        mycell.suit = suit;
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    if (indexPath.row==0&&_bagStatus == toReceive) {
        static NSString *ID = @"SMScell";
        YKMyBagSMSCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMyBagSMSCell" owner:self options:nil][0];
        }
        mycell.scanSMSBlock = ^(void){
            [self.navigationController pushViewController:[YKSMSInforVC new] animated:YES];
        };
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    static NSString *ID = @"cell5";
    YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
    }
    YKSuit *suit = [[YKSuit alloc]init];
    if (indexPath.row-1<self.orderList.count) {
        [suit initWithDictionary:self.orderList[indexPath.row-1]];
    }
    
    mycell.suit = suit;
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     YKSuitEnsureCell*cell = (YKSuitEnsureCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
    detail.productId = cell.suit.clothingId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
