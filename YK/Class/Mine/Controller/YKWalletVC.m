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
#import "YKCouponView.h"

@interface YKWalletVC ()
{
    NSInteger validityStatus;//押金状态
    NSInteger depositStatus;//会员卡状态
    NSInteger cardType;//会员卡类型
    NSInteger  effectiveDay;//VIP剩余天数
    NSArray *couponVoList;
//    NSArray *couponIdList;
    
    YKNoDataView *NoDataView;
    YKCouponView *co;
    YKCouponView *co1;
}
@property (nonatomic,strong)__block NSArray *couponIdList;
@end

@implementation YKWalletVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [self getData];
}

- (NSArray *)couponVoList{
    
    if (!couponVoList) {
        couponVoList = [NSArray array];
    }
    return couponVoList;
}

- (NSArray *)couponIdList{
    
    if (!_couponIdList) {
        _couponIdList = [NSArray array];
    }
    return _couponIdList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
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
    title.font = PingFangSC_Semibold(20);
    self.navigationItem.titleView = title;
    
    //如果是老用户,显示明细
    
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailClick)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"ff6d6a"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)getData{
    [[YKPayManager sharedManager]getWalletPageOnResponse:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        validityStatus = [dic[@"depositEffective"] integerValue];//押金:0>未交,不是VIP,1>有效,2>退还中,3>无效
        depositStatus = [dic[@"effective"] integerValue];//1>使用中,2>已过期,3>无押金,4>未开通
        cardType = [dic[@"cardType"] integerValue];//会员卡类型 0季卡 1月卡 2年卡
        effectiveDay = [dic[@"validity"] integerValue];//会员卡剩余天数
        
        couponVoList = [NSArray arrayWithArray:dic[@"couponVoList"]];
        _couponIdList = [self getcouponIdList:couponVoList];
         [self setUI];
    }];
   
}

- (NSMutableArray *)getcouponIdList:(NSArray *)array{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [arr addObject:dic[@"couponId"]];
    }
    return arr;
}

- (void)detailClick{
    YKWalletDetailVC *detail = [YKWalletDetailVC new];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUI{
    
    WeakSelf(weakSelf)
    
    //会员卡状态
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shiyongzhong"]];
  
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
        make.bottom.equalTo(image.mas_bottom).offset(-81);
        make.right.equalTo(image.mas_right).offset(-20);
    }];
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"20天";//剩余多少天
    leftLabel.font = PingFangSC_Semibold(20);
    leftLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(des.mas_bottom).offset(6);
        make.right.equalTo(image.mas_right).offset(-20);
        
    }];
    
    //充值
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"充值" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = YKRedColor;
    btn.layer.cornerRadius = 4;
    btn.titleLabel.font = PingFangSC_Semibold(12);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(Chongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel.mas_bottom).offset(10);
        make.right.equalTo(leftLabel.mas_right);
        make.width.equalTo(@66);
        make.height.equalTo(@21);
    }];
    
    
    if (depositStatus == 1) {//使用中
        leftLabel.text = [NSString stringWithFormat:@"%ld天",(long)effectiveDay];
        //判断卡类型
        if (cardType==2) {//季卡
            image.image = [UIImage imageNamed:@"shiyongzhong"];
            
        }
        if (cardType==1) {//月卡
            image.image = [UIImage imageNamed:@"shiyongzhong"];
            
        }
        if (cardType==3) {//年卡
            image.image = [UIImage imageNamed:@"shiyongzhong"];
           
        }
//        if (cardType==3) {//季卡
//            des.text = @"年卡剩余有效期";
//        }
//        if (cardType==1) {//月卡
//            des.text = @"月卡剩余有效期";
//        }
//        if (cardType==2) {//年卡
//            des.text = @"季卡剩余有效期";
//        }
        
        [btn setTitle:@"续费" forState:UIControlStateNormal];
    }
    if (depositStatus == 2 || depositStatus == 3) {//无押金或已过期
        leftLabel.text = [NSString stringWithFormat:@"%ld天",(long)effectiveDay];
        image.image = [UIImage imageNamed:@"zanting-2"];
//        //判断卡类型
//        if (cardType==3) {//季卡
//            des.text = @"年卡剩余有效期";
//        }
//        if (cardType==1) {//月卡
//            des.text = @"月卡剩余有效期";
//        }
//        if (cardType==2) {//年卡
//            des.text = @"季卡剩余有效期";
//        }
        [btn setTitle:@"充值" forState:UIControlStateNormal];
    }
 
    
    if (depositStatus == 4) {//未开通
        [btn setTitle:@"开通会员" forState:UIControlStateNormal];
        des.text = @"";
        leftLabel.text = @"您还不是会员";
        image.image = [UIImage imageNamed:@"weishengxiao"];
    }else {
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(detailClick)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        self.navigationItem.rightBarButtonItem.tintColor = mainColor;
        [NoDataView removeFromSuperview];
    }
   //押金状态
    YKWalletButtom *buttom = [[NSBundle mainBundle] loadNibNamed:@"YKWalletButtom" owner:self options:nil][0];
    buttom.selectionStyle = UITableViewCellSelectionStyleNone;
    buttom.frame = CGRectMake(0, HEIGHT-([[UIApplication sharedApplication] statusBarFrame].size.height+44)*2, WIDHT, BarH);
    
    if (validityStatus==0 ||validityStatus==3) {//未交押金或押金无效
        [buttom setTit];
    }
    
    [buttom setTitle:validityStatus];
    buttom.scanBlock = ^(NSInteger tag){
        YKDepositVC *deposit = [[YKDepositVC alloc]initWithNibName:@"YKDepositVC" bundle:[NSBundle mainBundle]];
        deposit.validityStatus = validityStatus;
        [self.navigationController pushViewController:deposit animated:YES];
    };
    if (depositStatus != 4) {//未开通
        [self.view addSubview:buttom];
    }
    
    //背景条
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [self.view addSubview:label];
    label.frame = CGRectMake(0, image.frame.size.height+image.frame.origin.y+20, WIDHT, 10);
    
    //优惠券
    //有无优惠券
    [co removeFromSuperview];
    [co1 removeFromSuperview];
    co = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][0];
    [self.view addSubview:co];
    co.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y, WIDHT, 200);
    
    
    co1 = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][1];
    [self.view addSubview:co1];
    co1.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y, WIDHT, 200);
    if (couponVoList.count>0) {
//        [co1 removeFromSuperview];
        co.hidden = NO;
        co1.hidden = YES;
        co.toUse = ^(void){
            [[YKUserManager sharedManager]useCouponId:weakSelf.couponIdList[0]  OnResponse:^(NSDictionary *dic) {
                [weakSelf getData];//刷新数据
            }];
        };
        [co resetNum:couponVoList.count];
    }else {
//        [co removeFromSuperview];
        co.hidden = YES;
        co1.hidden = NO;
    }
}

- (void)Chongzhi{
 
    //成为会员
    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
            //            [weakSelf presentViewController:nav animated:YES completion:NULL];
            [self presentViewController:nav animated:YES completion:^{
    
            }];
}

@end
