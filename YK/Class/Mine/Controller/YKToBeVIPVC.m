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
#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import "HW3DBannerView.h"
#import "YKCouponListVC.h"

#define KScreenWidth self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height


@interface YKToBeVIPVC ()<UITextFieldDelegate>
{
    BOOL isShareUser;
    BOOL isAgree;
}
@property (nonatomic,strong) HW3DBannerView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *carPrice;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTextField;
@property (nonatomic,strong)UIButton *Button0;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)YKSelectPayView *payView;
@property (nonatomic,assign) payMethod payMethod;
@property (nonatomic,assign) payType payType;
@property (nonatomic,assign) NSInteger newUserType;//参与活动类型 1 分享立减 2买一赠一 0无活动

@property (weak, nonatomic) IBOutlet UIButton *agreeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleGap;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap5;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomH;
@property (weak, nonatomic) IBOutlet UILabel *yuanJia;
@property (weak, nonatomic) IBOutlet UILabel *liJIan;//价钱
@property (weak, nonatomic) IBOutlet UILabel *znegyi;
@property (weak, nonatomic) IBOutlet UILabel *zengday;

@property (weak, nonatomic) IBOutlet UILabel *yaJin;
@property (weak, nonatomic) IBOutlet UILabel *total;

@property (weak, nonatomic) IBOutlet UIButton *Btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UILabel *xieyi;

@property (weak, nonatomic) IBOutlet UILabel *ljLabel;//文字

@property (weak, nonatomic) IBOutlet UILabel *yj;

@property (nonatomic,strong)UIButton *Button1;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ljW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zengW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zengGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yjGap;
@property (weak, nonatomic) IBOutlet UIImageView *xianshiImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xianshiImageGap;

@end

@implementation YKToBeVIPVC
- (IBAction)yajinshuoming:(id)sender {
    
    YKWebVC *web = [YKWebVC new];
    web.titleStr = @"押金说明";
    web.imageName = @"押金说明";

    [self.navigationController pushViewController:web animated:YES];
}
- (IBAction)yonghuxieyi:(id)sender {
    YKWebVC *web = [YKWebVC new];
    web.titleStr = @"充值说明";
    web.imageName = @"充值说明";
    [self.navigationController pushViewController:web animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = YES;
    if ([YKUserManager sharedManager].isFromCoupon == YES) {
        _CouponId = [YKUserManager sharedManager].couponID;
        _CouponNum = [YKUserManager sharedManager].couponNum;
        _liJIan.text = [NSString stringWithFormat:@"-¥%ld",_CouponNum];
    }
    [YKUserManager sharedManager].isFromCoupon = NO;

    [self resetPrice];
//    [self resetUI];
}
- (void)resetPrice{
    if (_payType == MONTH_CARD) {
        _carPrice.text = @"月卡价";
        if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
            _yuanJia.text = @"¥299";
            _yaJin.text = @"¥199";
            NSInteger total = 498 - _CouponNum;
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }else {//押金有效(只续费)
            _yuanJia.text = @"¥299";
            _yaJin.text = @"¥0";
            NSInteger total = 299 - _CouponNum;
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
            
        }
    }
    if (_payType == SEASON_CARD) {
        _carPrice.text = @"季卡价";
        if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥199";
            NSInteger total = 1006 - _CouponNum;
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }else {//押金有效(只续费)
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥0";
            NSInteger total = 807 - _CouponNum;
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }
    }
    if (_payType == YEAR_CARD) {
        _carPrice.text = @"年卡价";
        if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
            _yuanJia.text = @"¥2988";
            _yaJin.text = @"¥199";
            NSInteger total = 3187 - _CouponNum;
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }else {//押金有效(只续费)
            _yuanJia.text = @"¥2988";
            _yaJin.text = @"¥0";
            NSInteger total = 2988 - _CouponNum;
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }
    }
    
    if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
        _yaJin.hidden = NO;
        _yj.hidden = NO;
        
    }else {//押金有效(只续费)
        _yaJin.hidden = YES;
        _yj.hidden = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)wechatShareSuccessNotification{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //拍下订单
    [MobClick event:@"__submit_payment" attributes:@{@"userid":[YKUserManager sharedManager].user.userId,@"orderid":@"158158158",@"item":@"衣库会员卡",@"amount":@"149"}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatShareSuccessNotification) name:@"wechatShareSuccessNotification" object:nil];
    
    _buttomView.layer.cornerRadius = 10;
    _buttomView.layer.masksToBounds = YES;
//    _buttomView.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
//    _buttomView.layer.borderWidth = 0.5;
    
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
    if (HEIGHT==812) {
        _titleGap.constant = 60;
    }
    self.payType = 4;//给个非0,1,2,3
    _buttomView.hidden = NO;

  
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意充值说明和押金说明"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-4,4)]; //设置字体颜色
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-9,4)]; //设置字体颜色
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12.0] range:NSMakeRange(0, 5)]; //设置字体字号和字体类别
    
    _xieyi.attributedText = str;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    [_liJIan setUserInteractionEnabled:YES];
    [_liJIan addGestureRecognizer:tap];
    
    WeakSelf(weakSelf)
    _scrollView = [HW3DBannerView initWithFrame:CGRectMake(0, BarH+24, WIDHT, 200) imageSpacing:10 imageWidth:WIDHT - 50];
    _scrollView.initAlpha = 0.5; // 设置两边卡片的透明度
    _scrollView.imageRadius = 10; // 设置卡片圆角
    _scrollView.imageHeightPoor = 20; // 设置中间卡片与两边卡片的高度差
    // 设置要加载的图片
    self.scrollView.data = @[@"yueka1",@"jika1",@"nianka1"];
    _scrollView.placeHolderImage = [UIImage imageNamed:@"商品图"]; // 设置占位图片
    [self.view addSubview:self.scrollView];
    _scrollView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
        NSLog(@"%ld",currentIndex);
        _payType = currentIndex+1;
        [weakSelf resetPrice];
    };
    _payType = MONTH_CARD;
    self.CouponId = 0;
    self.CouponNum = 0;
    [self resetPrice];
    
//    [weakSelf resetUI];
}

- (BOOL)isLowerLetter:(NSString *)str

{
    
    if ([str characterAtIndex:0] >= 'a' && [str characterAtIndex:0] <= 'z') {
        
        return YES;
        
    }
    
    return NO;
    
}



//判断是不是大写字母

- (BOOL)isCatipalLetter:(NSString *)str

{
    
    if ([str characterAtIndex:0] >= 'A' && [str characterAtIndex:0] <= 'Z') {
        
        return YES;
        
    }
    
    return NO;
    
}
//判断是不是数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if (theTextField == _inviteCodeTextField) {
            if (theTextField.text.length > 6) {
                theTextField.text = [theTextField.text substringToIndex:6];
            }
        }
    
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.text.length==6) {
        
        NSString *temp = nil;
        for(int i =0; i < [theTextField.text length]; i++)
        {
            temp = [theTextField.text substringWithRange:NSMakeRange(i,1)];//得到每一个元素
            if (![self isCatipalLetter:temp] && ![self isLowerLetter:temp] &&![self isPureInt:temp]) {
                [smartHUD alertText:self.view alert:@"不能包含非法字符" delay:2];
                return;
            }
        }
        //校验邀请码是否有效
        [[YKUserManager sharedManager]checkInviteCode:theTextField.text OnResponse:^(NSDictionary *dic) {
            
        }];
    }
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
    
    //新老用户无活动
    _newUserType = 0;
    
        
    _payView.selectPayBlock = ^(payMethod payMethod){
    
        
//        [[YKPayManager sharedManager]payWithPayMethod:payMethod payType:weakSelf.payType activity:0 OnResponse:^(NSDictionary *dic) {
//
//        }];
        [[YKPayManager sharedManager]payWithPayMethod:payMethod payType:weakSelf.payType activity:weakSelf.newUserType channelId:weakSelf.CouponId OnResponse:^(NSDictionary *dic) {

        }];
//        [[YKPayManager sharedManager]payWithPayMethod:payMethod payType:weakSelf.payType activity:weakSelf.newUserType channelId:_CouponId OnResponse:^(NSDictionary *dic) {
//
//        }];
     
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
        [smartHUD alertText:self.view alert:@"请先阅读充值说明并同意" delay:2.0];
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
    
    
}

- (void)resetUI{
    //如果押金有效
    
    
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
        //完成付费
        [MobClick event:@"__finish_payment" attributes:@{@"userid":[YKUserManager sharedManager].user.userId,@"orderid":@"158158158",@"item":@"衣库会员卡",@"amount":@"149"}];
        //监测
        [MobClick event:@"pay"];
        
    }else if ([[dict objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }else{
        
        
    }
}

//微信支付结果
-(void)wxpayresultCurrent:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    
    if ([[dict objectForKey:@"codeid"]integerValue]==0) {
        
        //完成付费
         [MobClick event:@"__finish_payment" attributes:@{@"userid":[YKUserManager sharedManager].user.userId,@"orderid":@"158158158",@"item":@"衣库会员卡",@"amount":@"149"}];
        //主包监测
        [MobClick event:@"pay"];
        [self getData];
        
    }else{
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }
}

- (void)getData{
    [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

- (void)share{
    YKCouponListVC *Coupon = [YKCouponListVC new];
    Coupon.isFromPay = YES;
    Coupon.selectCoupon = ^(NSInteger ConponNum,int CouponId){
        _CouponNum = ConponNum;
        _CouponId = CouponId;
        _liJIan.text = [NSString stringWithFormat:@"-¥%ld",ConponNum];
        [self resetPrice];
    };
    [[self getCurrentVC].navigationController pushViewController:Coupon animated:YES];
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
- (IBAction)toShare:(id)sender {
    [self share];
}

@end
