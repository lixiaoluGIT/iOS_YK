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
#import "YKHomeVC.h"

@interface YKMySuitBagVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>
{
    YKNoDataView *NoDataView;
    BOOL isHadOrderreceive;//是否预约订单
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

    if (_bagStatus==toBack) {
        [self searchOrders:102];
    }
}

- (void)test{
    [[YKOrderManager sharedManager]toReceiveWithOrderNo:[YKOrderManager sharedManager].ID OnResponse:^(NSDictionary *dic) {
        [self searchOrders:102];
    }];
}
- (void)alert{
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"问题解决" message:@"如果遇到特殊情况无法预约或预约出现问题，需要您主动联系快递上门取件(快递费由衣库平台承担)。收件地址：山东省 青州市 丰收二路 衣库仓储中心,收件人信息：衣库APP,收件人联系方式：182 6441 1625" cancelBtnTitle:@"取消" otherBtnTitle:@"确定"];
   [alertView show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[YKOrderManager sharedManager]clear];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.title = @"衣袋";
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
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 25, 25);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"question-1"] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    [self settingButtons];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(24, BarH+50*WIDHT/375, WIDHT-48, HEIGHT-BarH-50*WIDHT/375) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.tableView];
    
    _buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttom.frame = CGRectMake(0, HEIGHT-50, WIDHT, 50);
    _buttom.backgroundColor = mainColor;
    [self.view addSubview:_buttom];
    [_buttom setTitle:@"\\\\" forState:UIControlStateNormal];
    _buttom.titleLabel.font = [UIFont systemFontOfSize:16];
    [_buttom addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _buttom.hidden = YES;
    self.tableView.hidden = YES;
   
    
    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"dingdan"] statusDes:@"暂无订单" hiddenBtn:YES actionTitle:@"" actionBlock:^{
        
    }];
  
    NoDataView.frame = CGRectMake(0, BarH+HEIGHT/4, WIDHT,HEIGHT-212);
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    NoDataView.backgroundColor = self.view.backgroundColor;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:NoDataView];
}

-(void)settingButtons{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, BarH, WIDHT, 50*WIDHT/375)];
    backView.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
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
    //查询订单,刚进来的时候
    [self searchOrders:self.selectedIndex];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(WIDHT/4*i, BarH, WIDHT /4, 50*WIDHT/375);
        button.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
//        button.titleLabel setf
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        button.clipsToBounds = YES;
//        button.layer.cornerRadius = 15;
        button.tag = 100+i;
        
        if (i == index) {
            button.selected = YES;
            button.titleLabel.font = PingFangSC_Semibold(18);
            [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            self.Button0 = button;
        }
//        [button setBackgroundImage:[UIImage imageNamed:@"白.png"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"红.jpg"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)searchOrders:(NSInteger)orderStatus{

    WeakSelf(weakSelf)
  
    [[YKOrderManager sharedManager]searchOrderWithOrderStatus:orderStatus OnResponse:^(NSMutableArray *array) {
        [self.orderList removeAllObjects];
        self.orderList = [NSMutableArray arrayWithArray:array];
        if (orderStatus==102) {//待归还,判断是否已预约归还
//            [[YKOrderManager sharedManager]queryReceiveOrderOnResponse:^(NSDictionary *dic) {
//                NSString *s = [NSString stringWithFormat:@"%@",dic[@"data"]];
//                if ([s isEqualToString:@"该订单未预约归还"]) {//未预约归还
//                    isHadOrderreceive = NO;
//                }else {//未预约
//                    isHadOrderreceive = YES;
//                }
//
                [weakSelf reloadUI];
//
//            }];

        }else {
            [weakSelf reloadUI];
        }
    }];
}

-(void)buttonAction:(UIButton *)button{
    
    [[YKOrderManager sharedManager]clear];
    
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
        button.titleLabel.font = PingFangSC_Semibold(18);
        [button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [self.Button0 setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        self.Button0.titleLabel.font = PingFangSC_Regular(16);
    }
    self.Button0 = button;
    [self searchOrders:button.tag];
}

- (void)btnClick{
    if (_bagStatus==toReceive) {

        [[YKOrderManager sharedManager]ensureReceiveWithOrderNo:[YKOrderManager sharedManager].ID OnResponse:^(NSDictionary *dic) {
            [self searchOrders:101];
        }];
    }
    if (_bagStatus==toBack) {
        
        //预约归还,push
        
        //春节期间不能归还的判断
        if ([steyHelper validateWithStartTime:@"2018-02-13" withExpireTime:@"2018-02-23"]) {
            DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"平台提示" message:@"小仙女，快递小哥还没回来上班，衣服23号以后预约归还即可，此期间会员期会冻结，不会浪费哦!" cancelBtnTitle:@"好的" otherBtnTitle:@"我知道了"];
            alertView.delegate = self;
            [alertView show];
            return;
        }
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
            if ([YKOrderManager sharedManager].sectionArray.count==1&&([[YKOrderManager sharedManager].sectionArray containsObject:@"2"])) {
                self.tableView.frame = CGRectMake(24, BarH  +50*WIDHT/375, WIDHT-48, HEIGHT-64-50*WIDHT/375);
            }else {
                self.tableView.frame = CGRectMake(24, BarH+50*WIDHT/375, WIDHT-48, HEIGHT-64-50*WIDHT/375);
            }
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

            if ((_bagStatus==toReceive)&&self.orderList.count!=0) {
                _buttom.hidden = NO;
                self.tableView.frame = CGRectMake(24, BarH+50*WIDHT/375, WIDHT-48, HEIGHT-64-50*WIDHT/375-50);
                if (_bagStatus==toReceive) {//待归还
                    if ([YKOrderManager sharedManager].isOnRoad) {
                        [_buttom setTitle:@"确认收货" forState:UIControlStateNormal];
                        _buttom.userInteractionEnabled = YES;
                    }else {
                        [_buttom setTitle:@"待发货" forState:UIControlStateNormal];
                         _buttom.userInteractionEnabled = NO;
                    }
                    
                }else {
//                    if (!isHadOrderreceive) {
//                        [_buttom setTitle:@"预约归还" forState:UIControlStateNormal];
//                         _buttom.titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
//                        _buttom.userInteractionEnabled = YES;
//                    }else {
//                        [_buttom setTitle:@"已预约,等待取件" forState:UIControlStateNormal];
//                        _buttom.titleLabel.textColor = [UIColor colorWithHexString:@"FDDD55"];
//                        _buttom.userInteractionEnabled = NO;
//                    }
                    
                }
            }else {
                self.tableView.frame = CGRectMake(24, BarH+50*WIDHT/375, WIDHT-48, HEIGHT-64-50*WIDHT/375);
                _buttom.hidden = YES;
            }
    
            [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0&&_bagStatus==toReceive) {
        return 46;
    }
    return 170 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_bagStatus==totalBag) {
        
         NSArray *array = [NSArray arrayWithArray:[YKOrderManager sharedManager].totalOrderList[section]];
        if (section==0&&([[YKOrderManager sharedManager].sectionArray containsObject:@"0"])) {
            return array.count;
        }else {
            NSArray *a = [NSArray arrayWithArray:array[0]];
            return a.count;
        }
        
        
    }
    if (_bagStatus==toReceive) {
        return self.orderList.count+1;
    }
    if (_bagStatus==toBack) {
        NSArray *array = [NSArray arrayWithArray:self.orderList[section][@"orderDetailsVoList"]];
        return array.count;
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
    if (_bagStatus == toBack) {
        return self.orderList.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_bagStatus==totalBag) {
        if ([[YKOrderManager sharedManager].sectionArray containsObject:receiveSection]) {
            if (section==0) {
                return 70;
            }
        }
        return 70;
    }
    
    if (_bagStatus==toBack) {
        return 70;
    }
    
    
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_bagStatus==totalBag) {
        NSInteger headerSection = [[YKOrderManager sharedManager].sectionArray[section] integerValue];
        
        YKSuitHeader *header = [[NSBundle mainBundle] loadNibNamed:@"YKSuitHeader" owner:self options:nil][headerSection];
       //物流信息
        header.SMSBlock = ^(void){
            YKSMSInforVC *sms = [YKSMSInforVC new];
            sms.orderNo = [YKOrderManager sharedManager].orderNo;
 
             [self.navigationController pushViewController:sms animated:YES];
        };
        //确认收货
        header.ensureReceiveBlock = ^(void){
            [[YKOrderManager sharedManager]ensureReceiveWithOrderNo:[YKOrderManager sharedManager].ID OnResponse:^(NSDictionary *dic) {
                 [self searchOrders:100];
            }];
        };
        //预约归还
//        if (!isHadOrderreceive) {
            header.yuyue.text = @"等待取件";
//        }
        header.orderBackBlock = ^(void){
            if (isHadOrderreceive) {
                return ;
            }
            YKReturnVC *r = [YKReturnVC new];
            [self.navigationController pushViewController:r animated:YES];
        };
         return header;
    }
    
    if (_bagStatus==toBack) {
        
         YKSuitHeader *header = [[NSBundle mainBundle] loadNibNamed:@"YKSuitHeader" owner:self options:nil][0];
   
        
        [[YKOrderManager sharedManager]queryReceiveOrderNo:self.orderList[section][@"orderNo"] OnResponse:^(NSDictionary *dic) {
            NSString *s = [NSString stringWithFormat:@"%@",dic[@"data"]];
            if ([s isEqualToString:@"该订单未预约归还"]) {//未预约归还
                [header resetUI:0];
                header.SMSBlock = ^(void){
                    [YKOrderManager sharedManager].orderNo = self.orderList[section][@"orderNo"];
                    YKReturnVC *r = [YKReturnVC new];
                    [self.navigationController pushViewController:r animated:YES];
                };
//                isHadOrderreceive = NO;
            }else {//已预约
//                isHadOrderreceive = YES;
                [header resetUI:1];
                //忘给方法了
//                header.SMSBlock = ^(void){
//                    [YKOrderManager sharedManager].orderNo = self.orderList[section][@"orderNo"];
//                    YKReturnVC *r = [YKReturnVC new];
//                    [self.navigationController pushViewController:r animated:YES];
//                };
            }
        }];
      

//        header.SMSBlock = ^(void){
//            [YKOrderManager sharedManager].orderNo = self.orderList[section][@"orderNo"];
//            YKReturnVC *r = [YKReturnVC new];
//            [self.navigationController pushViewController:r animated:YES];
//        };

        return header;
    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_bagStatus == totalBag) {
        static NSString *ID = @"cell1";
        YKSuitEnsureCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
        }
        YKSuit *suit = [[YKSuit alloc]init];
        if ([YKOrderManager sharedManager].totalOrderList.count>0) {
             NSArray *array = [NSArray arrayWithArray:[YKOrderManager sharedManager].totalOrderList[indexPath.section]];//数据源
            if (indexPath.section==0&&([[YKOrderManager sharedManager].sectionArray containsObject:@"0"] )) {
                [suit initWithDictionary:array[indexPath.row]];
            }else {
                [suit initWithDictionary:array[0][indexPath.row]];
            }
        }
        
      
        
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
        if (indexPath.section<self.orderList.count) {
            [suit initWithDictionary:self.orderList[indexPath.section][@"orderDetailsVoList"][indexPath.row]];
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
            YKSMSInforVC *sms = [YKSMSInforVC new];
            //测试数据
//            sms.orderNo = @"238836512256";
            sms.orderNo = [YKOrderManager sharedManager].orderNo;
            [self.navigationController pushViewController:sms animated:YES];
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
    
    //请求商品信息,判断是否下架
    [[YKHomeManager sharedManager]getProductDetailInforWithProductId:[cell.suit.clothingId intValue] OnResponse:^(NSDictionary *dic) {

        if ([dic[@"status"] intValue] == 400) {
            [smartHUD alertText:self.view alert:dic[@"msg"] delay:2];
           
        }else {
            YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
            detail.productId = cell.suit.clothingId;
            detail.titleStr = cell.suit.clothingName;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }];
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_bagStatus != totalBag&&_bagStatus!=toBack) {
        return;
    }
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 69; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)leftAction{
    if (_isFromSuccess) {
        YKHomeVC *chatVC = [[YKHomeVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[0];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
