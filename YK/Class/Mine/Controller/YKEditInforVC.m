//
//  YKEditInforVC.m
//  YK
///Users/edz/Downloads/SourceTree.app
//  Created by LXL on 2017/11/27.
//  Copyright © 2017年 YK. All rights reserved.
//
#import "YKEditInforVC.h"
#import "CustomSheetView.h"
#import "YLAwesomeData.h"
#import "YLDataConfiguration.h"
#import "YLAwesomeSheetController.h"
#import "YKChangePhoneVC.h"
#import "YKEditSizeVC.h"
#import "YKSelectColedgeVC.h"

@interface YKEditInforVC ()<UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CustomSheetViewDelegate>
{
    NSArray * ar;
}
@property(nonatomic,strong)UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hap;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UILabel *colledgeLabel;
@property (nonatomic,strong)NSString *colledgeId;


@end

@implementation YKEditInforVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    if([[UIDevice currentDevice].systemVersion floatValue] >= 11.0){
        _hap.constant = BarH;
    }else {
        _hap.constant = BarH;
    }
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
    title.font = PingFangSC_Semibold(20);
    self.navigationItem.titleView = title;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = mainColor;
    
    self.view1.tag = 101;
    self.view2.tag = 102;
    self.view3.tag = 103;
    self.view4.tag = 104;
    self.view5.tag = 105;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage)];
    [self.view1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changenickName)];
    [self.view2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhone)];
    [self.view3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSex)];
    [self.view4 addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectColedge)];
    [self.view5 addGestureRecognizer:tap5];
    
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSize)];
    [self.view6 addGestureRecognizer:tap6];
    
    [self setUI];
    
}

- (void)setUI{
    [self.headImage setContentMode:UIViewContentModeScaleAspectFit];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.frame.size.height/2;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[YKUserManager sharedManager].user.photo] placeholderImage:[UIImage imageNamed:@"touxianghuancun"]];
    self.nickNameText.delegate = self;
    
    if ([[YKUserManager sharedManager].user.nickname isEqual:[NSNull null]]) {
        self.nickNameText.text = @"未设置";
    }else {
        self.nickNameText.text = [YKUserManager sharedManager].user.nickname;
    }
    
    if ([YKUserManager sharedManager].user.phone != [NSNull null]) {
        self.phoneLabel.text = [YKUserManager sharedManager].user.phone;
    }else {
        self.phoneLabel.text = @"未绑定手机号";
    }
 
    
    NSString *str = [NSString stringWithFormat:@"%@",[YKUserManager sharedManager].user.gender];
    if ([str isEqualToString:@"1"]) {
        _sexLabel.text = @"男";
    }else {
        _sexLabel.text = @"女";
    }
    
    if ([YKUserManager sharedManager].user.colledgeName != [NSNull null]) {
        self.colledgeLabel.text = [YKUserManager sharedManager].user.colledgeName;
        self.colledgeId = [YKUserManager sharedManager].user.colledgeId;
    }else {
        self.colledgeLabel.text = @"选择院校";
    }
}
- (void)save{
    [[YKUserManager sharedManager]updateUserInforWithGender:self.sexLabel.text nickname:self.nickNameText.text photo:@"" OnResponse:^(NSDictionary *dic) {
        [self.navigationController popViewControllerAnimated:YES];
        [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
            
        }];
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nickNameText resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeImage{
    ar = @[@"相机",@"本地相册"];
    CustomSheetView *sheet = [[CustomSheetView alloc] initWithBottomBtn:1 leftPoint:1 rightTitleData:ar];
    sheet.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
}
- (void)actionSheetDidSelect:(NSInteger)index{
    if (index==72) {
        
    }else{
        if (index==0) {
            self.picker=[[UIImagePickerController alloc]init];
            self.picker.delegate=self;
            self.picker.allowsEditing=YES;
            self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
        if (index==1) {
            self.picker=[[UIImagePickerController alloc]init];
            self.picker.delegate=self;
            self.picker.allowsEditing=YES;
            self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.headImage.image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadImg:[info objectForKey:UIImagePickerControllerEditedImage]];
}

-(void)uploadImg:(UIImage *)image{
 
    NSData *data = UIImageJPEGRepresentation(image, .3);
    
    [[YKUserManager sharedManager]uploadHeadImageWithData:data OnResponse:^(NSDictionary *dic) {
//        [self setUI];
    }];
}

- (void)changenickName{
    [self.nickNameText becomeFirstResponder];
}

- (void)changePhone{

    YKChangePhoneVC *change = [[YKChangePhoneVC alloc]initWithNibName:@"YKChangePhoneVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:change animated:YES];
}

- (void)changeSex{
    NSArray *selectedData = @[@"请选择性别"];
    YLDataConfiguration *config = [[YLDataConfiguration alloc]initWithType:YLDataConfigTypeGender selectedData:selectedData];
    YLAwesomeSheetController *sheet = [[YLAwesomeSheetController alloc]initWithTitle:@""config:config callBack:^(NSString *str) {
        NSLog(@"%@",str);
        self.sexLabel.text = [NSString stringWithFormat:@"%@",str];
    }];
    [sheet showInController:self];
}

- (void)selectColedge{
    YKSelectColedgeVC *select = [[YKSelectColedgeVC alloc]init];
    select.selectColedgeBlock = ^(NSString *colledge,NSString *colledgeId){
        _colledgeLabel.text = colledge;
        _colledgeId = colledgeId;
        [[YKUserManager sharedManager]postColledgeInforColledgeId:_colledgeId OnResponse:^(NSDictionary *dic) {
            
        }];
    };
    [self presentViewController:select animated:YES completion:^{
        
    }];
}

- (void)toSize{
    YKEditSizeVC *edit = [[YKEditSizeVC alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
}

@end
