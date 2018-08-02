//
//  YKUserAccountVC.m
//  YK
//
//  Created by edz on 2018/7/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKUserAccountVC.h"
#import "YKWalletButtom.h"
#import "YKDepositVC.h"
#import "YKWalletDetailVC.h"
#import "YKAccountCell.h"
#import "YKShareVC.h"

@interface YKUserAccountVC (){
    YKWalletButtom *buttom;
}

@end

@implementation YKUserAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"资金账户";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    //
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    //    btn.backgroundColor = [UIColor redColor];
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
    [self setupUI];

}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI{
    WeakSelf(weakSelf)
    //押金状态
    buttom = [[NSBundle mainBundle] loadNibNamed:@"YKWalletButtom" owner:self options:nil][0];
    buttom.selectionStyle = UITableViewCellSelectionStyleNone;
    buttom.frame = CGRectMake(0, HEIGHT-125, WIDHT, BarH);
    if (HEIGHT==812) {
        buttom.frame = CGRectMake(0, HEIGHT-180, WIDHT, BarH);
    }
    if ([[YKUserManager sharedManager].user.depositEffective intValue] ==0 || [[YKUserManager sharedManager].user.depositEffective intValue]==3) {//未交押金或押金无效
        [buttom setTit];
    }
    
    [buttom setTitle:[[YKUserManager sharedManager].user.depositEffective intValue]];
    buttom.scanBlock = ^(NSInteger tag){
        YKDepositVC *deposit = [[YKDepositVC alloc]initWithNibName:@"YKDepositVC" bundle:[NSBundle mainBundle]];
        deposit.validityStatus = [[YKUserManager sharedManager].user.depositEffective intValue];
        [weakSelf.navigationController pushViewController:deposit animated:YES];
    };
    [self.view addSubview:buttom];
    
    if ([[YKUserManager sharedManager].user.effective intValue] == 4) {//未开通
    
    }else {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailClick)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        self.navigationItem.rightBarButtonItem.tintColor = mainColor;
    }
}

- (void)detailClick{
    YKWalletDetailVC *detail = [YKWalletDetailVC new];
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 220;
    }
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID;
    if (indexPath.section==0) {
      ID  = @"cell1";
    }
    
    if (indexPath.section==1) {
        ID  = @"cell2";
    }
    YKAccountCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAccountCell" owner:self options:nil][indexPath.section];
    }
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        mycell.account = @{@"account":@"188.00"};
    }
    if (indexPath.section==1) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            YKShareVC *share = [YKShareVC new];
            [self.navigationController pushViewController:share animated:YES];
        }];
        [mycell addGestureRecognizer:tap];
    }
    
    return mycell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
 
}

@end
