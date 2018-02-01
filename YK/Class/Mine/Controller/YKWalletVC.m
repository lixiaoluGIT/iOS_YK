//
//  YKWalletVC.m
//  YK
//
//  Created by LXL on 2017/11/23.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKWalletVC.h"
#import "YKWalletDetailVC.h"
#import "YKWalletButtom.h"
#import "YKDepositVC.h"
#import "YKChongZhiBtn.h"
#import "YKToBeVIPVC.h"

@interface YKWalletVC ()
{
    NSInteger validityStatus;//押金状态
    NSInteger depositStatus;//会员卡状态
    NSInteger cardType;//会员卡类型
    NSInteger  effectiveDay;//VIP剩余天数
    
    YKNoDataView *NoDataView;
}
@end

@implementation YKWalletVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的钱包";
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
    title.font = PingFangSC_Regular(17);
    self.navigationItem.titleView = title;
    
    //如果是老用户,显示明细
    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailClick)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"ff6d6a"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)getData{
    [[YKPayManager sharedManager]getWalletPageOnResponse:^(NSDictionary *dic) {
        validityStatus = [dic[@"depositEffective"] integerValue];//押金:0>未交,不是VIP,1>有效,2>退还中,3>无效
        depositStatus = [dic[@"effective"] integerValue];//1>使用中,2>已过期,3>无押金,4>未开通
        cardType = [dic[@"cardType"] integerValue];//会员卡类型 0季卡 1月卡 2年卡
        effectiveDay = [dic[@"validity"] integerValue];//会员卡剩余天数
         [self setUI];
    }];
   
}

- (void)detailClick{
    YKWalletDetailVC *detail = [YKWalletDetailVC new];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUI{
    
    //会员卡状态
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nianka"]];
  
    [self.view addSubview:image];
    CGFloat scale = image.frame.size.width/image.frame.size.height;
    image.frame = CGRectMake(20, 20, WIDHT-40, (WIDHT-40)/scale);
    
    //会员卡剩余天数
    
    UILabel *des = [[UILabel alloc]init];
    des.text = @"";//剩余多少天
    des.font = PingFangSC_Regular(14);
    des.textColor = [UIColor whiteColor];
    [self.view addSubview:des];
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(image.mas_bottom).offset(-50);
        make.right.equalTo(image.mas_right).offset(-20);
    }];
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"20天";//剩余多少天
    leftLabel.font = PingFangSC_Semibold(20);
    leftLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(image.mas_bottom).offset(-10);
        make.right.equalTo(image.mas_right).offset(-20);
    }];
    
    if (depositStatus == 1) {//使用中
        leftLabel.text = [NSString stringWithFormat:@"%ld天",(long)effectiveDay];
        //判断卡类型
        if (cardType==2) {//季卡
            image.image = [UIImage imageNamed:@"jika"];
            
        }
        if (cardType==1) {//月卡
            image.image = [UIImage imageNamed:@"yueka"];
            
        }
        if (cardType==3) {//年卡
            image.image = [UIImage imageNamed:@"nianka"];
           
        }
        
    }
    if (depositStatus == 2 || depositStatus == 3) {//无押金或已过期
        leftLabel.text = [NSString stringWithFormat:@"%ld天",(long)effectiveDay];
        image.image = [UIImage imageNamed:@"zanting-1"];
        //判断卡类型
        if (cardType==3) {//季卡
            des.text = @"年卡剩余有效期";
        }
        if (cardType==1) {//月卡
            des.text = @"月卡剩余有效期";
        }
        if (cardType==2) {//年卡
            des.text = @"季卡剩余有效期";
        }
    }
 
    
    if (depositStatus == 4) {//未开通
        image.hidden = YES;
        leftLabel.hidden = YES;
       
       //去开通
        WeakSelf(weakSelf)
        NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
        [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"huiyuan-1"] statusDes:@"您还不是会员" hiddenBtn:NO actionTitle:@"去购买" actionBlock:^{
            YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
            //            [weakSelf presentViewController:nav animated:YES completion:NULL];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }];

        NoDataView.frame = CGRectMake(0, 98+64, WIDHT,HEIGHT-162);
        self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        [self.view addSubview:NoDataView];
    }else {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailClick)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        self.navigationItem.rightBarButtonItem.tintColor = mainColor;
        [NoDataView removeFromSuperview];
    }

    //若会员快到期
   __block YKChongZhiBtn *chongzhi = [[NSBundle mainBundle] loadNibNamed:@"YKChongZhiBtn" owner:self options:nil][0];
    chongzhi.frame = CGRectMake(20, image.frame.origin.y+image.frame.size.height+20,WIDHT-40,40);
    chongzhi.chongzhi = ^(void){
        YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
        //            [weakSelf presentViewController:nav animated:YES completion:NULL];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    };
    [self.view addSubview:chongzhi];
    if (effectiveDay<=7 && effectiveDay!=0) {
        chongzhi.hidden = NO;
    }else {
        chongzhi.hidden = YES;
        
    }
    
    //押金状态
    YKWalletButtom *buttom = [[NSBundle mainBundle] loadNibNamed:@"YKWalletButtom" owner:self options:nil][0];
    buttom.selectionStyle = UITableViewCellSelectionStyleNone;
    buttom.frame = CGRectMake(0, HEIGHT-128, WIDHT, 64);
    [buttom setTitle:validityStatus];
    buttom.scanBlock = ^(NSInteger tag){
        YKDepositVC *deposit = [[YKDepositVC alloc]initWithNibName:@"YKDepositVC" bundle:[NSBundle mainBundle]];
        deposit.validityStatus = validityStatus;
        [self.navigationController pushViewController:deposit animated:YES];
    };
    if (depositStatus != 4) {//未开通
        [self.view addSubview:buttom];

    }
    
}
@end
