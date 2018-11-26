//
//  YKSignalSuitVC.m
//  YK
//
//  Created by edz on 2018/11/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSignalSuitVC.h"
#import "YKNewSuitCell.h"
#import "YKAddCell.h"
#import "YKSearchVC.h"
#import "YKBuyAddCCVC.h"
#import "YKSuitDetailVC.h"
#import "YKSuitVC.h"
#import "YKProductDetailVC.h"
#import "YKSPDetailVC.h"
#import "YKLoginVC.h"
#import "YKCartHeader.h"
#import "YKCouponListVC.h"
#import "YKMyLoveVC.h"

@interface YKSignalSuitVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>
{
    NSInteger maxClothesNum;//最大衣位数
    NSInteger currentClothesNum;//当前衣位数
    YKNoDataView *NoDataView;
    YKCartHeader *cartheader;
    
    NSInteger totalNum;//总衣位数
    NSInteger useNum;//已占用衣位数
    NSInteger leaseNum;//剩余衣位数
    NSInteger ccNum;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSString *shoppingId;
@end

@implementation YKSignalSuitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    maxClothesNum = 4;
    currentClothesNum=3;
    
//    //    [self searchAddCloth];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
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
    title.font = PingFangSC_Medium(kSuitLength_H(14));
    self.navigationItem.titleView = title;
    
    [self creatHeader];
    [self creatTableView];
    [self creatButtom];
}

- (void)getNum{
    //查询加衣劵
    [[YKSuitManager sharedManager]searchAddCCOnResponse:^(NSDictionary *dic) {
        //得到总衣位数
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        ccNum = array.count;
        if (array.count>0) {//有加衣劵
            totalNum = 4;
            
        }else {//没加衣劵
            totalNum = 3;
            
        }
        
        //购物车已有衣位。请求购物车
        [[YKSuitManager sharedManager]getShoppingListOnResponse:^(NSDictionary *dic) {
            NSArray *array = [NSMutableArray arrayWithArray:dic[@"data"]];
            //得到已用衣位数
            NSInteger use=0;
            for (NSDictionary *dic in array) {
                YKSuit *suit = [[YKSuit alloc]init];
                [suit initWithDictionary:dic];
                NSInteger a = [suit.ownedNum intValue];
                use = use + a;
            }
            useNum = use;
            //可用衣位数 = 总衣位-已用衣位数
            leaseNum = totalNum-useNum;
            //            [buttom setTitle:[NSString stringWithFormat:@"加入衣袋 (%ld/%ld)",useNum,totalNum] forState:UIControlStateNormal];
            
        }];
    }];
}


- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAddCloth{
    //查询加衣劵
    [[YKSuitManager sharedManager]searchAddCCOnResponse:^(NSDictionary *dic) {
        [self getCartList];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    [self searchAddCloth];
    //    [self getCartList];
    //
    //    [self getNum];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if ([Token length] == 0) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        //        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
        //            [self searchAddCloth];
        //            [self getNum];
        //        }];
        return;
    }
    [self searchAddCloth];
    [self getNum];
}

- (void)getCartList{
    [[YKSuitManager sharedManager]getShoppingListOnResponse:^(NSDictionary *dic) {
        self.tableView.hidden = NO;
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        if (self.dataArray.count>4) {
            NSMutableArray *a = [NSMutableArray array];
            [a addObject:self.dataArray[0]];
            [a addObject:self.dataArray[1]];
            [a addObject:self.dataArray[2]];
            [a addObject:self.dataArray[3]];
            [self.dataArray removeAllObjects];
            self.dataArray = [NSMutableArray arrayWithArray:a];
        }
        
        [[YKSuitManager sharedManager].suitArray removeAllObjects];
        for (NSDictionary *dic in self.dataArray) {
            YKSuit *suit = [[YKSuit alloc]init];
            [suit initWithDictionary:dic];
            if (![[YKSuitManager sharedManager].suitArray containsObject:suit]) {
                [[YKSuitManager sharedManager].suitArray addObject:suit];
                NSLog(@"%ld",[YKSuitManager sharedManager].suitArray.count);
            }
        }
        
        cartheader.isHadCC = [YKSuitManager sharedManager].isHadCC;
        [self.tableView reloadData];
    }];
}

- (void)creatHeader{
    WeakSelf(weakSelf)
    cartheader = [[NSBundle mainBundle]loadNibNamed:@"YKCartHeader" owner:nil options:nil][0];
    cartheader.frame = CGRectMake(0, NAVH, WIDHT, kSuitLength_H(74));
    //    cartheader.isHadCC = [YKSuitManager sharedManager].isHadCC;
    cartheader.btnAction = ^(BOOL isHadCC){
        if ([Token length] == 0) {
            [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
                [self searchAddCloth];
                [self getNum];
                
            }];
            //            YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
            //                [weakSelf presentViewController:login animated:YES completion:^{
            //
            //                }];
            //                login.hidesBottomBarWhenPushed = YES;
            return;
            
        }
        if (isHadCC) {//使用加衣券，去选加衣券
            YKCouponListVC *list = [[YKCouponListVC alloc]init];
            list.hidesBottomBarWhenPushed = YES;
            //            list.selectCoupon = <#^(NSInteger CouponNum, int CouponId)#>
            
            [weakSelf.navigationController pushViewController:list animated:YES];
        }else{//购买加衣券，去购买界面
            YKBuyAddCCVC *buy = [[YKBuyAddCCVC alloc]init];
            buy.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:buy animated:YES];
        }
    };
    [self.view addSubview:cartheader];
}

- (void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NAVH + kSuitLength_H(73), WIDHT, kSuitLength_H(500)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)creatButtom{
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    //    if (WIDHT==320) {
    //        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414-50, self.view.frame.size.width, 56*WIDHT/414);
    //    }
    //    if (WIDHT==375){
    //        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414-50, self.view.frame.size.width, 56*WIDHT/414);
    //    }
    //    if (WIDHT==414){
    //        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414-50, self.view.frame.size.width, 56*WIDHT/414);
    //    }
    //
    //    if (HEIGHT==812){
    //        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414-50-30, self.view.frame.size.width, 56*WIDHT/414);
    //    }
    //    if (_isFromeProduct) {
    //        if (WIDHT==320) {
    //            buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    //        }
    //        if (WIDHT==375){
    //            buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    //        }
    //        if (WIDHT==414){
    //            buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    //        }
    //
    //    }
    buttom.frame = CGRectMake(kSuitLength_H(60), HEIGHT-kSuitLength_H(50), kSuitLength_H(255), kSuitLength_H(36));
    buttom.backgroundColor = YKRedColor;
    [buttom setTitle:@"确认衣袋" forState:UIControlStateNormal];
    [buttom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttom.layer.masksToBounds = YES;
    buttom.layer.cornerRadius = kSuitLength_H(18);
    buttom.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
    [buttom addTarget:self action:@selector(toRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttom];
}

- (void)toRelease{
    
    if ([Token length] == 0) {
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            [self searchAddCloth];
            [self getNum];
        }];
        //        YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
        //        [self presentViewController:login animated:YES completion:^{
        //
        //        }];
        //        login.hidesBottomBarWhenPushed = YES;
        return;
    }
    
    if (self.dataArray.count==0) {
        [smartHUD alertText:self.view alert:@"请先添加衣物" delay:2];
        return;
    }
    //判断当前衣服是否有无库存状态
    
    
    for (NSDictionary *dic in self.dataArray) {
        YKSuit *suit = [[YKSuit alloc]init];
        [suit initWithDictionary:dic];
        if ([suit.clothingStockNum isEqual:@"0"]) {
            [smartHUD alertText:self.view alert:@"存在待返架衣物" delay:1.4];
            return;
        }
    }
    
    YKSuitDetailVC *detail = [YKSuitDetailVC new];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.dataArray.count) {
        return kSuitLength_H(130);
    }
    return kSuitLength_H(100);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [YKSuitManager sharedManager].isHadCC?4:3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row<self.dataArray.count) {
        static NSString *ll = @"c";
        YKNewSuitCell *cell = [tableView dequeueReusableCellWithIdentifier:ll];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YKNewSuitCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        YKSuit *suit = [[YKSuit alloc]init];
        [suit initWithDictionary:self.dataArray[indexPath.row]];
        cell.suit = suit;
        cell.deleteBlock = ^(NSString *shopCartId){
            [self deleteProduct:shopCartId];
        };
        return cell;
    }
    
    YKAddCell *mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAddCell" owner:self options:nil][0];
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //去详情
    if (indexPath.row<self.dataArray.count) {
        YKNewSuitCell *mycell = (YKNewSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        //        if (mycell.suit.classify==1) {
        YKProductDetailVC *detail = [YKProductDetailVC new];
        detail.productId = mycell.suitId;
        detail.titleStr = mycell.suit.clothingName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        //        }else {
        //            YKSPDetailVC *detail = [YKSPDetailVC new];
        //            detail.productId = mycell.suitId;
        //            detail.titleStr = mycell.suit.clothingName;
        //            detail.hidesBottomBarWhenPushed = YES;
        //            [self.navigationController pushViewController:detail animated:YES];
        //        }
    }else {
        if ([Token length] == 0) {
            [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
                [self searchAddCloth];
                [self getNum];
            }];
            //            YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
            //            [self presentViewController:login animated:YES completion:^{
            //
            //            }];
            //            login.hidesBottomBarWhenPushed = YES;
            return;
        }
        //如果当前衣位已满
        if (leaseNum<=0) {
            [smartHUD alertText:self.view alert:@"衣位已满" delay:1.4];
            return;
        }
        //去心愿单
        YKMyLoveVC *chatVC = [[YKMyLoveVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[2];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:YES];
        //        YKSuitVC *suit = [YKSuitVC new];
        //        suit.isFromeProduct = YES;
        //        suit.isAuto = NO;
        //        suit.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:suit animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //    if (WIDHT==375) {
    //        if ([YKSuitManager sharedManager].isHadCC){
    //            return 20;
    //        }
    //    }
    return CGFLOAT_MIN;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *foot = [[UIView alloc]init];
//    UILabel *lable = [[UILabel alloc]init];
//    [foot addSubview:lable];
//    if (![YKSuitManager sharedManager].isHadCC) {
//
//        lable.text = @"还想继续选衣服？立即购买加衣劵> ";
//        lable.font = PingFangSC_Medium(12);
//        lable.textColor = [UIColor colorWithHexString:@"1a1a1a"];
//        [foot setUserInteractionEnabled:YES];
//
//
//        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(foot.right).offset(-20);
//            make.centerY.mas_equalTo(foot);
//        }];
//    }else {
//        UILabel *l = [[UILabel alloc]init];
//        l.text = [NSString stringWithFormat:@"加衣劵剩余%ld张",(long)ccNum];
//        l.textColor = mainColor;
//        l.font = PingFangSC_Medium(kSuitLength_H(12));
//        [foot addSubview:l];
//
//        lable.text = @"下单时不满4件衣服，不消耗加衣劵";
//        lable.font = PingFangSC_Medium(kSuitLength_H(12));
//        lable.textColor = [UIColor colorWithHexString:@"7a7a7a"];
//        [foot setUserInteractionEnabled:NO];
//
//        [l mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(foot.right).offset(-20);
//            make.top.mas_equalTo(kSuitLength_H(4));
//
//        }];
//
//        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(foot.right).offset(-20);
//            make.top.mas_equalTo(l.mas_bottom).offset(kSuitLength_H(4));
//        }];
//    }
//
//
//
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//        if ([Token length] == 0) {
//            YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
//            [self presentViewController:login animated:YES completion:^{
//
//            }];
//            login.hidesBottomBarWhenPushed = YES;
//            return;
//        }
//        YKBuyAddCCVC *buyadd = [[YKBuyAddCCVC alloc]init];
//        buyadd.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:buyadd animated:YES];
//    }];
//    [foot addGestureRecognizer:tap];
//    return foot;
//}

- (void)deleteProduct:(NSString *)shopCartId{
    self.shoppingId = shopCartId;
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"温馨提示" message:@"确定移除衣袋吗？" cancelBtnTitle:@"暂不" otherBtnTitle:@"是的"];
    aleart.delegate = self;
    [aleart show];
    
    //    NSMutableArray *shopCartList = [NSMutableArray array];
    //    [shopCartList addObject:shopCartId];
    //    [[YKSuitManager sharedManager]deleteFromShoppingCartwithShoppingCartId:shopCartList OnResponse:^(NSDictionary *dic) {
    ////        [self getCartList];
    //        [self getCartList];
    //
    //        [self getNum];
    //
    //    }];
}

- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSMutableArray *shopCartList = [NSMutableArray array];
        [shopCartList addObject:self.shoppingId];
        [[YKSuitManager sharedManager]deleteFromShoppingCartwithShoppingCartId:shopCartList OnResponse:^(NSDictionary *dic) {
            //        [self getCartList];
            [self getCartList];
            
            [self getNum];
            
        }];
    }
}

@end
