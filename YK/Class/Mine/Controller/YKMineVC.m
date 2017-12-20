//
//  YKMineVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMineVC.h"
#import "YKSuitCell.h"
#import "YKMineheader.h"
#import "YKMineCell.h"
#import "YKMineBagCell.h"
#import "YKMySuitBagVC.h"
#import "YKNormalQuestionVC.h"
#import "YKWalletVC.h"
#import "YKAddressVC.h"
#import "YKSettingVC.h"
#import "YKToBeVIPVC.h"
#import "YKEditInforVC.h"
#import "YKLoginVC.h"
#import "YKDepositVC.h"


@interface YKMineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    YKMineheader *head;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *images;
@end

@implementation YKMineVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];;
    [self.navigationController.navigationBar setHidden:YES];
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:246.0/255 green:102.0/255 blue:102.0/255 alpha:1]];
    [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
         head.user = [YKUserManager sharedManager].user;
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self setStatusBarBackgroundColor:self.view.backgroundColor];
     [self.navigationController.navigationBar setHidden:NO];
}



- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(weakSelf)
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"FF6D6A"];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    head = [[NSBundle mainBundle] loadNibNamed:@"YKMineheader" owner:self options:nil][0];
    head.frame = CGRectMake(0, 0, self.view.frame.size.width, 135);
    head.VIPClickBlock = ^(NSInteger VIPStatus){
        if (VIPStatus==1) {//使用中
            YKWalletVC *wallet = [YKWalletVC new];
            wallet.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:wallet animated:YES];
        }
        if (VIPStatus==2) {//已过期,充值会员
            YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
            [weakSelf presentViewController:vip animated:YES completion:^{
                
            }];
        }
        if (VIPStatus==3) {//无押金,充押金
            YKDepositVC *deposit = [YKDepositVC new];
            deposit.hidesBottomBarWhenPushed = YES;
            deposit.validityStatus = 0;//未交押金
            [weakSelf.navigationController pushViewController:deposit animated:YES];
        }
        if (VIPStatus==4) {//未开通
            YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
            [weakSelf presentViewController:vip animated:YES completion:^{
                
            }];
        }
    }
    ;
    head.viewClickBlock = ^(){
        if ([Token length] == 0) {
            [weakSelf Login];
            return ;
        }else {
            YKEditInforVC *set = [[YKEditInforVC alloc]initWithNibName:@"YKEditInforVC" bundle:[NSBundle mainBundle]];
            set.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:set animated:YES];
        }
        
        
    };
    self.tableView.tableHeaderView = head;
    
    self.images = [NSArray array];
    self.images = @[@"qianbao",@"gerenziliao",@"address",@"question",@"kefu-1",@"setting"];
    self.titles = [NSArray array];
    self.titles = @[@"我的钱包",@"个人资料",@"收货地址",@"常见问题",@"联系客服",@"设置"];
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
    view.backgroundColor = [UIColor colorWithHexString:@"F8f8f8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 150;
    }
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return self.titles.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(weakSelf)
    if (indexPath.section==0) {
        YKMineBagCell *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKMineBagCell" owner:self options:nil][0];
        bagCell.scanBlock = ^(NSInteger tag){
            if ([Token length] == 0) {
                [weakSelf Login];
            }else {
                YKMySuitBagVC *suit = [YKMySuitBagVC new];
                suit.selectedIndex = tag;
                suit.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:suit animated:YES];
            }
        };
        bagCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return bagCell;
    }
    
    static NSString *ID = @"cell";
    YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
        mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
        mycell.image.image = [UIImage imageNamed:self.images[indexPath.row]];
    }
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([Token length] == 0) {
        if (indexPath.row!=3&&indexPath.row!=4) {
            [self Login];
             return;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row==0) {//钱包
            YKWalletVC *wallet = [YKWalletVC new];
            wallet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wallet animated:YES];
        }
        if (indexPath.row==1) {//个人资料
            YKEditInforVC *set = [[YKEditInforVC alloc]initWithNibName:@"YKEditInforVC" bundle:[NSBundle mainBundle]];
            set.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:set animated:YES];
            
        }
        if (indexPath.row==2) {//收货地址
            YKAddressVC *address = [YKAddressVC new];
            address.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:address animated:YES];
        }
        if (indexPath.row==3) {//常见问题
            YKNormalQuestionVC *normal = [YKNormalQuestionVC new];
            normal.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:normal animated:YES];
        }
        if (indexPath.row==4) {//联系客服
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            alertview.delegate = self;
            [alertview show];
        }
        if (indexPath.row==5) {//设置
            YKSettingVC *set = [[YKSettingVC alloc]initWithNibName:@"YKSettingVC" bundle:[NSBundle mainBundle]];
            set.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:set animated:YES];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//取消
        
    }
    if (buttonIndex==1) {//拨打
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}

- (void)Login{
    YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
    [self presentViewController:login animated:YES completion:^{
        
    }];
}
@end
