//
//  YKAddressVC.m
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKAddressVC.h"
#import "YKAddAddressCell.h"
#import "YKAddressDetailCell.h"
#import "YKEditAddressVC.h"

@interface YKAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *addressArray;//所有的地址数据
@end

@implementation YKAddressVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self getData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"收货地址";
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
    
    self.navigationItem.titleView = title;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
}

- (void)getData{
    //获取地址列表
    [[YKAddressManager sharedManager]getAddressListOnResponse:^(NSDictionary *dic) {
        
        self.addressArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        [self.tableView reloadData];
        
    }];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section!=self.addressArray.count) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==self.addressArray.count) {
        return 140;
    }
    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addressArray.count + 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(weakSelf)
    //添加地址按钮
    if (indexPath.section==self.addressArray.count) {
        static NSString *ID = @"cell";
        YKAddAddressCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAddAddressCell" owner:self options:nil][0];
            
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
   YKAddressDetailCell  *mycell = [tableView dequeueReusableCellWithIdentifier:@"address"];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAddressDetailCell" owner:self options:nil][0];
        
    }
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    YKAddress *address = [[YKAddress alloc]init];
    [address ininWithDictionary:self.addressArray[indexPath.section]];
    mycell.address = address;
    mycell.selectDefaultBlock = ^(void){//设置完后重新请求,刷新数据
        [weakSelf getData];
    };
    mycell.deleteBlock = ^(void){
        [weakSelf getData];
    };
    mycell.editBlock = ^(YKAddress *address){
        //push
        YKEditAddressVC *edit = [YKEditAddressVC new];
        edit.address = address;
        [weakSelf.navigationController pushViewController:edit animated:YES];
        
    };
    return mycell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果没默认地址.添加地址
    YKAddressDetailCell *detailCell = (YKAddressDetailCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==self.addressArray.count) {
        [self.navigationController pushViewController:[YKEditAddressVC new] animated:YES];
        return;
    }
    if (self.selectAddressBlock) {
        self.selectAddressBlock(detailCell.address);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
