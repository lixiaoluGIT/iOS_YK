//
//  YKEditSizeVC.m
//  YK
//
//  Created by edz on 2018/5/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKEditSizeVC.h"

@interface YKEditSizeVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *xiongweiText;
@property (weak, nonatomic) IBOutlet UITextField *yaoweiText;
@property (weak, nonatomic) IBOutlet UITextField *tunweiText;
@property (weak, nonatomic) IBOutlet UITextField *jiankuanText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end

@implementation YKEditSizeVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [[YKUserManager sharedManager]getUserSizeOnResponse:^(NSDictionary *dic) {
        _mySizeArray = [NSMutableArray array];
        
//        if ([dic[@"data"] isEqualToString:@"没有尺码表"]) {
//            [_mySizeArray addObject:@""];//肩宽
//            [_mySizeArray addObject:@""];//胸围
//            [_mySizeArray addObject:@""];//腰围
//            [_mySizeArray addObject:@""];//臀围
//        }else {
////            NSDictionary *Dic = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
//            [_mySizeArray addObject:dic[@"data"][@"shoulderWidth"]];//肩宽
//            [_mySizeArray addObject:dic[@"data"][@"bust"]];//胸围
//            [_mySizeArray addObject:dic[@"data"][@"hipline"]];//腰围
//            [_mySizeArray addObject:dic[@"data"][@"theWaist"]];//臀围
//        }
        NSDictionary *Dic = [NSDictionary dictionaryWithDictionary:dic[@"data"]];

        if (Dic.allKeys>0) {//data
            [_mySizeArray addObject:dic[@"data"][@"shoulderWidth"]];//肩宽
            [_mySizeArray addObject:dic[@"data"][@"bust"]];//胸围
            [_mySizeArray addObject:dic[@"data"][@"hipline"]];//腰围
            [_mySizeArray addObject:dic[@"data"][@"theWaist"]];//臀围
        }else {
            [_mySizeArray addObject:@""];//肩宽
            [_mySizeArray addObject:@""];//胸围
            [_mySizeArray addObject:@""];//腰围
            [_mySizeArray addObject:@""];//臀围
        }
        
        _xiongweiText.text = ![_mySizeArray[0] isEqual:[NSNull null]]? [NSString stringWithFormat:@"%@",_mySizeArray[0]] : @"";//肩宽
        _yaoweiText.text = ![_mySizeArray[1] isEqual:[NSNull null]]? [NSString stringWithFormat:@"%@",_mySizeArray[1]] : @"";//胸围
        _tunweiText.text = ![_mySizeArray[2] isEqual:[NSNull null]]? [NSString stringWithFormat:@"%@",_mySizeArray[2]] : @"";//腰围
        _jiankuanText.text = ![_mySizeArray[3] isEqual:[NSNull null]]? [NSString stringWithFormat:@"%@",_mySizeArray[3]] : @"";//臀围
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑尺码";
    
    [_mySizeArray addObject:@""];//肩宽
    [_mySizeArray addObject:@""];//胸围
    [_mySizeArray addObject:@""];//腰围
    [_mySizeArray addObject:@""];//臀围
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 11.0){
        _height.constant = BarH+15;
    }else {
        _height.constant = BarH+15;
    }
    _xiongweiText.delegate = self;
    _yaoweiText.delegate = self;
    _tunweiText.delegate = self;
    _jiankuanText.delegate = self;
    
    _xiongweiText.keyboardType = UIKeyboardTypeNumberPad;
    _yaoweiText.keyboardType = UIKeyboardTypeNumberPad;
    _tunweiText.keyboardType = UIKeyboardTypeNumberPad;
    _jiankuanText.keyboardType = UIKeyboardTypeNumberPad;

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
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = mainColor;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Medium(kSuitLength_H(14));
    self.navigationItem.titleView = title;
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save{
    [[YKUserManager sharedManager]addbust:_yaoweiText.text hipline:_tunweiText.text shoulderWidth:_xiongweiText.text theWaist:_jiankuanText.text OnResponse:^(NSDictionary *dic) {
        //让上个页面中的尺码刷新
        [UD setBool:YES forKey:@"hadNewSize"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_xiongweiText resignFirstResponder];
     [_yaoweiText resignFirstResponder];
     [_tunweiText resignFirstResponder];
     [_jiankuanText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
