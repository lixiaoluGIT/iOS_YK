//
//  YKChangePhoneVC.m
//  YK
//
//  Created by LXL on 2017/11/27.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKChangePhoneVC.h"

@interface YKChangePhoneVC ()
{
    NSTimer *timer;
}
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
    self.title = @"修改手机号";
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
    title.font = PingFangSC_Regular(17);
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
        [self.getVetifyBtn setTitleColor:[UIColor colorWithHexString:@"ff6d6a"] forState:UIControlStateNormal];
        self.getVetifyBtn.userInteractionEnabled = YES;
    }else {
        self.getVetifyBtn.userInteractionEnabled = NO;
        [self.getVetifyBtn setTitleColor:[UIColor colorWithHexString:@"afafaf"] forState:UIControlStateNormal];
    }
    if (self.phoneText.text.length>10&&self.vetifyText.text.length>0) {
        self.ensureBtn.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
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
    [[YKUserManager sharedManager]changePhoneGetVetifyCodeWithPhone:self.phoneText.text OnResponse:^(NSDictionary *dic) {
        [self timeOrder];
    }];
}
-(void)timeOrder{
    
    timeCount = 30;
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
        [self.getVetifyBtn setTitleColor:[UIColor colorWithHexString:@"ff6d6a"] forState:UIControlStateNormal];
        
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
    
    [[YKUserManager sharedManager]changePhoneWithPhone:self.phoneText.text VetifyCode:self.vetifyText.text OnResponse:^(NSDictionary *dic) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
