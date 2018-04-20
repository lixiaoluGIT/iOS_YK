//
//  YKChangePhoneVC.m
//  YK
//
//  Created by LXL on 2017/11/27.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKChangePhoneVC.h"
#import "YKLoginVC.h"
#import "RSAEncryptor.h"

@interface YKChangePhoneVC ()
{
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *vetifyText;

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UIButton *getVetifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

NSInteger timeCount;
@implementation YKChangePhoneVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isFromThirdLogin) {
        self.title = @"绑定手机号";
    }else {
        self.title = @"修改手机号";
    }
    if (HEIGHT==812) {
        _gap.constant = 110;
    }
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue]  < 11) {
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
    title.font = PingFangSC_Semibold(20);
    self.navigationItem.titleView = title;

    if ([YKUserManager sharedManager].user.phone!=[NSNull null]) {
        self.phoneLabel.text = [YKUserManager sharedManager].user.phone;
    }else {
        self.phoneLabel.text = @"未绑定手机号";
    }
    self.ensureBtn.layer.masksToBounds = YES;
    self.ensureBtn.layer.cornerRadius = self.ensureBtn.frame.size.height/2;
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.vetifyText.keyboardType = UIKeyboardTypeNumberPad;

    [self.vetifyText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.getVetifyBtn.userInteractionEnabled = NO;
}
- (void) textFieldDidChange:(id) sender {
    if (self.phoneText.text.length>10) {
        [self.getVetifyBtn setTitleColor:mainColor forState:UIControlStateNormal];
        self.getVetifyBtn.userInteractionEnabled = YES;
    }else {
        self.getVetifyBtn.userInteractionEnabled = NO;
        [self.getVetifyBtn setTitleColor:[UIColor colorWithHexString:@"afafaf"] forState:UIControlStateNormal];
    }
    if (self.phoneText.text.length>10&&self.vetifyText.text.length>0) {
        self.ensureBtn.backgroundColor = mainColor;
        [self.ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        self.ensureBtn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self.ensureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.vetifyText resignFirstResponder];
    [self.phoneText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDone{
    [self.vetifyText resignFirstResponder];
    [self.phoneText resignFirstResponder];
}
//获取验证码
- (IBAction)getCode:(id)sender {
    //请求验证码接口,成功后
    
    if (self.isFromThirdLogin) {
        [[YKUserManager sharedManager]getVetifyCodeWithPhone:[self getRSAStr:self.phoneText.text] OnResponse:^(NSDictionary *dic) {
            [self timeOrder];
        }];
    }else {
        [[YKUserManager sharedManager]changePhoneGetVetifyCodeWithPhone:[self getRSAStr:self.phoneText.text] OnResponse:^(NSDictionary *dic) {
            [self timeOrder];
        }];
    }
  
}

- (NSString *)getRSAStr:(NSString *)str{
    
    //使用字符串格式的公钥私钥加密解密
    NSString *encryptStr = [RSAEncryptor encryptString:str publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCBC5T7S0hhZKF7ri5xV3R0ebGyeXT8fZIgxSbIAI+7MVwxfnL+qOYYqnX3V6BJDw87OEnGcFV2DLcqahUb691XnvS6FQI8kAlL9Xcc5NLKJmxD3GOlxlFpobCNHcCUiyf1TdVOUoSh9Dh2NK1UOiY2YdzllkEAH88Ji03xzvv4XwIDAQAB"];
    
    
    NSLog(@"解密后:%@", [RSAEncryptor decryptString:encryptStr privateKey:@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAIELlPtLSGFkoXuuLnFXdHR5sbJ5dPx9kiDFJsgAj7sxXDF+cv6o5hiqdfdXoEkPDzs4ScZwVXYMtypqFRvr3Vee9LoVAjyQCUv1dxzk0sombEPcY6XGUWmhsI0dwJSLJ/VN1U5ShKH0OHY0rVQ6JjZh3OWWQQAfzwmLTfHO+/hfAgMBAAECgYAsrfjoRPmLlw7+RqGX5qLQjS4EUF876LJGnFxAFUmuk3mLPW/NUmdQlPyBJhq+EPPCGkwY494DIIXurooef7zDz7jeFwFTiyAzU3GLOkGuWOSmnNkCrT5lW93fQXeEZtKufdaZaex957I0ldG/YyjDDZkOprvXsf8WtAb5CzOVYQJBAOKtAR8rPv0WJgzKbTcoSYgaBCEC8tCOf8Y33NkAsqfXH5VMNVHi6WRmROcXch4wC48zu+E+fiq78L0zZJeZz/ECQQCRvUWXikRF8/dxO8HPkcm7C5hnI6VuFUm0zi6lUJY8/thPUYrPN7SzhB4w6gWo7bbz36+geJGp56/nWGBP3p1PAkBdEWNQhNUL3LgqsEI/T09Bjkz7sNY5Qwi7PdxzTJINz4msJuoNgPkKu+K2by3vrxJP7ZHKXXo32YpyZFN82y5BAkBgmKD9tklWTEPfq4nkOG8LKL5U7k2Bz15RFq/YJrfNqeRZfmSQwA1nRtRz+0jRFO5EaiiQJhn2EXiH0A3WImkFAkEAwhO00lkrGHyjgitXiyYUqkWGqFLkWc1pVHg3ZTCuTBXIbbbs8YpcntXIGq/0D2rXGSY3AS8/X/LcPF38Lrtc1g=="]);
    
    return encryptStr;
}

-(void)timeOrder{
    
    timeCount = 60;
    self.getVetifyBtn.userInteractionEnabled = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countNum) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}
//倒计时
-(void)countNum{
    
    if (timeCount == 0) {
        self.getVetifyBtn.userInteractionEnabled = YES;
        [timer invalidate];
        [self.getVetifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.getVetifyBtn setTitleColor:mainColor forState:UIControlStateNormal];
        
    }else{
        
        timeCount--;
        self.getVetifyBtn.userInteractionEnabled = NO;
        [self.getVetifyBtn setTitle:[NSString stringWithFormat:@"%lds",(long)timeCount] forState:UIControlStateNormal];
        [self.getVetifyBtn setTitleColor:[UIColor colorWithHexString:@"dddddd"] forState:UIControlStateNormal];
    }
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//确认修改
- (IBAction)login:(id)sender {
    
    if (self.phoneText.text.length!=11) {
        [smartHUD alertText:self.view alert:@"手机号不正确" delay:1];
        return;
    }
    if (self.vetifyText.text.length==0) {
        [smartHUD alertText:self.view alert:@"验证码不能为空" delay:1];
        return;
    }
    NSInteger status;
    if (self.isFromThirdLogin) {
        //绑定手机号
        status = 0;
        
    }else {
        //修改手机号
        status = 1;
    }
    
    [[YKUserManager sharedManager]changePhoneWithPhone:self.phoneText.text VetifyCode:self.vetifyText.text status:status OnResponse:^(NSDictionary *dic) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)leftAction{
    if (self.isFromThirdLogin) {
        [[YKUserManager sharedManager]exitLoginWithPhone:@"" VetifyCode:@"" OnResponse:^(NSDictionary *dic) {
          
            
            YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
            [self presentViewController:login animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
