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
//    if ([Token length] == 0) {
//        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
//            [self getHistoryList];
//        }];
//        return;
//    }
    //获取历史衣服
    [self performSelector:@selector(getHistoryList) withObject:nil afterDelay:0.3];
}

- (void)getHistoryList{
    if ([Token length] == 0) {
        
        [self.dataArray removeAllObjects];
        _historyHeader.clothList = self.dataArray;
        _historyHeader.Number = @"0";
        _historyHeader.Price = @"0";
        [self.tableView reloadData];
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            [self getHistoryList];
        }];
        //        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
        //            [self searchAddCloth];
        //            [self getNum];
        //        }];
       
        
        
       
        return;
    }
//    [[YKOrderManager sharedManager]searchOrderWithOrderStatus:5 OnResponse:^(NSMutableArray *array) {
//        self.dataArray = [NSMutableArray arrayWithArray:array];
//        _historyHeader.clothList = self.dataArray;
//        [self.tableView reloadData];
//    }];
    
    [[YKOrderManager sharedManager]searchBeHistoryOrderWithOrderStatus:0 OnResponse:^(NSDictionary  *dic) {
        if ([dic[@"userOrderVoList"] isEqual:[NSNull null]]) {
            return ;
        }
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"][@"userOrderVoList"]];
        _historyHeader.Number = [NSString stringWithFormat:@"%@",dic[@"data"][@"totalNumber"]];
         _historyHeader.Price = [NSString stringWithFormat:@"%@",dic[@"data"][@"totalPrice"]];
        [self.tableView reloadData];
    }];
}

- (void)creatHeader{
    _historyHeader = [[NSBundle mainBundle]loadNibNamed:@"YKHisHeader" owner:nil options:nil][0];
    _historyHeader.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(58));
    
    [self.view addSubview:_historyHeader];
    
}

- (void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(58), WIDHT, self.view.frame.size.height - kSuitLength_H(58)- kSuitLength_H(120)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return kSuitLength_H(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UILabel *la = [[UILabel alloc]init];
    la.frame = CGRectMake(kSuitLength_H(17), 0, kSuitLength_H(300), kSuitLength_H(30));
    la.textAlignment = NSTextAlignmentLeft;
    la.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    la.font = PingFangSC_Regular(kSuitLength_H(12));
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.dataArray[section]];
   
    NSString * newTime = [self formateDate:dic[@"createTime"] withFormate:@"yyyyMMddHHmmss"];
     la.text = newTime;
    [header addSubview:la];
    
    return header;
}

- (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    NSDate * nowDate = [NSDate date];
    
    NSTimeInterval interval    =[dateString doubleValue] / 1000.0;
    NSDate *needFormatDate               = [NSDate dateWithTimeIntervalSince1970:interval];
    /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    //// 再然后，把间隔的秒数折算成天数和小时数：
    
    NSString *dateStr = @"";
    
    if (time<=60) {  //// 1分钟以内的
        dateStr = @"刚刚";
    }else if(time<=60*60){  ////  一个小时以内的
        
        int mins = time/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        
    }else if(time<=60*60*24){   //// 在两天内的
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            //// 在同一天
            dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }else{
            ////  昨天
            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }
    }else {
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            ////  在同一年
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else{
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:ss"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }
    
    return dateStr;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSuitLength_H(130);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [NSArray arrayWithArray:self.dataArray[section][@"userOrderDetailsVoList"]];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;;
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
//        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    NSArray *array = [NSArray arrayWithArray:self.dataArray[indexPath.section][@"userOrderDetailsVoList"]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:array[indexPath.row]];
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
