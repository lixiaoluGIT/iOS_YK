//
//  YKDepositVC.m
//  YK
//
//  Created by LXL on 2017/11/24.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKDepositVC.h"
#import "YKSelectPayView.h"

@interface YKDepositVC ()
@property (weak, nonatomic) IBOutlet UIButton *validityBtn;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)YKSelectPayView *payView;
@property (nonatomic,assign) payMethod payMethod;
@end

@implementation YKDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"押金";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = title;
    [NC addObserver:self selector:@selector(alipayResultCurrent:) name:@"alipayres" object:nil];
    [NC addObserver:self selector:@selector(wxpayresultCurrent:) name:@"wxpaysuc" object:nil];
    [self getData];
}

- (void)getData{
    [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
        _validityStatus = [[YKUserManager sharedManager].user.depositEffective intValue];
        [self setUpUI];
    }];
}
- (void)setUpUI{
    switch (_validityStatus) {
        case 0://押金未交
            [_validityBtn setTitle:@"缴纳押金" forState:UIControlStateNormal];
            [_validityBtn addTarget:self action:@selector(pushMoney) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 1://押金有效
            [_validityBtn setTitle:@"退还押金" forState:UIControlStateNormal];
            [_validityBtn addTarget:self action:@selector(pullMoney) forControlEvents:UIControlEventTouchUpInside];
            [_validityBtn setBackgroundColor:[UIColor colorWithHexString:@"f8f8f8"]];
            [_validityBtn setTitleColor:[UIColor colorWithHexString:@"676869"] forState:UIControlStateNormal];
            break;
        case 2://押金退还中
            [_validityBtn setTitle:@"押金退还中" forState:UIControlStateNormal];
            [_validityBtn setBackgroundColor:[UIColor colorWithHexString:@"f8f8f8"]];
            [_validityBtn setTitleColor:[UIColor colorWithHexString:@"676869"] forState:UIControlStateNormal];
            break;
        case 3://押金无效
            [_validityBtn setTitle:@"缴纳押金" forState:UIControlStateNormal];
            [_validityBtn addTarget:self action:@selector(pushMoney) forControlEvents:UIControlEventTouchUpInside];
            [_validityBtn setBackgroundColor:[UIColor colorWithHexString:@"ff6d6a"]];
            [_validityBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushMoney{
    YKAleartView *alert = [[YKAleartView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [alert showWithtitle:@"确认缴纳押金 ¥299" notitle:@"取消" yestitle:@"确认" cancelBlock:^{
        
    } ensureBlock:^{
        [self creatPayView];
        //弹出选择支付方式
        WeakSelf(weakSelf)
        weakSelf.backView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.payView.frame = CGRectMake(0, HEIGHT-236, WIDHT, 236);
            weakSelf.backView.alpha = 0.5;
        }completion:^(BOOL finished) {
            
        }];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
}

- (void)creatPayView{
    WeakSelf(weakSelf)
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor colorWithHexString:@"000000"];
    _backView.hidden = YES;
    _backView.alpha = 0.5;
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(diss)];
    [_backView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    _payView = [[NSBundle mainBundle] loadNibNamed:@"YKSelectPayView" owner:self options:nil][0];
    _payView.frame = CGRectMake(0, HEIGHT, WIDHT, 236);
    _payView.selectPayBlock = ^(payMethod payMethod){
        
        [[YKPayManager sharedManager]payWithPayMethod:payMethod payType:0 OnResponse:^(NSDictionary *dic) {
            
        }];
    };
    _payView.cancleBlock = ^(void){
        [weakSelf diss];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_payView];
}

- (void)diss{
    WeakSelf(weakSelf)
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.payView.frame = CGRectMake(0, HEIGHT, WIDHT, 236);
        weakSelf.backView.alpha = 0;
    }completion:^(BOOL finished) {
        weakSelf.backView.hidden = YES;
        [weakSelf.backView removeFromSuperview];
        [weakSelf.payView removeFromSuperview];
    }];
}
- (IBAction)agree:(id)sender {
    UIButton * button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (void)pullMoney{
    YKAleartView *alert = [[YKAleartView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [alert showWithtitle:@"确认退还押金吗" notitle:@"确认" yestitle:@"取消" cancelBlock:^{
        //申请退押金
        [[YKPayManager sharedManager]refondDepositOnResponse:^(NSDictionary *dic) {
            [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
                [_payView removeFromSuperview];
                    _validityStatus = [[YKUserManager sharedManager].user.depositEffective intValue];
                        [self setUpUI];
                }];
        }];
    } ensureBlock:^{
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
}

//支付宝支付结果
-(void)alipayResultCurrent:(NSNotification *)notify{

    NSDictionary *dict = [notify userInfo];
    if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
       
        [self getData];
        
    }else if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        
       [smartHUD alertText:self.view alert:@"支付失败." delay:1];
        
    }else{
        
    
    }
}

//微信支付结果
-(void)wxpayresultCurrent:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    
    if ([[dict objectForKey:@"codeid"]integerValue]==0) {
     
       [self getData];
        
    }else{
        
        [smartHUD alertText:self.view alert:@"支付失败." delay:1];

    }
}
@end
