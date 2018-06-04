//
//  YKRegisterVC.m
//  YK
//
//  Created by edz on 2018/5/31.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKRegisterVC.h"
#import "RSAEncryptor.h"

@interface YKRegisterVC ()
<UITextFieldDelegate>{
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *vetifyCodeText;
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;
@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end
NSInteger timeNum;
@implementation YKRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.getCode.layer.masksToBounds = YES;
    self.getCode.layer.cornerRadius  = 5;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.vetifyCodeText.keyboardType = UIKeyboardTypeNumberPad;
    self.inviteCode.keyboardType = UIKeyboardTypeDefault;
    self.phoneText.inputAccessoryView = [self addToolbar];
    self.vetifyCodeText.inputAccessoryView = [self addToolbar];
//    self.inviteCode.inputAccessoryView = [self addToolbar];
    [self.vetifyCodeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.inviteCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.getCode.userInteractionEnabled = NO;
}

- (void) textFieldDidChange:(id) sender {
    if (self.phoneText.text.length>10) {
        [self.getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.getCode.userInteractionEnabled = YES;
        self.getCode.backgroundColor = mainColor;
    }else {
        self.getCode.userInteractionEnabled = NO;
        [self.getCode setTitleColor:[UIColor colorWithHexString:@"afafaf"] forState:UIControlStateNormal];
        self.getCode.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    }
    if (self.phoneText.text.length>10&&self.vetifyCodeText.text.length>0) {
        self.registerBtn.backgroundColor = mainColor;
        [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        self.registerBtn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        [self.registerBtn setTitleColor:[UIColor colorWithHexString:@"afafaf"] forState:UIControlStateNormal];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.vetifyCodeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.inviteCode resignFirstResponder];
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)register:(id)sender {
    
}
- (IBAction)getVetifyCode:(id)sender {
    if (![steyHelper isValidatePhone:self.phoneText.text] ) {
        [smartHUD alertText:self.view alert:@"手机号错误" delay:1];
        return;
    }
    //请求验证码接口,成功后
    
    [[YKUserManager sharedManager]getVetifyCodeWithPhone:[self getRSAStr:self.phoneText.text]  OnResponse:^(NSDictionary *dic) {
        [self timeOrder];
        
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDone{
    [self.vetifyCodeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.inviteCode resignFirstResponder];
}
- (void)cancel{
    [self.vetifyCodeText resignFirstResponder];
    [self.phoneText resignFirstResponder];
    [self.inviteCode resignFirstResponder];
}
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.frame), 40)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    toolbar.items = @[cancel,space, bar];
    return toolbar;
}

-(void)timeOrder{
    
    timeNum = 60;
    self.getCode.userInteractionEnabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countNum) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}
//倒计时
-(void)countNum{
    
    if (timeNum == 0) {
        self.getCode.userInteractionEnabled = YES;
        [timer invalidate];
        [self.getCode setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.getCode setTitleColor:mainColor forState:UIControlStateNormal];
        
    }else{
        
        timeNum--;
        self.getCode.userInteractionEnabled = NO;
        [self.getCode setTitle:[NSString stringWithFormat:@"%lds",(long)timeNum] forState:UIControlStateNormal];
        [self.getCode setTitleColor:[UIColor colorWithHexString:@"afafaf"] forState:UIControlStateNormal   ];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)login:(id)sender {
    
    if (self.phoneText.text.length == 0) {
        [smartHUD alertText:self.view alert:@"手机号错误" delay:1];
        return;
    }else {
        if (![steyHelper isValidatePhone:self.phoneText.text] ) {
            [smartHUD alertText:self.view alert:@"手机号错误" delay:1];
            return;
        }
    }
    if (self.vetifyCodeText.text.length == 0) {
        [smartHUD alertText:self.view alert:@"验证码不能为空" delay:1];
        return;
    }
    [[YKUserManager sharedManager] RegisterWithPhone:self.phoneText.text VetifyCode:self.vetifyCodeText.text InviteCode:self.inviteCode.text OnResponse:^(NSDictionary *dic) {
        [self dismissViewControllerAnimated:YES completion:^{
            
                    }];
    }];
    
//    [[YKUserManager sharedManager]LoginWithPhone:self.phoneText.text VetifyCode:self.vetifyCodeText.text OnResponse:^(NSDictionary *dic) {
//
//        [self dismissViewControllerAnimated:YES completion:^{
//
//        }];
//    }];
}

- (NSString *)getRSAStr:(NSString *)str{
    
    //使用字符串格式的公钥私钥加密解密
    NSString *encryptStr = [RSAEncryptor encryptString:str publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCBC5T7S0hhZKF7ri5xV3R0ebGyeXT8fZIgxSbIAI+7MVwxfnL+qOYYqnX3V6BJDw87OEnGcFV2DLcqahUb691XnvS6FQI8kAlL9Xcc5NLKJmxD3GOlxlFpobCNHcCUiyf1TdVOUoSh9Dh2NK1UOiY2YdzllkEAH88Ji03xzvv4XwIDAQAB"];
    
    return encryptStr;
}


@end
