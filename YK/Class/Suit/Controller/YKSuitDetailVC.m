//
//  YKSuitDetailVC.m
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuitDetailVC.h"
#import "YKMineBagCell.h"
#import "YKMineCell.h"
#import "YKSuitCell.h"
#import "YKSMSCell.h"
#import "YKAddressVC.h"
#import "YKSuccessVC.h"
#import "YKAddressDetailCell.h"
#import "YKSuitEnsureCell.h"
#import "YKToBeVIPVC.h"

@interface YKSuitDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isHadDefaultAddress;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)YKAddress *addressM;
//@property (nonatomic,strong)YKOrder *order;
@end

@implementation YKSuitDetailVC

- (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:YES];
    //请求默认地址
    [self getDefaultAddress];
}

- (void)getDefaultAddress{
    if (self.addressM) {
        return;
    }
    [[YKAddressManager sharedManager]queryDetaultAddressOnResponse:^(NSDictionary *dic) {
        NSDictionary *address = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
        
        if (address.allKeys.count==0) {
            isHadDefaultAddress = NO;//无默认地址
        }else {
            self.addressM = [YKAddress new];
            [_addressM ininWithDictionary:dic[@"data"]];
            isHadDefaultAddress = YES;//有默认地址
        }
        
        [self.tableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"确认衣袋";
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
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    if (WIDHT==320) {
        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==375){
        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==414){
        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    [buttom setTitle:@"提交订单" forState:UIControlStateNormal];
    [buttom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttom.titleLabel.font = PingFangSC_Regular(14);
    buttom.backgroundColor = [UIColor colorWithRed:246.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    [buttom addTarget:self action:@selector(toRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttom];
}
//提交订单
- (void)toRelease{

    if (!self.addressM) {
        [smartHUD alertText:self.view alert:@"请添加收货地址" delay:1.2];
        return;
    }
    //提交订单
    [[YKOrderManager sharedManager]releaseOrderWithAddress:self.addressM shoppingCartIdList:[YKSuitManager sharedManager].suitArray OnResponse:^(NSDictionary *dic) {
        NSInteger status = [dic[@"status"] intValue];
        if (status==438) {
            YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
            [self presentViewController:vip animated:YES completion:^{
                
            }];
                return ;
        }
        if (status==200) {
            YKSuccessVC *success = [[YKSuccessVC alloc]initWithNibName:@"YKSuccessVC" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:success animated:YES];
            return;
        }
        [smartHUD alertText:self.view alert:dic[@"msg"] delay:1.2];
       
        }];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (isHadDefaultAddress) {
            return 100;
        }
        return 64;
    }
    if (indexPath.row==0) {
        return 64;
    }
    return 140;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return [YKSuitManager sharedManager].suitArray.count+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果没默认地址.
    if (indexPath.section==0) {
        if (isHadDefaultAddress) {
            static NSString *ID = @"cell";
            YKAddressDetailCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (mycell == nil) {
                mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAddressDetailCell" owner:self options:nil][1];
            }
            mycell.address = self.addressM;
            mycell.selectionStyle = UITableViewCellSelectionStyleNone;
            return mycell;
        }
        static NSString *ID = @"cell";
        YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
                    mycell.title.text = @"添加一个收获地址";
                    mycell.image.image = [UIImage imageNamed:@"address"];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    if (indexPath.row==0) {
        static NSString *ll = @"c";
        YKSMSCell *cell = [tableView dequeueReusableCellWithIdentifier:ll];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YKSMSCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }
 
    YKSuitEnsureCell *mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
    YKSuit *suit = [[YKSuit alloc]init];
    suit = [YKSuitManager sharedManager].suitArray[indexPath.row-1];
    mycell.suit = suit;
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果没默认地址.添加地址
    if (indexPath.section==0) {
        YKAddressVC *address = [YKAddressVC new];
        address.selectAddressBlock = ^(YKAddress *address){
            isHadDefaultAddress = YES;
            self.addressM = address;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:address animated:YES];
    }
}

@end
