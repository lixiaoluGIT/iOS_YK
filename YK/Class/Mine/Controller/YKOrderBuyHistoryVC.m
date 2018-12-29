//
//  YKOrderBuyHistoryVC.m
//  YK
//
//  Created by edz on 2018/12/28.
//  Copyright © 2018 YK. All rights reserved.
//

#import "YKOrderBuyHistoryVC.h"
#import "CBHeaderChooseViewScrollView.h"
#import "YKBuyOrderCell.h"
#import "YKOrderDetailVC.h"

@interface YKOrderBuyHistoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YKOrderBuyHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setButtons];
}

- (void)setButtons{
    NSArray *array=@[
                     @"全部",
                     @"待付款",
                     @"待发货",
                     @"待签收",
                     @"已完成",
                     @"已取消",
                     @"已退款",
                     ];
    
    CBHeaderChooseViewScrollView*headerView=[[CBHeaderChooseViewScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, kSuitLength_H(50))];
    
    [self.view addSubview:headerView];
    
    [headerView setUpTitleArray:array titleColor:[UIColor colorWithHexString:@"999999"] titleSelectedColor:YKRedColor titleFontSize:kSuitLength_H(14)];
    
    headerView.btnChooseClickReturn = ^(NSInteger x) {
        NSLog(@"点击了第%ld个按钮",x+1);
    };
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kSuitLength_H(50), WIDHT, HEIGHT-kSuitLength_H(150)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 140;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
     [self.tableView registerClass:[YKBuyOrderCell class] forCellReuseIdentifier:@"cell"];
//    self.tableView.bottom = self.view.bottom;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKBuyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSuitLength_H(183)+10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKOrderDetailVC *detail = [[YKOrderDetailVC alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
