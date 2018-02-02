//
//  YKEditAddressVC.m
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKEditAddressVC.h"
#import "YKEditAddressView.h"

#import "MOFSPickerManager.h"

@interface YKEditAddressVC ()
{
    NSInteger isDefaultAddress;
}

@property (nonatomic,strong)YKEditAddressView  *editView;
@end

@implementation YKEditAddressVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑地址";
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

    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = mainColor;
   
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Semibold(20);
    
    self.navigationItem.titleView = title;
    
    _editView = [[NSBundle mainBundle] loadNibNamed:@"YKEditAddressView" owner:self options:nil][0];
    _editView.selectionStyle = UITableViewCellSelectionStyleNone;
    _editView.frame = CGRectMake(0, 64, WIDHT, HEIGHT);
    _editView.addressModel = self.address;
    [self.view addSubview:_editView];
 
}

//保存
- (void)onClickedOKbtn{
    
    if (_editView.nameText.text.length==0) {
        [smartHUD alertText:self.view alert:@"请输入收货人姓名" delay:1.2];
        return;
    }
    if (_editView.phoneText.text.length==0) {
        [smartHUD alertText:self.view alert:@"请输入联系电话" delay:1.2];
        return;
    }
    if (_editView.address.text.length==0) {
        [smartHUD alertText:self.view alert:@"请选择所在位置" delay:1.2];
        return;
    }
    if (_editView.textView.text.length==0 || [_editView.textView.text isEqualToString:@"请填写详细地址,不少于五个字"]) {
        [smartHUD alertText:self.view alert:@"请填写具体收货地址" delay:1.2];
        return;
    }
    
    if (self.address) {
        [_editView creatAddressModel];
       
        [[YKAddressManager sharedManager]updateAddressWithAddress:_editView.addressModel addressId:self.address.addressId OnResponse:^(NSDictionary *dic) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    [_editView creatAddressModel];
    
    [[YKAddressManager sharedManager]addAddressWithAddress:_editView.addressModel OnResponse:^(NSDictionary *dic) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
