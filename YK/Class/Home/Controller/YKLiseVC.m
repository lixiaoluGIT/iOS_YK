//
//  YKLiseVC.m
//  YK
//
//  Created by edz on 2018/8/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKLiseVC.h"
#import "YKListCell.h"
#import "YKLinkWebVC.h"
@interface YKLiseVC ()
{
    NSInteger page;
}
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation YKLiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//    self.title = @"衣库活动";
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
    
    [[YKHomeManager sharedManager]getList:page cid:_cid OnResponse:^(NSArray *array) {
        self.dataArray = [NSArray arrayWithArray:array];
        NSLog(@"=======%@",self.dataArray);
        [self.tableView reloadData];
    }];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDHT*0.6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKListCell *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKListCell" owner:self options:nil][0];
    [bagCell initWithDic:self.dataArray[indexPath.section] cid:_cid];
    bagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return bagCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKLinkWebVC *web = [[YKLinkWebVC alloc]init];
    if ([_cid intValue] == 1) {
        web.url = self.dataArray[indexPath.section][@"linkUrl"];
    }
    if ([_cid intValue] == 2) {
        web.url = self.dataArray[indexPath.section][@"hotWearUrl"];
    }
    
    web.needShare = YES;
    [self.navigationController pushViewController:web animated:YES];
}

@end
