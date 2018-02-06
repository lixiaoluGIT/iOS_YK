//
//  YKReturnVC.m
//  YK
//
//  Created by LXL on 2017/11/29.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKReturnVC.h"
#import "YKReturnView.h"
#import "YKReturnAddressView.h"
#import "YKMineCell.h"
#import "YKAddressVC.h"
#import "PickViewSelect.h"
#import "YKNormalQuestionVC.h"

@interface YKReturnVC ()<UITableViewDelegate,UITableViewDataSource,pickViewStrDelegate>
{
    UITableView *tableView;
    UIButton *_buttom;
    BOOL isHadDefaultAddress;
}
@property (nonatomic,strong)YKAddress *address;
@property (nonatomic,strong)PickViewSelect *pickView;
@property (nonatomic,strong)NSString *timeStr;
@end

@implementation YKReturnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeStr = @"请选择归还时间";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预约归还";
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
    
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 25, 25);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"tel"] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(tel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[YKReturnAddressView class] forCellReuseIdentifier:@"address"];
     [tableView registerClass:[YKReturnView class] forCellReuseIdentifier:@"time"];
    tableView.estimatedRowHeight = 30;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttom.frame = CGRectMake(0, HEIGHT-50, WIDHT, 50);
    _buttom.backgroundColor = mainColor;
    [self.view addSubview:_buttom];
    [_buttom setTitle:@"确认预约" forState:UIControlStateNormal];
    _buttom.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttom addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //请求地址
    [self getAddress];
}

- (void)tel{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
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
        return;
    }
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alertview.delegate = self;
    [alertview show];
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

- (void)getAddress{
    
    [[YKAddressManager sharedManager]queryDetaultAddressOnResponse:^(NSDictionary *dic) {
        NSDictionary *address = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
        
        if (address.allKeys.count==0) {
            isHadDefaultAddress = NO;//无默认地址
        }else {
            self.address = [YKAddress new];
            [_address ininWithDictionary:dic[@"data"]];
            isHadDefaultAddress = YES;//有默认地址
        }
        
        [tableView reloadData];
    }];
}
- (void)releaseInfo{
    
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnClick{
    //确认预约
    if ([self.timeStr isEqualToString:@"请选择归还时间"]) {
        [smartHUD alertText:self.view alert:@"请选择归还时间" delay:1.2];
        return;
    }
    if (!self.address) {
        [smartHUD alertText:self.view alert:@"请选择取件地址" delay:1.2];
        return;
    }
    
    [[YKOrderManager sharedManager]orderReceiveWithOrderNo:@"" addressId:self.address.addressId time:self.timeStr OnResponse:^(NSDictionary *dic) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
    }
    if (indexPath.row==1) {
        if (indexPath.section==0) {
            if (isHadDefaultAddress) {
                return 110;
            }
            return 64;
        }
    }
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //时间
    if (indexPath.row == 0) {
        YKReturnView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKReturnView" owner:self options:nil][0];
        bagCell.selectionStyle = UITableViewCellEditingStyleNone;
        bagCell.time = self.timeStr;
        return bagCell;
    }
    
    if (indexPath.row == 2) {
        YKReturnAddressView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKReturnAddressView" owner:self options:nil][1];

         bagCell.selectionStyle = UITableViewCellEditingStyleNone;
        return bagCell;
    }
    //地址
    if (isHadDefaultAddress) {
        YKReturnAddressView *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKReturnAddressView" owner:self options:nil][0];
        bagCell.address = self.address;
        bagCell.selectionStyle = UITableViewCellEditingStyleNone;
        return bagCell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果没默认地址.添加地址
    if (indexPath.row == 0) {
        [self timePickerViewSelected];
    }
    if (indexPath.row == 1) {
        YKAddressVC *address = [YKAddressVC new];
        address.selectAddressBlock = ^(YKAddress *address){
            isHadDefaultAddress = YES;
            self.address = address;
            [tableView reloadData];
        };
        [self.navigationController pushViewController:address animated:YES];
    }
    if (indexPath.row == 2) {
        YKNormalQuestionVC *normal = [YKNormalQuestionVC new];
        [self.navigationController pushViewController:normal animated:YES];
    }
}

-(void)timePickerViewSelected
{
    _pickView =[[PickViewSelect alloc]initWithFrame:CGRectMake(0, 0,WIDHT,HEIGHT)];
    _pickView.delegate = self;
    [self.view addSubview:_pickView];
    
}

//pick实现的代理
-(void)pickViewdelegateWith:(NSString *)dateStr AndHourStr:(NSString *)hourStr
{
    _timeStr = [NSString stringWithFormat:@"%@!%@",dateStr,hourStr];
    [tableView reloadData];
}

@end
