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
#import "YKInputCodeView.h"

#define KScreenWidth self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height


@interface YKToBeVIPVC ()<UITextFieldDelegate,DXAlertViewDelegate>
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yjGap;


@property (weak, nonatomic) IBOutlet UILabel *myAccount;//用户余额
@property (weak, nonatomic) IBOutlet UILabel *cardDes;//卡描述
@property (nonatomic,strong)NSString *account;//用户余额
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hhh;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomTop;

@property (nonatomic,strong)UILabel *inviteCode;

@property (weak, nonatomic) IBOutlet UILabel *titleBtn;


@end

@implementation YKToBeVIPVC
- (IBAction)toD:(id)sender {
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"次卡使用说明" message:@"1. 次卡购买后不可退订；\n2. 从下单起开始计算日期，到归还衣袋为止，期限为7天；\n3. 每超过期限一天，将从押金中扣除10元；超过7天期限，剩余押金将被冻结；\n4. 如有疑问，请联系客服。\n" cancelBtnTitle:@"这个隐藏" otherBtnTitle:@"我知道了"];
    alertView.delegate = self;
    [alertView show];
}

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
    
    _titleBtn.font = PingFangSC_Medium(kSuitLength_H(14));
    _titleBtn.text = @"选择卡类型";
    if (WIDHT==320 || HEIGHT==812) {
        isAgree = YES;
    }
    if ([YKUserManager sharedManager].isFromCoupon == YES) {
        _CouponId = [YKUserManager sharedManager].couponID;
        _CouponNum = [YKUserManager sharedManager].couponNum;
        //次卡优惠劵无效
//        [smartHUD alertText:self.view alert:@"次卡暂不支持优惠劵" delay:2.0];
//        _liJIan.text = [NSString stringWithFormat:@"-¥%ld",_CouponNum];
    }
    [YKUserManager sharedManager].isFromCoupon = NO;

    [self resetPrice];
//    [self resetUI];
}
- (void)resetPrice{
    if ([[YKUserManager sharedManager].user.depositEffective intValue] !=1) { //押金无效(充押金并续费)
        _accountGap.constant = 60;
        _bh.constant = 230;
        _hhh.constant = 38;
        if (WIDHT==375) {
            _accountGap.constant = 55;
            _bh.constant = 210;
            _hhh.constant = 30;
        }
    }else {//押金有效(只续费)
        _accountGap.constant = 20;
        _bh.constant = 195;
        
        self.yaJin.text = @"已交押金";
    }
    if (_payType == ONCE_CARD) {
        if (self.CouponNum==0) {
            _liJIan.text = @"选择优惠劵 >";
        }else {
            _liJIan.text = @"次卡暂不支持优惠劵";
        }
    }else {
        if (self.CouponNum==0) {
             _liJIan.text = @"选择优惠劵 >";
        }else {
        _liJIan.text = [NSString stringWithFormat:@"-¥%ld",self.CouponNum];
        }
    }
   
    if (_payType == ONCE_CARD) {
        _cardDes.text = @"次卡可享受衣库一次提供的无限换衣特权";
        _carPrice.text = @"次卡价";
        _detailBtn.hidden = NO;
        if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
            _yuanJia.text = @"¥69";
            _yaJin.text = @"¥199";
            NSInteger total = 199+69-[_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }else {//押金有效(只续费)
            _yuanJia.text = @"¥69";
            _yaJin.text = @"¥0";
            NSInteger total = 69-[_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
            
        }
    }
    if (_payType == MONTH_CARD) {
        _detailBtn.hidden = YES;
        _carPrice.text = @"月卡价";
        _cardDes.text = @"月卡可享受衣库30天内提供的无限换衣特权";

        if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
            _yuanJia.text = @"¥299";
            _yaJin.text = @"¥199";
            NSInteger total = 498 - _CouponNum- [_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }else {//押金有效(只续费)
            _yuanJia.text = @"¥299";
            _yaJin.text = @"¥0";
             self.yaJin.text = @"已交押金";
            NSInteger total = 299 - _CouponNum - [_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
            
        }
    }
    if (_payType == SEASON_CARD) {
        _detailBtn.hidden = YES;
        _carPrice.text = @"季卡价";
        _cardDes.text = @"季卡可享受衣库90天内提供的无限换衣特权";

        if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥199";
            NSInteger total = 1006 - _CouponNum- [_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }else {//押金有效(只续费)
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥0";
             self.yaJin.text = @"已交押金";
            NSInteger total = 807 - _CouponNum- [_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }
    }
    if (_payType == YEAR_CARD) {
        _detailBtn.hidden = YES;
        _carPrice.text = @"年卡价";
        _cardDes.text = @"年卡可享受衣库365天内提供的无限换衣特权";

        if ([[YKUserManager sharedManager].user.depositEffective intValue] !=1) { //押金无效(充押金并续费)
            _yuanJia.text = @"¥2988";
            _yaJin.text = @"¥199";
            NSInteger total = 3187 - _CouponNum- [_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }else {//押金有效(只续费)
            _yuanJia.text = @"¥2988";
            _yaJin.text = @"¥0";
             self.yaJin.text = @"已交押金";
            NSInteger total = 2988 - _CouponNum- [_account intValue];
            _total.text = [NSString stringWithFormat:@"¥%ld",total];
        }
    }
    
    if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
        _yaJin.hidden = NO;
        _yj.hidden = NO;
        
    }else {//押金有效(只续费)
//        _yaJin.hidden = YES;
//        _yj.hidden = YES;
         self.yaJin.text = @"已交押金";
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
    self.payType = 5;//给个非0,1,2,3,4
    _buttomView.hidden = NO;

  
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意充值说明和押金说明"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-4,4)]; //设置字体颜色
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-9,4)]; //设置字体颜色
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12.0] range:NSMakeRange(0, 5)]; //设置字体字号和字体类别
    
    _xieyi.attributedText = str;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    [_liJIan setUserInteractionEnabled:YES];
    [_liJIan addGestureRecognizer:tap];
    
    UIScrollView *bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, BarH, WIDHT, HEIGHT-kSuitLength_H(150))];
    bigScrollView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.view addSubview:bigScrollView];
    bigScrollView.scrollEnabled = YES;
//    bigScrollView.showsHorizontalScrollIndicator = NO;
//    bigScrollView.showsVerticalScrollIndicator = NO;
    bigScrollView.contentSize = CGSizeMake(0, HEIGHT);
    
    WeakSelf(weakSelf)
    _scrollView = [HW3DBannerView initWithFrame:CGRectMake(0, kSuitLength_H(10), WIDHT, kSuitLength_H(140)) imageSpacing:14 imageWidth:WIDHT - kSuitLength_H(140)];
    _scrollView.initAlpha = 0.8; // 设置两边卡片的透明度
    _scrollView.imageRadius = kSuitLength_H(14); // 设置卡片圆角
    _scrollView.imageHeightPoor = kSuitLength_H(20); // 设置中间卡片与两边卡片的高度差
    // 设置要加载的图片
    self.scrollView.data = @[@"月卡-1",@"季卡-2",@"nianka1"];
    _scrollView.placeHolderImage = [UIImage imageNamed:@"商品图"]; // 设置占位图片
    [bigScrollView addSubview:self.scrollView];
    _scrollView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
        NSLog(@"%ld",currentIndex);
        _payType = currentIndex+1;
//        if (currentIndex==0) {
//            _payType = MONTH_CARD;
//        }else {
//            _payType = currentIndex;
//        }
        
        [weakSelf resetPrice];
    };
    //服务内容view
    UIView *serviceView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.bottom + kSuitLength_H(10), WIDHT, kSuitLength_H(100))];
    serviceView.backgroundColor = [UIColor whiteColor];
    [bigScrollView addSubview:serviceView];
    
    //服务内容
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, kSuitLength_H(10), WIDHT, kSuitLength_H(20))];
    l.text = @"服务内容";
    l.textColor = [UIColor colorWithHexString:@"1f1f1f"];
    l.font = PingFangSC_Medium(kSuitLength_H(14));
    l.textAlignment = NSTextAlignmentCenter;
    [serviceView addSubview:l];
    //Content
    UILabel *l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, l.bottom+kSuitLength_H(4), WIDHT, kSuitLength_H(12))];
    l2.text = @"Content";
    l2.textColor = [UIColor colorWithHexString:@"cccccc"];
    l2.font = PingFangSC_Medium(kSuitLength_H(12));
    l2.textAlignment = NSTextAlignmentCenter;
    [serviceView addSubview:l2];
    //点1
    UILabel *l3 = [[UILabel alloc]initWithFrame:CGRectMake(kSuitLength_H(47), l2.bottom+kSuitLength_H(13), kSuitLength_H(8), kSuitLength_H(8))];
    l3.backgroundColor = YKRedColor;
    l3.layer.masksToBounds = YES;
    l3.layer.cornerRadius = kSuitLength_H(8)/2;
    [serviceView addSubview:l3];
    
    //点2
    UILabel *l4 = [[UILabel alloc]initWithFrame:CGRectMake(kSuitLength_H(47), l3.bottom+kSuitLength_H(16), kSuitLength_H(8), kSuitLength_H(8))];
    l4.backgroundColor = YKRedColor;
    l4.layer.masksToBounds = YES;
    l4.layer.cornerRadius = kSuitLength_H(8)/2;
    [serviceView addSubview:l4];
    //卡描述
    UILabel *cardDes = [[UILabel alloc]initWithFrame:CGRectMake(l3.right+kSuitLength_H(9),l.bottom+kSuitLength_H(19) , WIDHT, kSuitLength_H(20))];
    cardDes.centerY = l3.centerY;
    cardDes.text = @"年卡可享受衣库365天内提供的无限换衣特权";
    cardDes.textColor = [UIColor colorWithHexString:@"1f1f1f"];;
    cardDes.font = PingFangSC_Medium(kSuitLength_H(12));
    cardDes.textAlignment = NSTextAlignmentLeft;
    self.cardDes = cardDes;
    [serviceView addSubview:cardDes];
    
    //负责描述
    UILabel *Des = [[UILabel alloc]initWithFrame:CGRectMake(l4.right+kSuitLength_H(9),cardDes.bottom+kSuitLength_H(8) , WIDHT, kSuitLength_H(20))];
    Des.centerY = l4.centerY;
    Des.text = @"衣库负责服装的往返包邮，专业清洗，消毒，除菌";
    Des.textColor = [UIColor colorWithHexString:@"1f1f1f"];;
    Des.font = PingFangSC_Medium(kSuitLength_H(12));
    Des.textAlignment = NSTextAlignmentLeft;
    [serviceView addSubview:Des];
    
    //价钱展示视图
    UIView *buttomV = [[UIView alloc]initWithFrame:CGRectMake(0, serviceView.bottom + kSuitLength_H(10), WIDHT, kSuitLength_H(240))];
    buttomV.backgroundColor = [UIColor whiteColor];
    [bigScrollView addSubview:buttomV];
    
    //卡类型
    UILabel *cardType = [[UILabel alloc]initWithFrame:CGRectZero];
    cardType.textColor = mainColor;
    cardType.font = PingFangSC_Regular(kSuitLength_H(14));
    self.carPrice = cardType;
    [buttomV addSubview:cardType];
    [cardType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(24));
        make.top.mas_equalTo(kSuitLength_H(16));
    }];
    
    //卡价钱
    UILabel *cardPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    cardPrice.textColor = mainColor;
    cardPrice.font = PingFangSC_Regular(kSuitLength_H(14));
    self.yuanJia = cardPrice;
    [buttomV addSubview:cardPrice];
    [cardPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-24));
        make.top.mas_equalTo(kSuitLength_H(16));
    }];
    
    //押金描述
    UILabel *yajin = [[UILabel alloc]initWithFrame:CGRectZero];
    yajin.textColor = mainColor;
    yajin.font = PingFangSC_Regular(kSuitLength_H(14));
    yajin.text = @"押金";
//    self.yaJin = cardType;
    [buttomV addSubview:yajin];
    [yajin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(24));
        make.top.mas_equalTo(cardType.mas_bottom).offset(kSuitLength_H(14));
    }];
    //押金
    UILabel *yajinD = [[UILabel alloc]initWithFrame:CGRectZero];
    yajinD.textColor = mainColor;
    yajinD.font = PingFangSC_Regular(kSuitLength_H(14));
    self.yaJin = yajinD;
    [buttomV addSubview:yajinD];
    [yajinD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-24));
        make.top.mas_equalTo(cardPrice.mas_bottom).offset(kSuitLength_H(14));
    }];
    
    //优惠劵
    UILabel *coupon = [[UILabel alloc]initWithFrame:CGRectZero];
    coupon.textColor = mainColor;
    coupon.font = PingFangSC_Regular(kSuitLength_H(14));
//    self. = yajinD;
    coupon.text = @"优惠劵";
    [buttomV addSubview:coupon];
    [coupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(24));
        make.top.mas_equalTo(yajin.mas_bottom).offset(kSuitLength_H(14));
    }];
//
    //选择优惠劵
    UILabel *seCoupon = [[UILabel alloc]initWithFrame:CGRectZero];
    seCoupon.textColor = YKRedColor;
    seCoupon.font = PingFangSC_Regular(kSuitLength_H(14));
    seCoupon.text = @"选择优惠劵 >";
    self.liJIan = seCoupon;
    [seCoupon setUserInteractionEnabled:YES];
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    [_liJIan setUserInteractionEnabled:YES];
    [_liJIan addGestureRecognizer:t];
    [buttomV addSubview:seCoupon];
    [seCoupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-24));
        make.top.mas_equalTo(yajinD.mas_bottom).offset(kSuitLength_H(14));
    }];
//
    //邀请码
    UILabel *inviteC = [[UILabel alloc]initWithFrame:CGRectZero];
    inviteC.textColor = mainColor;
    inviteC.font = PingFangSC_Regular(kSuitLength_H(14));

    inviteC.text = @"邀请码";
    [buttomV addSubview:inviteC];
    [inviteC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(24));
        make.top.mas_equalTo(coupon.mas_bottom).offset(kSuitLength_H(14));
    }];
//
    //点击邀请码
    UILabel *inviteCode = [[UILabel alloc]initWithFrame:CGRectZero];
    inviteCode.textColor = [UIColor colorWithHexString:@"999999"];
    inviteCode.font = PingFangSC_Regular(kSuitLength_H(14));
    inviteCode.text = @"点击输入邀请码 >";
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        //弹出邀请码输入框
        YKInputCodeView *loginView = [[YKInputCodeView alloc]initWithFrame:kWindow.bounds];
        loginView.loginSuccess = ^(NSString *invitCode){
            _inviteCode.text = invitCode;
        };
        
        [kWindow addSubview:loginView];
        
    }];
    [inviteCode setUserInteractionEnabled:YES];
    [inviteCode addGestureRecognizer:tap1];
    self.inviteCode = inviteCode;
    [buttomV addSubview:inviteCode];
    [inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-24));
        make.top.mas_equalTo(seCoupon.mas_bottom).offset(kSuitLength_H(14));
    }];
//
    //资金账户
    UILabel *userAcc = [[UILabel alloc]initWithFrame:CGRectZero];
    userAcc.textColor = mainColor;
    userAcc.font = PingFangSC_Regular(kSuitLength_H(14));
    //    self. = seCoupon;
    [buttomV addSubview:userAcc];
    userAcc.text = @"资金账户";
    [userAcc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(24));
        make.top.mas_equalTo(inviteC.mas_bottom).offset(kSuitLength_H(14));
    }];
////
    //资金账户描述
    UILabel *userDes = [[UILabel alloc]initWithFrame:CGRectZero];
    userDes.textColor = YKRedColor;
    userDes.font = PingFangSC_Regular(kSuitLength_H(14));
    self.myAccount = userDes;
    [buttomV addSubview:userDes];
    [userDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-24));
        make.top.mas_equalTo(inviteC.mas_bottom).offset(kSuitLength_H(14));
    }];
//
//    线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    [buttomV addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(24));
        make.top.mas_equalTo(userDes.mas_bottom).offset(kSuitLength_H(14));
        make.width.mas_equalTo(WIDHT-kSuitLength_H(16)*2);
        make.height.equalTo(@1);
    }];
//
    //总价
    UILabel *total = [[UILabel alloc]initWithFrame:CGRectZero];
    total.textColor = mainColor;
    total.font = PingFangSC_Medium(kSuitLength_H(20));
    [buttomV addSubview:total];
    total.text = @"总价";
    [total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(24));
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(14));
    }];
    //总价描述
    UILabel *totalP = [[UILabel alloc]initWithFrame:CGRectZero];
    totalP.textColor = mainColor;
    totalP.font = PingFangSC_Medium(kSuitLength_H(20));
    self.total =totalP;
    [buttomV addSubview:totalP];
    [totalP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kSuitLength_H(-24));
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(14));
    }];
    
    
//    [userDes mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kSuitLength_H(-16));
//        make.top.mas_equalTo(inviteC.mas_bottom).offset(kSuitLength_H(14));
//    }];

    
    //
//    _buttomView.frame = CGRectMake(0, serviceView.bottom + kSuitLength_H(10), WIDHT, kSuitLength_H(300));
    _buttomTop.constant = kSuitLength_H(330);
//    [_buttomView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_offset(serviceView.mas_bottom).offset(kSuitLength_H(10));
//    }];
    
    _payType = MONTH_CARD;
    self.CouponId = 0;
    self.CouponNum = 0;
    [self resetPrice];
    
    [[YKUserManager sharedManager]getAccountPageOnResponse:^(NSDictionary *dic) {
        _account = dic[@"data"][@"capital"];
        if ([_account intValue] == 0) {
            _myAccount.text = [NSString stringWithFormat:@"账户余额为0"];
        }else {
        _myAccount.text = [NSString stringWithFormat:@"账户余额抵扣%@元",_account];
        }
         [self resetPrice];
    }];
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
        if (_payType == ONCE_CARD) {
            weakSelf.CouponId = 0;
        }
        [[YKPayManager sharedManager]payWithPayMethod:payMethod payType:weakSelf.payType activity:weakSelf.newUserType channelId:weakSelf.CouponId inviteCode:_inviteCode.text OnResponse:^(NSDictionary *dic) {

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
    if (self.payType!=0&&self.payType!=1&&self.payType!=2&&self.payType!=3&&self.payType!=4) {
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
        NSString *des;
        switch (_payType) {
            case 1:
                des = @"衣库月卡(阿里支付)";
                break;
            case 2:
                des = @"衣库季卡(阿里支付)";
                break;
            case 3:
                des = @"衣库年卡(阿里支付)";
                break;
                
            default:
                break;
        }
        [MobClick event:@"__finish_payment" attributes:@{@"userid":[YKUserManager sharedManager].user.userId,@"orderid":[YKUserManager sharedManager].user.phone,@"item":des,@"amount":_total.text}];
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
        NSString *des;
        switch (_payType) {
            case 1:
                des = @"衣库月卡(微信支付)";
                break;
            case 2:
                des = @"衣库季卡(微信支付)";
                break;
            case 3:
                des = @"衣库年卡(微信支付)";
                break;
                
            default:
                break;
        }
         [MobClick event:@"__finish_payment" attributes:@{@"userid":[YKUserManager sharedManager].user.userId,@"orderid":[YKUserManager sharedManager].user.phone,@"item":des,@"amount":_total.text}];
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
    if (_payType == ONCE_CARD) {
        [smartHUD alertText:self.view alert:@"次卡暂不支持优惠劵" delay:2.0];
        return;
    }
    YKCouponListVC *Coupon = [YKCouponListVC new];
    Coupon.isFromPay = YES;
    Coupon.selectedIndex = 101;
    
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
