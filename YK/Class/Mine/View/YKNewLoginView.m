//
//  YKNewLoginView.m
//  YK
//
//  Created by edz on 2018/11/13.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKNewLoginView.h"
#import "YKChangePhoneVC.h"
#import "YKCodeView.h"
#import "RSAEncryptor.h"

@interface YKNewLoginView()<UITextFieldDelegate>{
    UIButton *nextBtn;
    YKCodeView *codeView;//验证码view
    UILabel *phoneLable;
    NSInteger timeNum;
    NSTimer *timer;
    NSString *vetifyCode;
    BOOL isLogining;
}
@property (nonatomic,strong)UIView *backView;//背景图层
@property (nonatomic,strong)UIView *containView;//手机号容器视图
@property (nonatomic,strong)UIView *codeContainView;//验证码容器视图
@property (nonatomic,strong)UITextField *phoneText;//输入框
@property (nonatomic,strong)UIButton *closeBtn;//关闭按钮
@property (nonatomic,strong)UIButton *qqLoginBtn;
@property (nonatomic,strong)UIButton *wxLoginBtn;
@property (nonatomic,strong)UIButton *getVetifyBtn;
@end

@implementation YKNewLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setUpUI];//输入手机号界面
        [self setUpCodeView];
    }
    return self;
}

- (void)setUpUI{
    
    //背景图层
    _backView = [[UIView alloc]initWithFrame:CGRectZero];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.74;
    _backView.frame = kWindow.bounds;
    [_backView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [_phoneText resignFirstResponder];
    }];
    [_backView addGestureRecognizer:tap];
    [self addSubview:_backView];
    
    //
    _containView = [[UIView alloc]initWithFrame:CGRectZero];
    _containView.backgroundColor = [UIColor whiteColor];
    _containView.layer.masksToBounds = YES;
    _containView.layer.cornerRadius = 4;
    [self addSubview:_containView];
    
    _containView.frame = CGRectMake(kSuitLength_H(75), HEIGHT, WIDHT-kSuitLength_H(75)*2, kSuitLength_H(148));

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [_containView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kSuitLength_H(10));
        make.right.mas_equalTo(kSuitLength_H(-10));
        make.height.width.mas_equalTo(kSuitLength_H(15));
    }];
    //
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"使用手机号码登录";
    lable.textColor = [UIColor colorWithHexString:@"666666"];
    lable.font = PingFangSC_Regular(kSuitLength_H(12));
    [_containView addSubview:lable];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(20));
        make.top.mas_equalTo(kSuitLength_H(23));
    }];
    
    //输入框
    _phoneText = [[UITextField alloc]init];
    _phoneText.placeholder = @"请输入11位手机号";
    _phoneText.textColor = mainColor;
    _phoneText.font = PingFangSC_Regular(kSuitLength_H(12));
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [_containView addSubview:_phoneText];
    
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lable.mas_bottom).offset(kSuitLength_H(10));
        make.left.mas_equalTo(kSuitLength_H(20));
        make.right.mas_equalTo(kSuitLength_H(-20));
        make.height.mas_equalTo(kSuitLength_H(30));
    }];
    
    //线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = mainColor;
    [_containView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(20));
        make.right.mas_equalTo(kSuitLength_H(-20));
        make.height.equalTo(@0.5);
        make.top.mas_equalTo(_phoneText.mas_bottom).offset(kSuitLength_H(3));
    }];
    
    UILabel *lable2 = [[UILabel alloc]init];
    lable2.text = @"使用其它方式登录：";
    lable2.textColor = [UIColor colorWithHexString:@"666666"];
    lable2.font = PingFangSC_Regular(kSuitLength_H(12));
    [_containView addSubview:lable2];
    
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(20));
        make.top.mas_equalTo(line.mas_bottom).offset(kSuitLength_H(23));
    }];
    
    _qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"qq111"] forState:UIControlStateNormal];
    [_containView addSubview:_qqLoginBtn];

    [_qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lable2.mas_centerY);
        make.left.mas_equalTo(lable2.mas_right).offset(kSuitLength_H(15));
        make.height.width.mas_equalTo(kSuitLength_H(28));
    }];

    _wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wxLoginBtn setBackgroundImage:[UIImage imageNamed:@"weixin111"] forState:UIControlStateNormal];
    [_containView addSubview:_wxLoginBtn];

    [_wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lable2.mas_centerY);
        make.right.mas_equalTo(kSuitLength_H(-23));
        make.height.width.mas_equalTo(kSuitLength_H(28));
    }];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"登陆按钮"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    
    nextBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(37)/2, _containView.bottom+kSuitLength_H(30), kSuitLength_H(37), kSuitLength_H(37));

    closeBtn.tag = 100;
    _qqLoginBtn.tag = 101;
    _wxLoginBtn.tag = 102;
    nextBtn.tag = 103;
    
    [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_qqLoginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_wxLoginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

//    if (![WXApi isWXAppInstalled]) {
//        _wxLoginBtn.hidden = YES;
//    }
//    if (![TencentOAuth iphoneQQInstalled]) {
//        _qqLoginBtn.hidden = YES;
//    }
    [_containView layoutIfNeeded];
    //动画弹出
    [self showContain];
}

//验证码view
- (void)setUpCodeView{
    _codeContainView = [[UIView alloc]initWithFrame:CGRectZero];
    _codeContainView.backgroundColor = [UIColor whiteColor];
    _codeContainView.layer.masksToBounds = YES;
    _codeContainView.layer.cornerRadius = 4;
    [self addSubview:_codeContainView];
    
    _codeContainView.frame = CGRectMake(WIDHT, kSuitLength_H(219), kSuitLength_H(236), kSuitLength_H(148));
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [_codeContainView addSubview:closeBtn];
    closeBtn.frame  =CGRectMake(kSuitLength_H(236)-kSuitLength_H(10)-kSuitLength_H(15), kSuitLength_H(8), kSuitLength_H(15), kSuitLength_H(15));
    closeBtn.tag = 100;
    [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    phoneLable = [[UILabel alloc]init];
    phoneLable.text = _phoneText.text;
    phoneLable.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    phoneLable.font = PingFangSC_Regular(kSuitLength_H(12));
    [_codeContainView addSubview:phoneLable];
    
    [phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSuitLength_H(20));
        make.top.mas_equalTo(kSuitLength_H(27));
    }];
    
    //获取验证码按钮
    _getVetifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getVetifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVetifyBtn setTitleColor:mainColor forState:UIControlStateNormal];
    _getVetifyBtn.titleLabel.font = PingFangSC_Regular(10);
    [_codeContainView addSubview:_getVetifyBtn];
    _getVetifyBtn.layer.masksToBounds = YES;
    _getVetifyBtn.layer.cornerRadius = kSuitLength_H(3);
    _getVetifyBtn.layer.borderWidth = 1;
    _getVetifyBtn.layer.borderColor = mainColor.CGColor;
    [_getVetifyBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
    _getVetifyBtn.frame = CGRectMake(kSuitLength_H(236)-kSuitLength_H(58)-kSuitLength_H(20), kSuitLength_H(27), kSuitLength_H(58), kSuitLength_H(18));


    //验证码框
    codeView = [[YKCodeView alloc] initWithFrame:CGRectMake(0, _getVetifyBtn.bottom+kSuitLength_H(15),_codeContainView.width , kSuitLength_H(38)) onFinishedEnterCode:^(NSString *code) {
        NSLog(@"%@",code);
        vetifyCode = code;
        [self loginAction];
//        if (arc4random()%2) {
//            [self reset];
//        }
    }];
    [codeView codeBecomeFirstResponder];
    [_codeContainView addSubview:codeView];

    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"右-2"] forState:UIControlStateNormal];
    [backBtn setTitle:@"重新输入手机号码" forState:UIControlStateNormal];
    backBtn.titleLabel.font = PingFangSC_Regular(kSuitLength_H(12));
    [backBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [_codeContainView addSubview:backBtn];
    
    backBtn.frame = CGRectMake(kSuitLength_H(20), codeView.bottom+kSuitLength_H(20) , kSuitLength_H(120), kSuitLength_H(20));
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
    [backBtn addTarget:self action:@selector(hideCodeView) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)reset {
    [codeView resetDefaultStatus];
}

- (void)showContain{

    [UIView animateWithDuration:0.25 animations:^{
        _containView.top = kSuitLength_H(219);
        nextBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(37)/2, _containView.bottom+kSuitLength_H(30), kSuitLength_H(37), kSuitLength_H(37));

    }completion:^(BOOL finished) {
        [_phoneText becomeFirstResponder];
    }];
   
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 100://关闭
            [self dismiss];
            
            break;
        case 101://qq登录
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TencentDidLoginNotification:) name:@"TencentDidLoginNotification" object:nil];
            
            [[YKUserManager sharedManager]loginByTencentOnResponse:^(NSDictionary *dic) {
                
            }];
            
            break;
        case 102://微信登录
            [UD setBool:NO forKey:@"bindWX"];//不是绑定,是登录
            [UD synchronize];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TencentDidLoginNotification:) name:@"TencentDidLoginNotification" object:nil];
            [[YKUserManager sharedManager]loginByWeChatOnResponse:^(NSDictionary *dic) {
                
            }];
            break;
        case 103://下一步
            [self showCodeView];
            break;
        default:
            break;
    }
}

- (void)showCodeView{
    
    if (_phoneText.text.length != 11) {
        [smartHUD alertText:kWindow alert:@"手机号有误" delay:1.3];
        return;
    }
    [_phoneText resignFirstResponder];
    phoneLable.text = _phoneText.text;
    [self reset];
    [UIView animateWithDuration:0.25 animations:^{
        _codeContainView.left = kSuitLength_H(75);
     
        _containView.left = -(WIDHT-kSuitLength_H(60)*2);
        nextBtn.centerX = _containView.centerX;
    }completion:^(BOOL finished) {
        [self getCode];
    }];
   
}

- (void)hideCodeView{
    [_phoneText becomeFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        _codeContainView.left = WIDHT;
       
        _containView.left = kSuitLength_H(75);
        nextBtn.centerX = _containView.centerX;

    }];
}

- (void)dismiss{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.4 animations:^{
        _containView.top = HEIGHT;
        _codeContainView.top = HEIGHT;
        nextBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(37)/2, _containView.bottom+kSuitLength_H(30), kSuitLength_H(37), kSuitLength_H(37));

    }completion:^(BOOL finished) {
        [_phoneText resignFirstResponder];
        [self removeFromSuperview];
    }];
}

//接收qq登录成功的通知
- (void)TencentDidLoginNotification:(NSNotification *)notify{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:notify.userInfo];
    [[YKUserManager sharedManager]loginSuccessByTencentDic:dic[@"code"] OnResponse:^(NSDictionary *dic) {
        
        [UIView animateWithDuration:0. animations:^{
            [self dismiss];
        }completion:^(BOOL finished) {
            if ([[YKUserManager sharedManager].user.phone isEqual:[NSNull null]]) {
                YKChangePhoneVC *changePhone = [YKChangePhoneVC new];
                changePhone.isFromThirdLogin = YES;
                changePhone.hidesBottomBarWhenPushed = YES;
                [[self getCurrentVC].navigationController pushViewController:changePhone animated:YES];
            }else {
                if (self.loginSuccess) {
                    self.loginSuccess();
                }
            }
        }];
    }];
}

//接收微信登录的通知
- (void)wechatDidLoginNotification:(NSNotification *)notify{
    NSDictionary *dict = [notify userInfo];
    if (isLogining) {
        return;
    }
    isLogining = YES;
    [[YKUserManager sharedManager]getWechatAccessTokenWithCode:dict[@"code"] OnResponse:^(NSDictionary *dic) {
        isLogining = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4 animations:^{
//                    [self dismiss];
                }completion:^(BOOL finished) {
                    if ([[YKUserManager sharedManager].user.phone isEqual:[NSNull null]]) {
                        YKChangePhoneVC *changePhone = [YKChangePhoneVC new];
                        changePhone.isFromThirdLogin = YES;
                        changePhone.hidesBottomBarWhenPushed = YES;
                        [[self getCurrentVC].navigationController pushViewController:changePhone animated:YES];
                    }else {
                        if (self.loginSuccess) {
                            self.loginSuccess();
                        }
                    }
                }];
                
            });
            
        });
    }];
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


- (void)getCode{
    if (self.phoneText.text.length == 0 || self.phoneText.text.length != 11) {
        [smartHUD alertText:kWindow alert:@"手机号错误" delay:1];
        return;
    }
 
    //请求验证码接口,成功后
    
    [[YKUserManager sharedManager]getVetifyCodeWithPhone:[self getRSAStr:self.phoneText.text]  OnResponse:^(NSDictionary *dic) {
        [self timeOrder];
        
    }];
}

-(void)timeOrder{
    
    timeNum = 60;
    self.getVetifyBtn.userInteractionEnabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countNum) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}
//倒计时
-(void)countNum{
    
    if (timeNum == 0) {
        self.getVetifyBtn.userInteractionEnabled = YES;
        [timer invalidate];
        [self.getVetifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.getVetifyBtn setTitleColor:mainColor forState:UIControlStateNormal];
        
    }else{
        
        timeNum--;
        self.getVetifyBtn.userInteractionEnabled = NO;
        [self.getVetifyBtn setTitle:[NSString stringWithFormat:@"%lds",(long)timeNum] forState:UIControlStateNormal];
        [self.getVetifyBtn setTitleColor:[UIColor colorWithHexString:@"afafaf"] forState:UIControlStateNormal   ];
    }
}

- (void)loginAction{
    
    if (self.phoneText.text.length == 0 || self.phoneText.text.length != 11) {
        [smartHUD alertText:kWindow alert:@"手机号错误" delay:1];
        return;
    }else {
        
    }
  
    //手机号登录
    [[YKUserManager sharedManager]LoginWithPhone:self.phoneText.text VetifyCode:vetifyCode OnResponse:^(NSDictionary *dic) {
        [self dismiss];
        if (self.loginSuccess) {
            self.loginSuccess();
        }
    }];
}

- (NSString *)getRSAStr:(NSString *)str{
    
    //使用字符串格式的公钥私钥加密解密
    NSString *encryptStr = [RSAEncryptor encryptString:str publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCBC5T7S0hhZKF7ri5xV3R0ebGyeXT8fZIgxSbIAI+7MVwxfnL+qOYYqnX3V6BJDw87OEnGcFV2DLcqahUb691XnvS6FQI8kAlL9Xcc5NLKJmxD3GOlxlFpobCNHcCUiyf1TdVOUoSh9Dh2NK1UOiY2YdzllkEAH88Ji03xzvv4XwIDAQAB"];
    
    return encryptStr;
}

@end
