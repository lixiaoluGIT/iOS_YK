//
//  YKBuyOrderVC.m
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBuyOrderVC.h"
#import "YKMineBagCell.h"
#import "YKMineCell.h"
#import "YKSuitCell.h"
#import "YKSMSCell.h"
#import "YKAddressVC.h"
#import "YKSuccessVC.h"
#import "YKAddressDetailCell.h"
#import "YKSuitEnsureCell.h"
#import "YKToBeVIPVC.h"
#import "YKUserAccountVC.h"

#import "YKBuyCashCell.h"
#import "YKBuyTypeCell.h"
#import "YKBuyProductCell.h"

@interface YKBuyOrderVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>{
    BOOL isHadDefaultAddress;
    BOOL hadOnce;
    NSInteger cardType;
    NSInteger aleartId;
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)YKAddress *addressM;
@property (nonatomic,assign) payMethod payMethod;
//@property (nonatomic,strong)YKOrder *order;
@end

@implementation YKBuyOrderVC

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
    self.payMethod = 3;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"确认订单";
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
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Medium(kSuitLength_H(14));
    
    self.navigationItem.titleView = title;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
    [self creatbottumView];
}

- (void)creatbottumView{
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, MSH-50, WIDHT, 50)];
    buttomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttomView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDHT/2, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [buttomView addSubview:line];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"实付款：";
    lable.textColor = mainColor;
    lable.font = PingFangSC_Regular(14);
    [buttomView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.centerY.mas_equalTo(buttomView.mas_centerY);
    }];
    
    UILabel *lable2 = [[UILabel alloc]init];
    lable2.text = [NSString stringWithFormat:@"¥ %.f（免运费）",[self.product[@"clothingPrice"] intValue]*0.6];
    lable2.textColor = YKRedColor;
    lable2.font = PingFangSC_Regular(14);
    [buttomView addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lable.mas_right);
        make.centerY.mas_equalTo(buttomView.mas_centerY);
    }];
    
    //付款按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = YKRedColor;
    [btn setTitle:@"立即支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = PingFangSC_Medium(16);
    [btn addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WIDHT/2);
        make.centerY.mas_equalTo(buttomView.mas_centerY);
        make.width.mas_equalTo(WIDHT/2);
        make.height.mas_equalTo(50);
    }];
}

- (void)toPay{
    if (self.payMethod == 3) {
        [smartHUD alertText:kWindow alert:@"请选择支付方式" delay:1.0];
        return;
    }
    //调起支付
    [[YKPayManager sharedManager]payWithPayMethod:self.payMethod payType:1 activity:0 channelId:0 inviteCode:@"" OnResponse:^(NSDictionary *dic) {
        
    }];
}
- (void)leftAction{
    DXAlertView *aleart = [[DXAlertView alloc]initWithTitle:@"确定要放弃付款吗？" message:@"您尚未完成支付，喜欢的商品可能会被抢空哦～" cancelBtnTitle:@"取消" otherBtnTitle:@"继续支付"];
    aleart.delegate = self;
    [aleart show];
    
}
- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGFLOAT_MIN;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (isHadDefaultAddress) {
            return 105;
        }
        return 64;
    }
    if (indexPath.section==1) {
        return 128;
    }
    if (indexPath.section==2) {
        return 161;
    }
    return 169;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
            mycell.backgroundColor = [UIColor whiteColor];
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
    if (indexPath.section==1) {//商品
        YKBuyProductCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKBuyProductCell" owner:self options:nil][0];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        [mycell initWithDictionary:self.product sizeNum:_sizeNum];
        return mycell;
    }
    if (indexPath.section==2) {//支付方式
        YKBuyTypeCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKBuyTypeCell" owner:self options:nil][0];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        mycell.selectPayBlock = ^(payMethod payMethod) {
            self.payMethod = payMethod;
        };
        return mycell;
    }
    YKBuyCashCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKBuyCashCell" owner:self options:nil][0];
    }
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    mycell.price = [NSString stringWithFormat:@"%.f",[self.product[@"clothingPrice"] intValue] * 0.6];
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
