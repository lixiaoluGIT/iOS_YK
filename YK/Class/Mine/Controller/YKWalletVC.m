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

@interface YKWalletVC ()<UITableViewDelegate,UITableViewDataSource>
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
    YKWalletButtom *buttom;
    
    BOOL ishad;
}
@property (nonatomic,strong)__block NSArray *couponIdList;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YKWalletVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [buttom removeFromSuperview];
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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-BarH-44-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)getData{
    [[YKPayManager sharedManager]getWalletPageOnResponse:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        validityStatus = [dic[@"depositEffective"] integerValue];//押金:0>未交,不是VIP,1>有效,2>退还中,3>无效
        depositStatus = [dic[@"effective"] integerValue];//1>使用中,2>已过期,3>无押金,4>未开通
        cardType = [dic[@"cardType"] integerValue];//会员卡类型 1季卡 2月卡 3年卡 4体验卡 5助力卡
        effectiveDay = [dic[@"validity"] integerValue];//会员卡剩余天数
        
      
        [[YKUserManager sharedManager]getWalletDetailPageOnResponse:^(NSDictionary *dic) {
            couponVoList = [NSArray arrayWithArray:dic[@"data"]];
//            _couponIdList = [self getcouponIdList:couponVoList];
            [self.tableView reloadData];
            [self setUI];
        }];
//         [self setUI];
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
    //header
    UIView *header = [[UIView alloc]init];
    header.frame =CGRectMake(0, 0, WIDHT, 320);
    if (WIDHT==414) {
        header.frame =CGRectMake(0, 0, WIDHT, 340);
    }
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shiyongzhong"]];
  
    [header addSubview:image];
    CGFloat scale = image.frame.size.width/image.frame.size.height;
    image.frame = CGRectMake(20, 20, WIDHT-40, (WIDHT-40)/scale);
    
    //会员卡剩余天数
    
    UILabel *des = [[UILabel alloc]init];
    des.text = @"";//剩余多少天
    des.font = PingFangSC_Regular(14);
    des.textColor = [UIColor whiteColor];
    [header addSubview:des];
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(image.mas_bottom).offset(-81);
        make.right.equalTo(image.mas_right).offset(-20);
    }];
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"20天";//剩余多少天
   
    leftLabel.font = PingFangSC_Semibold(20);
    leftLabel.textColor = [UIColor whiteColor];
    [header addSubview:leftLabel];
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
    [header addSubview:btn];
    [btn addTarget:self action:@selector(Chongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLabel.mas_bottom).offset(10);
        make.right.equalTo(leftLabel.mas_right);
        make.width.equalTo(@66);
        make.height.equalTo(@21);
    }];
    
    
    if (depositStatus == 1) {//使用中
        leftLabel.text = [NSString stringWithFormat:@"%ld天",(long)effectiveDay];
        if (cardType==4) {
            leftLabel.text = [NSString stringWithFormat:@"会员卡剩余%ld天",(long)effectiveDay];
        }
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
        if (cardType==4) {
            leftLabel.text = [NSString stringWithFormat:@"会员卡剩余%ld天",(long)effectiveDay];
        }
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
   buttom = [[NSBundle mainBundle] loadNibNamed:@"YKWalletButtom" owner:self options:nil][0];
    buttom.selectionStyle = UITableViewCellSelectionStyleNone;
    buttom.frame = CGRectMake(0, HEIGHT-([[UIApplication sharedApplication] statusBarFrame].size.height+44), WIDHT, BarH);
    if (validityStatus==0 || validityStatus==3) {//未交押金或押金无效
        [buttom setTit];
    }
    
    [buttom setTitle:validityStatus];
    buttom.scanBlock = ^(NSInteger tag){
        YKDepositVC *deposit = [[YKDepositVC alloc]initWithNibName:@"YKDepositVC" bundle:[NSBundle mainBundle]];
        deposit.validityStatus = validityStatus;
        [self.navigationController pushViewController:deposit animated:YES];
    };
//    if (depositStatus != 4) {//未开通
//    if (!ishad) {
         [self.view addSubview:buttom];
//    }
    
//    }
    
    //背景条
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [header addSubview:label];
    label.frame = CGRectMake(0, image.frame.size.height+image.frame.origin.y+20, WIDHT, 10);
    
    self.tableView.tableHeaderView = header;
    //优惠券
    //有无优惠券
//    [co removeFromSuperview];
//    [co1 removeFromSuperview];
//    co = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][0];
//    [self.view addSubview:co];
//    co.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y, WIDHT, 200);
//
//
    co1 = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][1];
    [header addSubview:co1];
    co1.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y, WIDHT, 180);
    
   YKCouponView *co2 = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][2];
    [header addSubview:co2];
    co2.frame = CGRectMake(0, label.frame.size.height+label.frame.origin.y, WIDHT, 180  );
    [header addSubview:co1];
    if (couponVoList.count>0) {
        co1.hidden = YES;
        co2.hidden = NO;
//        [co1 removeFromSuperview];
        
//        co1.hidden = YES;
//        co.toUse = ^(void){
//            [[YKUserManager sharedManager]useCouponId:weakSelf.couponIdList[0]  OnResponse:^(NSDictionary *dic) {
//                [weakSelf getData];//刷新数据
//            }];
//        };
//        [co resetNum:couponVoList.count];
    }else {
        co1.hidden = NO;
        co2.hidden = YES;
//        [co removeFromSuperview];
//        co.hidden = YES;
//        co1.hidden = NO;
    }
//    [self.tableView reloadData];
}

- (void)Chongzhi{
 
    //成为会员
    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
            //            [weakSelf presentViewController:nav animated:YES completion:NULL];
            [self presentViewController:nav animated:YES completion:^{
    
            }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return couponVoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YKCouponView *cell = (YKCouponView *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.couponStatus==2) {
        [smartHUD alertText:self.view alert:@"已使用" delay:1.5];
        return;
    }
    if (cell.couponStatus==3) {
        [smartHUD alertText:self.view alert:@"已过期" delay:1.5];
        return;
    }
    if (cell.couponType==1) {//加时卡
        [[YKUserManager sharedManager]useCouponId:[[NSNumber numberWithInteger:cell.couponID]stringValue] OnResponse:^(NSDictionary *dic) {
            [self getData];//刷新数据
        }];
        return;
    }
    if (cell.couponType==2) {//优惠劵
//        [buttom removeFromSuperview];
        YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
        [YKUserManager sharedManager].couponNum = cell.couponNum;
        [YKUserManager sharedManager].couponID = cell.couponID;
        [YKUserManager sharedManager].isFromCoupon = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
      }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YKCouponView *co = [[NSBundle mainBundle] loadNibNamed:@"YKCouponView" owner:self options:nil][0];
    [co initWithDic:couponVoList[indexPath.row]];
    return co;
}
@end
