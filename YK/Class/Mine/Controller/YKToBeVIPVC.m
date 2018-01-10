//
//  YKToBeVIPVC.m
//  YK
//
//  Created by LXL on 2017/11/24.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKToBeVIPVC.h"
#import "YKSelectPayView.h"
#import "YKShareVC.h"
#import "YKWebVC.h"

@interface YKToBeVIPVC ()
{
    BOOL isShareUser;
    BOOL isAgree;
}
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic,strong)UIButton *Button0;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)YKSelectPayView *payView;
@property (nonatomic,assign) payMethod payMethod;
@property (nonatomic,assign) payType payType;

@property (weak, nonatomic) IBOutlet UIButton *agreeImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap5;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UILabel *yuanJia;
@property (weak, nonatomic) IBOutlet UILabel *liJIan;
@property (weak, nonatomic) IBOutlet UILabel *yaJin;
@property (weak, nonatomic) IBOutlet UILabel *total;

@property (weak, nonatomic) IBOutlet UIButton *Btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UILabel *xieyi;

@end

@implementation YKToBeVIPVC
- (IBAction)yajinshuoming:(id)sender {
    
    YKWebVC *web = [YKWebVC new];
    web.titleStr = @"押金说明";
    web.imageName = @"押金说明";

    [self.navigationController pushViewController:web animated:YES];
//    YKShareVC *share = [YKShareVC new];
//    share.hidesBottomBarWhenPushed = YES;
//    [[self getCurrentVC].navigationController pushViewController:share animated:YES];
}
- (IBAction)yonghuxieyi:(id)sender {
    YKWebVC *web = [YKWebVC new];
    web.titleStr = @"充值说明";
    web.imageName = @"充值说明";
    [self.navigationController pushViewController:web animated:YES];
//    YKShareVC *share = [YKShareVC new];
//    share.hidesBottomBarWhenPushed = YES;
//    [[self getCurrentVC].navigationController pushViewController:share animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    //新用户并且分享过享受立减(0未分享过,1分享过)
    if ([[YKUserManager sharedManager].user.effective intValue] == 4
        && [[YKUserManager sharedManager].user.isShare intValue] == 1) {
        
        _shareBtn.hidden = YES;
        _liJIan.text = @"-¥200";
        if (_payType == MONTH_CARD) {
            _yuanJia.text = @"¥498";
            _yaJin.text = @"¥199";
            _total.text = @"¥298";
        }
        if (_payType == SEASON_CARD) {
            _yuanJia.text = @"¥1006";
            _yaJin.text = @"¥199";
            _total.text = @"¥806";
        }
        if (_payType == YEAR_CARD) {
            _yuanJia.text = @"¥3187";
            _yaJin.text = @"¥199";
            _total.text = @"¥2987";
        }
    }else {
        //新用户并且未分享过,可以分享
        if ([[YKUserManager sharedManager].user.effective intValue] == 4
            && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
            _shareBtn.hidden = NO;
        }else {//不是新用户,分享按钮永不显示
            _shareBtn.hidden = YES;
        }
        
        _liJIan.text = @"立减不可用";
        _liJIan.textColor = [UIColor colorWithHexString:@"ff6d6a"];
        
        if (_payType == MONTH_CARD) {
            _yuanJia.text = @"¥498";
            _yaJin.text = @"¥199";
            _total.text = @"¥498";
        }
        if (_payType == SEASON_CARD) {
            _yuanJia.text = @"¥1006";
            _yaJin.text = @"¥199";
            _total.text = @"¥1006";
        }
        if (_payType == YEAR_CARD) {
            _yuanJia.text = @"¥3187";
            _yaJin.text = @"¥199";
            _total.text = @"¥3187";
        }
    }
    if ([[YKUserManager sharedManager].user.effective intValue] == 4
        && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
        if (_payType==1||_payType==2||_payType==3) {
            _shareBtn.hidden = NO;
        }else {
            _shareBtn.hidden = YES;
        }
    }else {//不是新用户,分享按钮永不显示
        _shareBtn.hidden = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _shareBtn.hidden = YES;
    [NC addObserver:self selector:@selector(alipayResultCurrent:) name:@"alipayres" object:nil];
    [NC addObserver:self selector:@selector(wxpayresultCurrent:) name:@"wxpaysuc" object:nil];
    if (WIDHT==320) {
        _gap.constant = 11;
        _gap1.constant = 11;
        _gap2.constant = 11;
        _gap3.constant = -28;
        _gap4.constant = 11;
        _height.constant =135;
        _gap5.constant = 15;
    }
    if (WIDHT==375) {
        
    }
    self.payType = 4;//给个非0,1,2,3
    _buttomView.hidden = YES;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意充值说明和押金说明"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(str.length-4,4)]; //设置字体颜色
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(str.length-9,4)]; //设置字体颜色
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12.0] range:NSMakeRange(0, 5)]; //设置字体字号和字体类别
    
    _xieyi.attributedText = str;

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
    [self.view addSubview:_backView];
    _payView = [[NSBundle mainBundle] loadNibNamed:@"YKSelectPayView" owner:self options:nil][0];
    _payView.frame = CGRectMake(0, HEIGHT, WIDHT, 236);
    _payView.selectPayBlock = ^(payMethod payMethod){
       
        [[YKPayManager sharedManager]payWithPayMethod:payMethod payType:weakSelf.payType OnResponse:^(NSDictionary *dic) {
            
        }];
    };
    _payView.cancleBlock = ^(void){
        [weakSelf diss];
    };
    [self.view addSubview:_payView];
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
    _agreeImage.selected = button.selected;
    isAgree = button.selected;
}

//去支付
- (IBAction)aliPay:(id)sender {
    if (!isAgree) {
        [smartHUD alertText:self.view alert:@"请先阅读充值说明并同意" delay:3.0];
        return;
    }
    if (self.payType!=0&&self.payType!=1&&self.payType!=2&&self.payType!=3) {
        [smartHUD alertText:self.view alert:@"请选择VIP类型" delay:1.2];
        return ;
    }
    [self creatPayView];
    //弹出选择支付方式
    WeakSelf(weakSelf)
    weakSelf.backView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.payView.frame = CGRectMake(0, HEIGHT-236, WIDHT, 236);
        weakSelf.backView.alpha = 0.5;
    }completion:^(BOOL finished) {
        
    }];
}

//选择会员种类
- (IBAction)select:(id)sender {
    
    if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
        _buttomView.hidden = NO;
        _shareBtn.hidden = NO;
        
    }else {//押金有效(只续费)
        _buttomView.hidden = YES;
        _shareBtn.hidden = YES;
    }
    

    UIButton * button = (UIButton *)sender;
 
    if (self.Button0 != button) {
        self.Button0.selected = NO;
        button.selected = YES;
    }
    self.Button0 = button;
    
    switch (button.tag) {
        case 1001:
            _payType = MONTH_CARD;
            _Btn1.selected = button.selected;
             _btn2.selected = !button.selected;
             _btn3.selected = !button.selected;
             _btn4.selected = !button.selected;
            break;
        case 1002:
            _payType = SEASON_CARD;
            _Btn1.selected = !button.selected;
            _btn2.selected = button.selected;
            _btn3.selected = !button.selected;
            _btn4.selected = !button.selected;
            break;
        case 1003:
            _payType = YEAR_CARD;
            _Btn1.selected = !button.selected;
            _btn2.selected = !button.selected;
            _btn3.selected = button.selected;
            _btn4.selected = !button.selected;
            break;
            
        default:
            
            break;
    }
    
    //TODO:添加固定算法
    
    //新用户并且分享过享受立减(0未分享过,1分享过)
    if ([[YKUserManager sharedManager].user.effective intValue] == 4
        && [[YKUserManager sharedManager].user.isShare intValue] == 1) {
      
        _shareBtn.hidden = YES;
        _liJIan.text = @"-¥200";
        if (_payType == MONTH_CARD) {
            _yuanJia.text = @"¥498";
            _yaJin.text = @"¥199";
            _total.text = @"¥298";
        }
        if (_payType == SEASON_CARD) {
            _yuanJia.text = @"¥1006";
            _yaJin.text = @"¥199";
            _total.text = @"¥806";
        }
        if (_payType == YEAR_CARD) {
            _yuanJia.text = @"¥3187";
            _yaJin.text = @"¥199";
            _total.text = @"¥2987";
        }
    }else {
        //新用户并且未分享过,可以分享
        if ([[YKUserManager sharedManager].user.effective intValue] == 4
            && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
            _shareBtn.hidden = NO;
        }else {//不是新用户,分享按钮永不显示
            _shareBtn.hidden = YES;
        }
        
        _liJIan.text = @"立减不可用";
        _liJIan.textColor = [UIColor colorWithHexString:@"ff6d6a"];
        
        if (_payType == MONTH_CARD) {
            _yuanJia.text = @"¥498";
            _yaJin.text = @"¥199";
            _total.text = @"¥498";
        }
        if (_payType == SEASON_CARD) {
            _yuanJia.text = @"¥1006";
            _yaJin.text = @"¥199";
            _total.text = @"¥1006";
        }
        if (_payType == YEAR_CARD) {
            _yuanJia.text = @"¥3187";
            _yaJin.text = @"¥199";
            _total.text = @"¥3187";
        }
    }
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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

- (void)getData{
    [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

- (IBAction)toShare:(id)sender {
    YKShareVC *share = [YKShareVC new];
    share.hidesBottomBarWhenPushed = YES;
    [[self getCurrentVC].navigationController pushViewController:share animated:YES];
//    [self.navigationController pushViewController:[YKShareVC new] animated:YES];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
        else{
            result = window.rootViewController;
        }
    }
    else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    
    return result;
}
@end
