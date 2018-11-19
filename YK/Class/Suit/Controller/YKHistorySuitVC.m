//
//  YKHistorySuitVC.m
//  YK
//
//  Created by edz on 2018/11/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKHistorySuitVC.h"
#import "YKHisHeader.h"
#import "YKNewSuitCell.h"
#import "YKProductDetailVC.h"
#import "YKSelectClothToPubVC.h"
#import "TopPublicVC.h"

@interface YKHistorySuitVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)YKHisHeader *historyHeader;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation YKHistorySuitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatHeader];
    [self creatTableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //获取历史衣服
    [self performSelector:@selector(getHistoryList) withObject:nil afterDelay:1.0];
}

- (void)getHistoryList{
    if ([Token length] == 0) {
        [self.dataArray removeAllObjects];
        _historyHeader.clothList = self.dataArray;
        [self.tableView reloadData];
        //        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
        //            [self searchAddCloth];
        //            [self getNum];
        //        }];
        return;
    }
    [[YKOrderManager sharedManager]searchOrderWithOrderStatus:5 OnResponse:^(NSMutableArray *array) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
        _historyHeader.clothList = self.dataArray;
        [self.tableView reloadData];
    }];
}

- (void)creatHeader{
    _historyHeader = [[NSBundle mainBundle]loadNibNamed:@"YKHisHeader" owner:nil options:nil][0];
    _historyHeader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(64));
    
    [self.view addSubview:_historyHeader];
    
}

- (void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(64), WIDHT, self.view.frame.size.height - kSuitLength_H(64)- kSuitLength_H(120)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSuitLength_H(130);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf(weakSelf)
//    if (indexPath.row<self.dataArray.count) {
        static NSString *ll = @"c";
        YKNewSuitCell *cell = [tableView dequeueReusableCellWithIdentifier:ll];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YKNewSuitCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//
//        YKSuit *suit = [[YKSuit alloc]init];
//        [suit initWithDictionary:self.dataArray[indexPath.row]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
        cell.dic = dic;
        cell.publicBlock = ^(NSString *shopCartId){
            TopPublicVC *public = [[TopPublicVC alloc]init];
            public.clothingId  = shopCartId;
            public.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:public animated:YES];
        };
        [cell resetUI];
        return cell;
//    }
//    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        YKNewSuitCell *mycell = (YKNewSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        YKProductDetailVC *detail = [YKProductDetailVC new];
        detail.productId = mycell.suitId;
        detail.titleStr = mycell.suit.clothingName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
    return CGFLOAT_MIN;
}
@end
