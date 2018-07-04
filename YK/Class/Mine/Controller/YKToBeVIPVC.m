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

@interface YKToBeVIPVC ()<UITextFieldDelegate>
{
    BOOL isShareUser;
    BOOL isAgree;
}
@property (weak, nonatomic) IBOutlet UILabel *carPrice;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTextField;
@property (nonatomic,strong)UIButton *Button0;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)YKSelectPayView *payView;
@property (nonatomic,assign) payMethod payMethod;
@property (nonatomic,assign) payType payType;
@property (nonatomic,assign) NSInteger newUserType;//参与活动类型 1 分享立减 2买一赠一

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
@property (weak, nonatomic) IBOutlet UILabel *liJIan;
@property (weak, nonatomic) IBOutlet UILabel *znegyi;
@property (weak, nonatomic) IBOutlet UILabel *zengday;

@property (weak, nonatomic) IBOutlet UILabel *yaJin;
@property (weak, nonatomic) IBOutlet UILabel *total;

@property (weak, nonatomic) IBOutlet UIButton *Btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UILabel *xieyi;

//
@property (weak, nonatomic) IBOutlet UIButton *Lbtn1;
@property (weak, nonatomic) IBOutlet UIButton *Lbtn2;
@property (weak, nonatomic) IBOutlet UIButton *Lbtn3;
@property (weak, nonatomic) IBOutlet UILabel *yueka;

@property (weak, nonatomic) IBOutlet UILabel *yuekaPrice;

@property (weak, nonatomic) IBOutlet UILabel *jika;
@property (weak, nonatomic) IBOutlet UILabel *jikaPrice;

@property (weak, nonatomic) IBOutlet UILabel *nianka;
@property (weak, nonatomic) IBOutlet UILabel *niankaPrice;


@property (weak, nonatomic) IBOutlet UILabel *ljLabel;

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
    
    //新用户并且分享过享受立减(0未分享过,1分享过)
    if (([[YKUserManager sharedManager].user.effective intValue] == 4||[[YKUserManager sharedManager].user.cardType intValue]==4)
        && [[YKUserManager sharedManager].user.isShare intValue] == 1) {
        
        _shareBtn.hidden = YES;
        _ljLabel.hidden = YES;
        _liJIan.hidden = YES;
        _inviteCodeTextField.hidden = NO;
        _liJIan.text = @"-¥150";
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
            _yuanJia.text = @"¥299";
            _yaJin.text = @"¥199";
            _total.text = @"¥348";
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥199";
            _total.text = @"¥856";
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
            _yuanJia.text = @"¥2988";
            _yaJin.text = @"¥199";
            _total.text = @"¥3037";
        }
    }else {
        //新用户并且未分享过,可以分享
        if (([[YKUserManager sharedManager].user.effective intValue] == 4||[[YKUserManager sharedManager].user.cardType intValue]==4)
            && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
//            _shareBtn.hidden = NO;
//            _inviteCodeTextField.hidden = NO;
        }else {//不是新用户,分享按钮永不显示
            _shareBtn.hidden = YES;
            _ljLabel.hidden = NO;
            _liJIan.hidden = NO;
            if ([[YKUserManager sharedManager].user.effective intValue] == 4) {
                _inviteCodeTextField.hidden = NO;
            }
//            _inviteCodeTextField.hidden = YES;
        }
        
        //会员用户
        _ljLabel.hidden = YES;
        _liJIan.hidden = YES;
        _liJIan.text = @"立减不可用";
        _liJIan.textColor = [UIColor colorWithHexString:@"ff6d6a"];
        
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
            _yuanJia.text = @"¥299";
            _yaJin.text = @"¥199";
            _total.text = @"¥498";
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥199";
            _total.text = @"¥1006";
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
            _yuanJia.text = @"¥2988";
            _yaJin.text = @"¥199";
            _total.text = @"¥3187";
        }
    }
    //新用户并且分享过享受立减(0未分享过,1分享过)
    if (([[YKUserManager sharedManager].user.effective intValue] == 4||[[YKUserManager sharedManager].user.cardType intValue]==4)
        && [[YKUserManager sharedManager].user.isShare intValue] == 1) {
        
        _shareBtn.hidden = YES;
        _ljLabel.hidden = NO;
        _liJIan.hidden = NO;
        _inviteCodeTextField.hidden = NO;
        _liJIan.text = @"-¥150";
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
            
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥348";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥0";
                _total.text = @"¥299";
            }
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            
//            _newUserType = 2;
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥856";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥0";
                _total.text = @"¥149";
            }
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
            
//            _newUserType = 2;
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3037";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥0";
                _total.text = @"¥2848";
            }
        }
    }else {
        //新用户并且未分享过,可以分享
        _ljLabel.hidden = NO;
        _liJIan.hidden = NO;
        if ([[YKUserManager sharedManager].user.effective intValue] == 4
            && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
            //            _shareBtn.hidden = NO;
            _inviteCodeTextField.hidden = NO;
            
        }else {//不是新用户,分享按钮永不显示
            _shareBtn.hidden = YES;
            if ([[YKUserManager sharedManager].user.effective intValue] == 4){
                _inviteCodeTextField.hidden = NO;
            }
            
        }
        
        //会员用户
        _ljLabel.hidden = YES;
        _liJIan.hidden = YES;
        _liJIan.text = @"立减不可用";
        _liJIan.textColor = [UIColor colorWithHexString:@"ff6d6a"];
        
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
            
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥498";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥299";
            }
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥199";
            _total.text = @"¥1006";
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥1006";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥807";
            }
//            _newUserType = 2;
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
            
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3187";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥2988";
            }
//            _newUserType = 2;
        }
    }
    
    
    [self resetUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDis:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    
       [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)wechatShareSuccessNotification{
    [[YKUserManager sharedManager]shareSuccessOnResponse:^(NSDictionary *dic) {
        
        //新用户并且分享过享受立减(0未分享过,1分享过)
        if ([[YKUserManager sharedManager].user.effective intValue] == 4
            && [[YKUserManager sharedManager].user.isShare intValue] == 1) {
            
            _shareBtn.hidden = YES;
            _inviteCodeTextField.hidden = NO;
            _liJIan.text = @"-¥150";
            _ljLabel.hidden = NO;
            _liJIan.hidden = NO;
            if (_payType == MONTH_CARD) {
                _carPrice.text = @"月卡价";
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥348";
            }
            if (_payType == SEASON_CARD) {
                _carPrice.text = @"季卡价";
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥856";
            }
            if (_payType == YEAR_CARD) {
                _carPrice.text = @"年卡价";
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3037";
            }
        }else {
            //新用户并且未分享过,可以分享
            _ljLabel.hidden = NO;
            _liJIan.hidden = NO;
            if ([[YKUserManager sharedManager].user.effective intValue] == 4
                && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
//                _shareBtn.hidden = NO;
                _inviteCodeTextField.hidden = NO;
                
            }else {//不是新用户,分享按钮永不显示
                _shareBtn.hidden = YES;
                if ([[YKUserManager sharedManager].user.effective intValue] == 4){
                    _inviteCodeTextField.hidden = NO;
                }
                
            }
            
            //会员用户
            _ljLabel.hidden = YES;
            _liJIan.hidden = YES;
            _liJIan.text = @"立减不可用";
            _liJIan.textColor = [UIColor colorWithHexString:@"ff6d6a"];
            
            if (_payType == MONTH_CARD) {
                _carPrice.text = @"月卡价";
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥498";
            }
            if (_payType == SEASON_CARD) {
                _carPrice.text = @"季卡价";
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥1006";
            }
            if (_payType == YEAR_CARD) {
                _carPrice.text = @"年卡价";
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3187";
            }
        }
    }];
    
    //新用户并且分享过享受立减(0未分享过,1分享过)
    if ([[YKUserManager sharedManager].user.effective intValue] == 4
        && [[YKUserManager sharedManager].user.isShare intValue] == 1) {
        
        _shareBtn.hidden = YES;
        _ljLabel.hidden = NO;
        _liJIan.hidden = NO;
        _inviteCodeTextField.hidden = NO;
        _liJIan.text = @"-¥150";
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
            
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥348";
                if (_newUserType==1) {
                    _total.text = @"¥348";
                }else {
                    _total.text = @"¥498";
                }
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥0";
                _total.text = @"¥299";
                if (_newUserType==1) {
                    _total.text = @"¥149";
                }else {
                    _total.text = @"¥299";
                }
            }
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            
            _newUserType = 2;
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥856";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥0";
                _total.text = @"¥149";
            }
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
            
            _newUserType = 2;
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3037";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥0";
                _total.text = @"¥2848";
            }
        }
    }else {
        //新用户并且未分享过,可以分享
        _ljLabel.hidden = NO;
        _liJIan.hidden = NO;
        if ([[YKUserManager sharedManager].user.effective intValue] == 4
            && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
            //            _shareBtn.hidden = NO;
            _inviteCodeTextField.hidden = NO;
            
        }else {//不是新用户,分享按钮永不显示
            _shareBtn.hidden = YES;
            if ([[YKUserManager sharedManager].user.effective intValue] == 4){
                _inviteCodeTextField.hidden = NO;
            }
            
        }
        
        //会员用户
        _ljLabel.hidden = YES;
        _liJIan.hidden = YES;
        _liJIan.text = @"立减不可用";
        _liJIan.textColor = [UIColor colorWithHexString:@"ff6d6a"];
        
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
            
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥498";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥299";
            }
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥199";
            _total.text = @"¥1006";
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥1006";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥807";
            }
//            _newUserType = 2;
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
            
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3187";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥2988";
            }
//            _newUserType = 2;
        }
    }
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatShareSuccessNotification) name:@"wechatShareSuccessNotification" object:nil];
    
    _shareBtn.hidden = YES;
    _inviteCodeTextField.hidden = YES;
    _inviteCodeTextField.delegate = self;
    _inviteCodeTextField.keyboardType = UIKeyboardTypeDefault;
    _inviteCodeTextField.returnKeyType = UIReturnKeyDone;
    
    [_inviteCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
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
    _buttomView.hidden = YES;
    _newUserType = 1;
    _btn4.selected = YES;
    self.Button1 = _btn4;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意充值说明和押金说明"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-4,4)]; //设置字体颜色
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-9,4)]; //设置字体颜色
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12.0] range:NSMakeRange(0, 5)]; //设置字体字号和字体类别
    
    _xieyi.attributedText = str;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(share)];
    [_liJIan setUserInteractionEnabled:YES];
    [_liJIan addGestureRecognizer:tap];

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
    _payView.selectPayBlock = ^(payMethod payMethod){
        

       
        [[YKPayManager sharedManager]payWithPayMethod:payMethod payType:weakSelf.payType activity:weakSelf.newUserType OnResponse:^(NSDictionary *dic) {
            
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
    
    if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
        _buttomView.hidden = NO;
//        _shareBtn.hidden = NO;
        _yaJin.hidden = NO;
        _yj.hidden = NO;
        
    }else {//押金有效(只续费)
        _yaJin.hidden = YES;
        _yj.hidden = YES;
        _buttomView.hidden = NO;
        _shareBtn.hidden = YES;
        _inviteCodeTextField.hidden = YES;
    }
    

    UIButton * button = (UIButton *)sender;
 
    if (self.Button0 != button) {
        self.Button0.selected = NO;
        button.selected = YES;
    }
    self.Button0 = button;
    
    [self reSetBtnUI:button];
    
    switch (button.tag) {
        case 1001:
            _payType = MONTH_CARD;
            _Btn1.selected = button.selected;
             _btn2.selected = !button.selected;
             _btn3.selected = !button.selected;
            
            break;
        case 1002:
            _payType = SEASON_CARD;
            _Btn1.selected = !button.selected;
            _btn2.selected = button.selected;
            _btn3.selected = !button.selected;
           
            break;
        case 1003:
            _payType = YEAR_CARD;
            _Btn1.selected = !button.selected;
            _btn2.selected = !button.selected;
            _btn3.selected = button.selected;
            
            break;
            
        case 101:
            _payType = MONTH_CARD;
            _Btn1.selected = button.selected;
            _btn2.selected = !button.selected;
            _btn3.selected = !button.selected;
            
            break;
        case 102:
            _payType = SEASON_CARD;
            _Btn1.selected = !button.selected;
            _btn2.selected = button.selected;
            _btn3.selected = !button.selected;
            
            break;
        case 103:
            _payType = YEAR_CARD;
            _Btn1.selected = !button.selected;
            _btn2.selected = !button.selected;
            _btn3.selected = button.selected;
            
            break;
        default:
            
            break;
    }
    
    //TODO:添加固定算法
    
    //新用户并且分享过享受立减(0未分享过,1分享过)
    if (([[YKUserManager sharedManager].user.effective intValue] == 4||[[YKUserManager sharedManager].user.cardType intValue]==4)
        && [[YKUserManager sharedManager].user.isShare intValue] == 1) {
      
        _shareBtn.hidden = YES;
        _ljLabel.hidden = NO;
        _liJIan.hidden = NO;
        _inviteCodeTextField.hidden = NO;
        _liJIan.text = @"-¥150";
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
           
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥348";
                if (_newUserType==1) {
                    _total.text = @"¥348";
                }else {
                    _total.text = @"¥498";
                }
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥0";
                _total.text = @"¥299";
                if (_newUserType==1) {
                    _total.text = @"¥149";
                }else {
                    _total.text = @"¥299";
                }
            }
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            
//            _newUserType = 2;
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥856";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥0";
                _total.text = @"¥149";
            }
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
            
//            _newUserType = 2;
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3037";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥0";
                _total.text = @"¥2848";
            }
        }
    }else {
        //新用户并且未分享过,可以分享
        _ljLabel.hidden = NO;
        _liJIan.hidden = NO;
        if (([[YKUserManager sharedManager].user.effective intValue] == 4||[[YKUserManager sharedManager].user.cardType intValue]==4)
            && [[YKUserManager sharedManager].user.isShare intValue] == 0) {
//            _shareBtn.hidden = NO;
            _inviteCodeTextField.hidden = NO;
            
        }else {//不是新用户,分享按钮永不显示
            _shareBtn.hidden = YES;
            if ([[YKUserManager sharedManager].user.effective intValue] == 4){
                _inviteCodeTextField.hidden = NO;
            }
         
        }
        
        //会员用户
        _ljLabel.hidden = YES;
        _liJIan.hidden = YES;
        _liJIan.text = @"立减不可用";
        _liJIan.textColor = [UIColor colorWithHexString:@"ff6d6a"];
        
        if (_payType == MONTH_CARD) {
            _carPrice.text = @"月卡价";
          
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥498";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥299";
                _yaJin.text = @"¥199";
                _total.text = @"¥299";
            }
        }
        if (_payType == SEASON_CARD) {
            _carPrice.text = @"季卡价";
            _yuanJia.text = @"¥807";
            _yaJin.text = @"¥199";
            _total.text = @"¥1006";
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥1006";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥807";
                _yaJin.text = @"¥199";
                _total.text = @"¥807";
            }
//            _newUserType = 2;
        }
        if (_payType == YEAR_CARD) {
            _carPrice.text = @"年卡价";
          
            if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
                
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥3187";
            }else {//押金有效(只续费)
                _yuanJia.text = @"¥2988";
                _yaJin.text = @"¥199";
                _total.text = @"¥2988";
            }
//            _newUserType = 2;
        }
    }
    
    //resetUI
    [UIView animateWithDuration:0.3 animations:^{
         [self resetUI];
    }];
}

- (void)resetUI{
    //如果押金有效
    
    if ([[YKUserManager sharedManager].user.depositEffective intValue] != 1) { //押金无效(充押金并续费)
      
        _yaJin.hidden = NO;
        _yj.hidden = NO;
        
    }else {//押金有效(只续费)
        _yaJin.hidden = YES;
        _yj.hidden = YES;
    }
    
    //首次续费
    //（新用户||体验卡）&月卡(显示选择框)
    if (([[YKUserManager sharedManager].user.effective intValue] == 4 || [[YKUserManager sharedManager].user.cardType intValue] == 4) && _payType == MONTH_CARD) {
        //显示选择框
        _btn4.hidden = NO;
        _btn5.hidden = NO;
        _ljW.constant = 44;
        _zengW.constant = 44;
        _znegyi.hidden = NO;
        _zengday.hidden = NO;
        _xianshiImage.hidden = NO;
        _yjGap.constant = 60;
         _buttomH.constant = 230;
        _liJIan.hidden = NO;
        _ljLabel.hidden = NO;
        
        //未分享过
        if ([[YKUserManager sharedManager].user.isShare intValue] == 0) {
            _liJIan.text = @"分享立减¥150 >";
        }else {
            _liJIan.text = @"-¥150";
            [_liJIan setUserInteractionEnabled:NO];
        }
    }
    
    //（新用户||体验卡）& !月卡(无选择框)
    if (([[YKUserManager sharedManager].user.effective intValue] == 4 || [[YKUserManager sharedManager].user.cardType intValue] == 4) && _payType != MONTH_CARD) {
        //只显示立减
        _btn4.hidden = YES;
        _btn5.hidden = YES;
        _ljW.constant = 20;
        _zengW.constant = 20;
        _yjGap.constant = 20;
        _btn5.hidden = YES;
        _znegyi.hidden = YES;
        _xianshiImage.hidden = YES;
        _zengday.hidden = YES;
        _buttomH.constant = 190;
        _liJIan.hidden = NO;
        _ljLabel.hidden = NO;
        
        //未分享过
        if ([[YKUserManager sharedManager].user.isShare intValue] == 0) {
            _liJIan.text = @"分享立减¥150 >";
        }else {
            _liJIan.text = @"-¥150";
            [_liJIan setUserInteractionEnabled:NO];
        }
    }
    
    //老用户续费
    if (([[YKUserManager sharedManager].user.effective intValue] != 4 && [[YKUserManager sharedManager].user.cardType intValue] != 4&& [[YKUserManager sharedManager].user.cardType intValue] != 0)){
        
        if (_payType == MONTH_CARD) {//月卡
            _newUserType = 2;//买一赠一
            //显示买一赠一
            _btn4.hidden = YES;
            _btn5.hidden = YES;
            _ljLabel.hidden = YES;
            _liJIan.hidden = YES;
            _btn5.hidden = YES;
            _znegyi.hidden = NO;
            _xianshiImage.hidden = NO;
            _xianshiImageGap.constant = -24;
            _zengday.hidden = NO;
            _ljW.constant = 20;
            _zengW.constant = 20;
            _zengGap.constant = -24;
            _yjGap.constant = 12;
            _buttomH.constant = 180;
        }else {//不是月卡
            //不显示买一赠一
            _newUserType = 0;//无活动
            _btn4.hidden = YES;
            _btn5.hidden = YES;
            _ljLabel.hidden = YES;
            _liJIan.hidden = YES;
            _znegyi.hidden = YES;
            _xianshiImage.hidden = YES;
            _zengday.hidden = YES;
            _ljW.constant = 20;
            _zengW.constant = 20;
            _zengGap.constant = -24;
            _yjGap.constant = -24;
            _buttomH.constant = 150;
        }
        
    }

    
}
- (IBAction)newUserSelect:(id)sender {
    
    UIButton * button = (UIButton *)sender;
    
    if (self.Button1 != button) {
        self.Button1.selected = NO;
        button.selected = YES;
    }
    self.Button1 = button;
    
  
    switch (button.tag) {
        case 104:
            _newUserType = 1;
            _btn4.selected = self.Button1.selected;
            _btn5.selected = !self.Button1.selected;
            break;
        case 105:
            _newUserType = 2;
            _btn4.selected = !self.Button1.selected;
            _btn5.selected = self.Button1.selected;
            
            break;
        default:
            
            break;
    }
    
    if (_newUserType == 2) {//买一赠一
        _total.text = [NSString stringWithFormat:@"¥498"];
    }
    if (_newUserType == 1) {//立减
        
        if ([[YKUserManager sharedManager].user.isShare intValue] == 0) {
            _liJIan.text = @"分享立减¥150 >";
             _total.text = [NSString stringWithFormat:@"¥498"];
        }else {
            _liJIan.text = @"-¥150";
             _total.text = [NSString stringWithFormat:@"¥348"];
            [_liJIan setUserInteractionEnabled:NO];
        }
    }
}


- (void)reSetBtnUI:(UIButton *)btn{
    if (btn.tag == 1001 || btn.tag == 101) {//月卡
        _Lbtn1.backgroundColor = mainColor;
        _Lbtn2.backgroundColor = [UIColor whiteColor];
        _Lbtn3.backgroundColor = [UIColor whiteColor];
        _yueka.textColor = [UIColor whiteColor];
        _yuekaPrice.textColor = [UIColor whiteColor];
        _jika.textColor = mainColor;
        _jikaPrice.textColor = mainColor;
        _nianka.textColor = mainColor;
        _niankaPrice.textColor = mainColor;
    }
    
    if (btn.tag == 1002 || btn.tag == 102) {//季卡
        _Lbtn1.backgroundColor = [UIColor whiteColor];
        _Lbtn2.backgroundColor = mainColor;
        _Lbtn3.backgroundColor = [UIColor whiteColor];
        _yueka.textColor = mainColor;
        _yuekaPrice.textColor = mainColor;
        _jika.textColor = [UIColor whiteColor];
        _jikaPrice.textColor = [UIColor whiteColor];
        _nianka.textColor = mainColor;
        _niankaPrice.textColor = mainColor;
    }
    
    if (btn.tag == 1003 || btn.tag == 103) {//年卡
        _Lbtn1.backgroundColor = [UIColor whiteColor];
        _Lbtn2.backgroundColor = [UIColor whiteColor];
        _Lbtn3.backgroundColor = mainColor;
        _yueka.textColor = mainColor;
        _yuekaPrice.textColor = mainColor;
        _jika.textColor = mainColor;
        _jikaPrice.textColor = mainColor;
        _nianka.textColor = [UIColor whiteColor];
        _niankaPrice.textColor = [UIColor whiteColor];
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
        
        [smartHUD alertText:self.view alert:@"支付失败" delay:1.5];
        
    }else{
        
        
    }
}

//微信支付结果
-(void)wxpayresultCurrent:(NSNotification *)notify{
    
    NSDictionary *dict = [notify userInfo];
    
    if ([[dict objectForKey:@"codeid"]integerValue]==0) {
        
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
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage *image = [UIImage imageNamed:@"LOGO-1"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"快来和我一起尝试\"包月换衣\""] descr:@"衣库共享衣橱，首月149元，上万件大牌时装无限换穿！" thumImage:image];
//    [NSStringstringWithFormat:@"\"%@\"",123456];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"http://img-cdn.xykoo.cn/appHtml/invite/invite.html?id=%@", [YKUserManager sharedManager].user.userId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    
    //设置分享平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]]; // 设置需要分享的平台
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
        }];
    }];
}
- (IBAction)toShare:(id)sender {
    [self share];
}




@end
