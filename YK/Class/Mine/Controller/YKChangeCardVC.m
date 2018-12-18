//
//  YKChangeCardVC.m
//  YK
//
//  Created by edz on 2018/12/18.
//  Copyright © 2018年 YK. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 200
#import "YKChangeCardVC.h"
#import "YKWalletButtom.h"
#import "YKDepositVC.h"
#import "YKLinkWebVC.h"

@interface YKChangeCardVC ()<UITextFieldDelegate>
{
    BOOL up;
    YKWalletButtom *buttom;
}
@property (nonatomic,strong)UITextField *t1;
@property (nonatomic,strong)UITextField *t2;
@end

@implementation YKChangeCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.title = @"激活兑换卡";
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
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Medium(kSuitLength_H(14));;
    self.navigationItem.titleView = title;
    
    [self setUpUI];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpUI{
    
    UIScrollView *bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];
    bigScrollView.contentSize = CGSizeMake(0, HEIGHT);
    bigScrollView.scrollEnabled = YES;
    [self.view addSubview:bigScrollView];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"月卡111"]];
    image.frame = CGRectMake(kSuitLength_H(57), kSuitLength_H(20), WIDHT-kSuitLength_H(57)*2, kSuitLength_H(138));
//    image.centerX = bigScrollView.centerX;
//    image.top = bigScrollView.top+kSuitLength_H(20);
//    [image sizeToFit];
    [bigScrollView addSubview:image];
    
    //服务内容view
    UIView *serviceView = [[UIView alloc]initWithFrame:CGRectMake(0, image.bottom - kSuitLength_H(20), WIDHT, kSuitLength_H(132))];
    serviceView.backgroundColor = [UIColor whiteColor];
    [bigScrollView addSubview:serviceView];
    
    //服务内容
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, kSuitLength_H(20), WIDHT, kSuitLength_H(20))];
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
    UILabel *l3 = [[UILabel alloc]initWithFrame:CGRectMake(kSuitLength_H(47), l2.bottom+kSuitLength_H(14), kSuitLength_H(8), kSuitLength_H(8))];
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
    cardDes.text = @"月卡可享受衣库30天内提供的无限换衣特权";
    cardDes.textColor = [UIColor colorWithHexString:@"1f1f1f"];;
    cardDes.font = PingFangSC_Regular(kSuitLength_H(12));
    cardDes.textAlignment = NSTextAlignmentLeft;
   [serviceView addSubview:cardDes];
    
    //负责描述
    UILabel *Des = [[UILabel alloc]initWithFrame:CGRectMake(l4.right+kSuitLength_H(9),cardDes.bottom+kSuitLength_H(8) , WIDHT, kSuitLength_H(20))];
    Des.centerY = l4.centerY;
    Des.text = @"衣库负责服装的往返包邮，专业清洗，消毒，除菌";
    Des.textColor = [UIColor colorWithHexString:@"1f1f1f"];;
    Des.font = PingFangSC_Regular(kSuitLength_H(12));
    Des.textAlignment = NSTextAlignmentLeft;
    [serviceView addSubview:Des];
    
    //输入兑换码view
    UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(kSuitLength_H(35), serviceView.bottom, WIDHT-kSuitLength_H(35)*2, kSuitLength_H(161))];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.masksToBounds = YES;
    inputView.layer.cornerRadius = 4;
    [bigScrollView addSubview:inputView];
    
    //设置阴影
    inputView.layer.shadowColor = [UIColor colorWithHexString:@"ABA9A9"].CGColor;
    inputView.layer.shadowOpacity = 0.5f;
    inputView.layer.shadowRadius = 4.f;
    inputView.layer.shadowOffset = CGSizeMake(2,2);
    
    UILabel *de = [[UILabel alloc]initWithFrame:CGRectMake(0, kSuitLength_H(16),inputView.frame.size.width ,kSuitLength_H(20))];
    de.text = @"使用兑换码兑换月卡会员";
    de.textColor = mainColor;
    de.font = PingFangSC_Regular(kSuitLength_H(14));
    de.textAlignment = NSTextAlignmentCenter;
    [inputView addSubview:de];
    
    UITextField *cardNum = [[UITextField alloc]init];
    cardNum.frame = CGRectMake(kSuitLength_H(53), de.bottom + kSuitLength_H(11), de.frame.size.width-kSuitLength_H(53)*2, kSuitLength_H(34));
    cardNum.placeholder = @"输入兑换卡号";
//    [inputView addSubview:cardNum];
    
    UITextField *codeNum = [[UITextField alloc]init];
    codeNum.frame = CGRectMake(kSuitLength_H(53), de.bottom + kSuitLength_H(17), de.frame.size.width-kSuitLength_H(53)*2, kSuitLength_H(34));
    codeNum.placeholder = @"输入兑换码";
    [inputView addSubview:codeNum];
    codeNum.returnKeyType = UIReturnKeyDone;
    
//    codeNum.borderStyle = UITextBorderStyleLine;
//    cardNum.borderStyle = UITextBorderStyleLine;
    cardNum.layer.borderWidth = 0.5;
    codeNum.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    codeNum.layer.borderWidth = 0.5;
    cardNum.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    codeNum.textAlignment =NSTextAlignmentCenter;
    cardNum.textAlignment =NSTextAlignmentCenter;
    cardNum.clearButtonMode = UITextFieldViewModeAlways;
    codeNum.clearButtonMode = UITextFieldViewModeAlways;
    codeNum.textColor = mainColor;
    cardNum.textColor = mainColor;
    cardNum.font = PingFangSC_Regular(kSuitLength_H(12));
    codeNum.font = PingFangSC_Regular(kSuitLength_H(12));
    codeNum.delegate = self;
    cardNum.delegate = self;
    cardNum.keyboardType = UIKeyboardTypeDefault;
    codeNum.keyboardType = UIKeyboardTypeDefault;
    [codeNum setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [cardNum setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [cardNum setValue:[UIFont systemFontOfSize:kSuitLength_H(12)] forKeyPath:@"_placeholderLabel.font"];
    [codeNum setValue:[UIFont systemFontOfSize:kSuitLength_H(12)] forKeyPath:@"_placeholderLabel.font"];
    self.t1 = cardNum;
    self.t2 = codeNum;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kSuitLength_H(72), codeNum.bottom + kSuitLength_H(20),inputView.frame.size.width-kSuitLength_H(72)*2 ,kSuitLength_H(40) );
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = kSuitLength_H(40)/2;
    [btn setTitle:@"确认兑换" forState:UIControlStateNormal];
    btn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = YKRedColor;
    [inputView addSubview:btn];
    
    UIImageView *ima = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tishi"]];
    ima.frame = CGRectMake(kSuitLength_H(26), inputView.bottom + kSuitLength_H(40), kSuitLength_H(16), kSuitLength_H(16));
    [bigScrollView addSubview:ima];
    
    UILabel *xieyi = [[UILabel alloc]init];
    xieyi.frame = CGRectMake(ima.right + kSuitLength_H(8),ima.top ,WIDHT-kSuitLength_H(40) ,kSuitLength_H(16));
    [bigScrollView addSubview:xieyi];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"本服务不支持退款，购买即视为同意充值说明和押金说明"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-4,4)]; //设置字体颜色
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4a90e2"] range:NSMakeRange(str.length-9,4)]; //设置字体颜色
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:12.0] range:NSMakeRange(0, 5)]; //设置字体字号和字体类别
    xieyi.font = PingFangSC_Regular(kSuitLength_H(12));
    xieyi.textColor = mainColor;
    xieyi.attributedText = str;
    
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    b1.frame = CGRectMake(WIDHT-kSuitLength_H(76), inputView.bottom+ kSuitLength_H(40), kSuitLength_H(53), kSuitLength_H(30));
    [b1 addTarget:self action:@selector(yajinshuoming) forControlEvents:UIControlEventTouchUpInside];
    [bigScrollView addSubview:b1];
    
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    b2.frame = CGRectMake(WIDHT-kSuitLength_H(76)-kSuitLength_H(58), inputView.bottom+ kSuitLength_H(40), kSuitLength_H(53), kSuitLength_H(30));
    [b2 addTarget:self action:@selector(chongzhishuoming) forControlEvents:UIControlEventTouchUpInside];
    [bigScrollView addSubview:b2];
    
//    b1.backgroundColor = [UIColor redColor];
//    b2.backgroundColor = [UIColor yellowColor];
    
    WeakSelf(weakSelf)
    //押金状态
    buttom = [[NSBundle mainBundle] loadNibNamed:@"YKWalletButtom" owner:self options:nil][0];
    buttom.selectionStyle = UITableViewCellSelectionStyleNone;
    buttom.frame = CGRectMake(0, xieyi.bottom+kSuitLength_H(60), WIDHT, kSuitLength_H(60));
    if (HEIGHT==812) {
        buttom.frame = CGRectMake(0, HEIGHT-180, WIDHT, BarH);
    }
    if ([[YKUserManager sharedManager].user.depositEffective intValue] ==0 || [[YKUserManager sharedManager].user.depositEffective intValue]==3) {//未交押金或押金无效
        [buttom setTit];
    }
    
    [buttom setTitle:[[YKUserManager sharedManager].user.depositEffective intValue]];
    buttom.scanBlock = ^(NSInteger tag){
        YKDepositVC *deposit = [[YKDepositVC alloc]initWithNibName:@"YKDepositVC" bundle:[NSBundle mainBundle]];
        deposit.validityStatus = [[YKUserManager sharedManager].user.depositEffective intValue];
        [weakSelf.navigationController pushViewController:deposit animated:YES];
    };
    [bigScrollView addSubview:buttom];
}

- (void)chongzhishuoming{
    YKLinkWebVC *web =[YKLinkWebVC new];
    //        web.needShare = YES;
    web.url = @" http://img-cdn.xykoo.cn/appHtml/recharge.html";
    if (web.url.length == 0) {
        return;
    }
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}


- (void)yajinshuoming{
    YKLinkWebVC *web =[YKLinkWebVC new];
    //        web.needShare = YES;
    web.url = @"http://img-cdn.xykoo.cn/appHtml/deposit.html";
    if (web.url.length == 0) {
        return;
    }
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.t1 resignFirstResponder];
    [self.t2 resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.t1 resignFirstResponder];
    [self.t2 resignFirstResponder];
    
     [self setViewMovedUp:NO];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
//    [self setViewMovedUp:YES];
    if ([sender isEqual:self.t1]  )
    {
        [self.t1 becomeFirstResponder];
        [self.t2 resignFirstResponder];
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    if ([sender isEqual:self.t2])
    {
        [self.t2 becomeFirstResponder];
        [self.t1 resignFirstResponder];
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        if (up) {
            NSLog(@"已上");
            return;
        }
        NSLog(@"上去");
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
         up = YES;
    }
    else
    {
        if (!up) {
             NSLog(@"已上");
            return;
        }
        NSLog(@"下来");
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        up = NO;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
//    if ([self.t1 isFirstResponder] && self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//        return;
//    }
//     if (![self.t1 isFirstResponder] && self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//        return;
//    }
//
//    if ([self.t2 isFirstResponder] && self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//        return;
//    }
//     if (![self.t2 isFirstResponder] && self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//        return;
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - -- 方法

#pragma mark 自动4个字符空一格
- (BOOL)autoSpace:(UITextField *)textField andRang:(NSRange)range andString:(NSString *)string {
    
    NSInteger row = textField.text.length - 1;
    
    // 退格（删除）
    if (range.length == 1 && range.location == textField.text.length - 1) {
        
        if (row % 5 == 0) {
            
            textField.text = [textField.text substringToIndex:row];
        }
    }
    else {
       
        // 只能输入数字、字母
        NSString *regex = @"[a-z0-9A-Z]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![pred evaluateWithObject:string]) {
            
            return NO;
        }
        
        if (textField.text.length>=14) {
            return NO;
        }
        
        if (row % 5 == 2) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (textField.text.length<=13) {
                    textField.text = [NSString stringWithFormat:@"%@-", textField.text];
                }
                
            });
        }
    }
    
    return YES;
}


#pragma mark - -- 响应




#pragma mark - -- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self autoSpace:textField andRang:range andString:string];
}
@end
