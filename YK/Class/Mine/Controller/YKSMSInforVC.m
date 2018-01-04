//
//  YKSMSInforVC.m
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#define ID @"myCell"
#import "YKSMSInforVC.h"
#import "LogisticsInfo.h"
#import "LogisticsTableViewCellFrame.h"
#import "LogisticsTableViewCell.h"
#import "YKSMSStatusView.h"

@interface YKSMSInforVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *logisticsTableView;

@property(nonatomic,strong) NSArray *logisticsInfoData;

@end

@implementation YKSMSInforVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    
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

    //请求物流信息
    
    [self logisticsInfoData];
    
    self.navigationItem.title = @"物流状态";
    _logisticsTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _logisticsTableView.delegate = self;
    _logisticsTableView.dataSource = self;
    [_logisticsTableView registerClass:[LogisticsTableViewCell class] forCellReuseIdentifier:ID];
    [_logisticsTableView registerClass:[YKSMSStatusView class] forCellReuseIdentifier:@"status"];
    _logisticsTableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
    _logisticsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_logisticsTableView];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSArray *)logisticsInfoData
{
    if (!_logisticsInfoData) {
        //测试数据
        NSString *path = [[NSBundle mainBundle] pathForResource:@"logisticsInfo.plist" ofType:nil];
      __block NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *marr = [NSMutableArray new];
        
        //得到arr
        [[YKOrderManager sharedManager]searchForSMSInforWithOrderNo:self.orderNo OnResponse:^(NSArray *array) {
            
            arr = [NSArray arrayWithArray:array];
            
           for (NSDictionary *dict in arr) {
                LogisticsInfo *logisticsInfo = [LogisticsInfo logisticsWithDict:dict];
                LogisticsTableViewCellFrame *cellFrame = [[LogisticsTableViewCellFrame alloc]init];
                cellFrame.logisticsInfo = logisticsInfo;
                [marr addObject:cellFrame];
            }
            _logisticsInfoData = marr;
            [_logisticsTableView reloadData];
        }];
    }
    return _logisticsInfoData;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _logisticsInfoData.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YKSMSStatusView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKSMSStatusView" owner:self options:nil][0];
        bagCell.selectionStyle = UITableViewCellEditingStyleNone;
        [bagCell initWithOrderId:self.orderNo orderStatus:[YKOrderManager sharedManager].SMSStatus phone:PHONE];
        return bagCell;
    }
    if (indexPath.row == 1) {
        YKSMSStatusView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKSMSStatusView" owner:self options:nil][1];
        bagCell.selectionStyle = UITableViewCellEditingStyleNone;
        return bagCell;
    }
    LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[LogisticsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    LogisticsTableViewCellFrame *cellFrame = _logisticsInfoData[indexPath.row-2];
    cell.logisticsTableViewCellFrame = cellFrame;
    if (indexPath.row == 2) { 
        cell.imgView.backgroundColor = mainColor;
        cell.lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        cell.addressLabel.textColor = mainColor;
        cell.infoLabel.textColor = mainColor;
        cell.timeLabel.textColor = mainColor;
    } else {
        cell.addressLabel.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        cell.infoLabel.textColor = [UIColor colorWithHexString:@"afafaf"];
        cell.timeLabel.textColor = [UIColor colorWithHexString:@"afafaf"];
        cell.imgView.backgroundColor = cell.lineView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        cell.lineView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
     cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    if (indexPath.row == 1) {
        return 80;
    }
    LogisticsTableViewCellFrame *cellFrame = _logisticsInfoData[indexPath.row-2];
    return cellFrame.rowHeight;
}

@end
