//
//  YKSuccessVC.m
//  YK
//
//  Created by LXL on 2017/11/20.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuccessVC.h"
#import "YKMineVC.h"
#import "YKHomeVC.h"
#import "YKMySuitBagVC.h"
#import "YKShareVC.h"

@interface YKSuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *scan;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *p1;
@property (weak, nonatomic) IBOutlet UILabel *p1size;

@property (weak, nonatomic) IBOutlet UILabel *p1price;

@property (weak, nonatomic) IBOutlet UILabel *p2;
@property (weak, nonatomic) IBOutlet UILabel *p2size;
@property (weak, nonatomic) IBOutlet UILabel *p2price;

@property (weak, nonatomic) IBOutlet UILabel *p3;
@property (weak, nonatomic) IBOutlet UILabel *p3size;
@property (weak, nonatomic) IBOutlet UILabel *p3price;

@property (weak, nonatomic) IBOutlet UILabel *p4;
@property (weak, nonatomic) IBOutlet UILabel *p4size;
@property (weak, nonatomic) IBOutlet UILabel *p4price;


@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *inviteImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap;

@end

@implementation YKSuccessVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单成功";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    self.navigationController.navigationBar.hidden = YES;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Semibold(20);
    
    self.navigationItem.titleView = title;
    
    self.scan.layer.masksToBounds = YES;
    self.scan.layer.cornerRadius = 18;
    self.returnBtn.layer.masksToBounds = YES;
    self.returnBtn.layer.cornerRadius = 18;
    
    _p1.text = @"12asdabdasdbaskjbdias";
    //布局写死了，todo：优化
    if (_pList.count==1) {
        YKSuit *suit1 = _pList[0];
        _p1.text = suit1.clothingName;
        _p1size.text = suit1.clothingStockType;
        _p1price.text = [NSString stringWithFormat:@"¥%@",suit1.clothingPrice];
        
//        YKSuit *suit2 = _pList[1];
        _p2.text = @"";
        _p2size.text = @"";
        _p2price.text = @"";
        
        
//        YKSuit *suit3 = _pList[2];
        _p3.text = @"";
        _p3size.text = @"";
        _p3price.text = @"";
        
        
//        YKSuit *suit4 = _pList[3];
        _p4.text = @"";
        _p4size.text = @"";
        _p4price.text = @"";

        _gap.constant = 30;
    }
    
    if (_pList.count==2) {
        YKSuit *suit1 = _pList[0];
        _p1.text = suit1.clothingName;
        _p1size.text = suit1.clothingStockType;
        _p1price.text = [NSString stringWithFormat:@"¥%@",suit1.clothingPrice];
        
        YKSuit *suit2 = _pList[1];
        _p2.text = suit2.clothingName;
        _p2size.text = suit2.clothingStockType;
        _p2price.text = [NSString stringWithFormat:@"¥%@",suit2.clothingPrice];
        
        
//        YKSuit *suit3 = _pList[2];
        _p3.text = @"";
        _p3size.text = @"";
        _p3price.text = @"";
        
        
//        YKSuit *suit4 = _pList[3];
        _p4.text = @"";
        _p4size.text = @"";
        _p4price.text = @"";
     
        _gap.constant = 60;
    }
    
    if (_pList.count==3) {
        YKSuit *suit1 = _pList[0];
        _p1.text = suit1.clothingName;
        _p1size.text = suit1.clothingStockType;
        _p1price.text = [NSString stringWithFormat:@"¥%@",suit1.clothingPrice];
        
        YKSuit *suit2 = _pList[1];
        _p2.text = suit2.clothingName;
        _p2size.text = suit2.clothingStockType;
        _p2price.text = [NSString stringWithFormat:@"¥%@",suit2.clothingPrice];
        
        
        YKSuit *suit3 = _pList[2];
        _p3.text = suit2.clothingName;
        _p3size.text = suit3.clothingStockType;
        _p3price.text = [NSString stringWithFormat:@"¥%@",suit3.clothingPrice];
        
        
//        YKSuit *suit4 = _pList[3];
        _p4.text = @"";
        _p4size.text = @"";
        _p4price.text = @"";
        _gap.constant = 90;
    }
    
    if (_pList.count==4) {
        YKSuit *suit1 = _pList[0];
        _p1.text = suit1.clothingName;
        _p1size.text = suit1.clothingStockType;
        _p1price.text = [NSString stringWithFormat:@"¥%@",suit1.clothingPrice];
        
        YKSuit *suit2 = _pList[1];
        _p2.text = suit2.clothingName;
        _p2size.text = suit2.clothingStockType;
        _p2price.text = [NSString stringWithFormat:@"¥%@",suit2.clothingPrice];
        
        
        YKSuit *suit3 = _pList[2];
        _p2.text = suit2.clothingName;
        _p2size.text = suit3.clothingStockType;
        _p2price.text = [NSString stringWithFormat:@"¥%@",suit3.clothingPrice];
        
        
        YKSuit *suit4 = _pList[3];
        _p4.text = suit4.clothingName;
        _p4size.text = suit4.clothingStockType;
        _p4price.text = [NSString stringWithFormat:@"¥%@",suit4.clothingPrice];
        _gap.constant = 112;
    }

    self.address.text = [NSString stringWithFormat:@"%@%@",_addressM.zone,_addressM.detail];
    self.name.text = [NSString stringWithFormat:@"%@(%@)",_addressM.name,_addressM.phone];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        YKShareVC *share = [[YKShareVC alloc]init];
        share.isFromSu = YES;
        [self.navigationController pushViewController:share animated:YES];
    }];
    [_inviteImage addGestureRecognizer:tap];
    [_inviteImage setUserInteractionEnabled:YES];
    
//    _time.text = _timeStr;
    _time.text = [self change:_timeStr];
    _orderLable.text = [NSString stringWithFormat:@"订单号：%@",_orderNum];
 }

- (NSString *)change:(NSString *)str {
    NSString *timeStampString  = str;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}
- (IBAction)scan:(id)sender {
    YKMySuitBagVC *bag = [YKMySuitBagVC new];
    bag.isFromSuccess = YES;
    bag.selectedIndex = 100;
    [self.navigationController pushViewController:bag animated:YES];
}
- (IBAction)back:(id)sender {
    YKHomeVC *chatVC = [[YKHomeVC alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = self.tabBarController.viewControllers[0];
    chatVC.hidesBottomBarWhenPushed = YES;
    self.tabBarController.selectedViewController = nav;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)setPList:(NSMutableArray *)pList{
    _pList = pList;
    _p1.text = @"12asdabdasdbaskjbdias";
    //布局写死了，todo：优化
    if (_pList.count==1) {
        YKSuit *suit = pList[0];
        _p1.text = suit.clothingName;
        _p1size.text = suit.clothingStockType;
        _p1price.text = suit.clothingPrice;
        _gap.constant = 30;
    }
    
    if (_pList.count==2) {
        YKSuit *suit1 = pList[0];
        _p1.text = suit1.clothingName;
        _p1size.text = suit1.clothingStockType;
        _p1price.text = suit1.clothingPrice;
        
        YKSuit *suit2 = pList[1];
        _p2.text = suit2.clothingName;
        _p2size.text = suit2.clothingStockType;
        _p2price.text = suit2.clothingPrice;
        _gap.constant = 60;
    }
    
    if (_pList.count==3) {
        YKSuit *suit1 = pList[0];
        _p1.text = [NSString stringWithFormat:@"%@",suit1.clothingName];
        _p1size.text = [NSString stringWithFormat:@"%@",suit1.clothingStockType];
        _p1price.text = [NSString stringWithFormat:@"%@",suit1.clothingPrice];
        
        YKSuit *suit2 = pList[1];
        _p2.text = [NSString stringWithFormat:@"%@",suit2.clothingName];
        _p2size.text = [NSString stringWithFormat:@"%@",suit2.clothingStockType];
        _p2price.text = [NSString stringWithFormat:@"%@",suit2.clothingPrice];
        
        YKSuit *suit3 = pList[2];
        _p3.text = [NSString stringWithFormat:@"%@",suit3.clothingName];
        _p3size.text = [NSString stringWithFormat:@"%@",suit3.clothingStockType];
        _p3price.text = [NSString stringWithFormat:@"%@",suit3.clothingPrice];
        _gap.constant = 90;
    }
    
    if (_pList.count==4) {
        YKSuit *suit1 = pList[0];
        _p1.text = suit1.clothingName;
        _p1size.text = suit1.clothingStockType;
        _p1price.text = suit1.clothingPrice;
        
        YKSuit *suit2 = pList[1];
        _p2.text = suit2.clothingName;
        _p2size.text = suit2.clothingStockType;
        _p2price.text = suit2.clothingPrice;
        
        
        YKSuit *suit3 = pList[2];
        _p2.text = suit2.clothingName;
        _p2size.text = suit3.clothingStockType;
        _p2price.text = suit3.clothingPrice;
        
        
        YKSuit *suit4 = pList[3];
        _p4.text = suit4.clothingName;
        _p4size.text = suit4.clothingStockType;
        _p4price.text = suit4.clothingPrice;
        _gap.constant = 112;
    }

}

- (void)setAddressM:(YKAddress *)addressM{
    _addressM = addressM;
    self.address.text = [NSString stringWithFormat:@"%@%@",addressM.zone,addressM.detail];
    self.name.text = [NSString stringWithFormat:@"%@(%@)",addressM.name,addressM.phone];
}

@end
