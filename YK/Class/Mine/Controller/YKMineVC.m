//
//  YKMineVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKMineVC.h"
#import "YKSuitCell.h"
#import "YKMineCell.h"
#import "YKMineBagCell.h"
#import "YKMySuitBagVC.h"
#import "YKNormalQuestionVC.h"
#import "YKWalletVC.h"
#import "YKAddressVC.h"
#import "YKSettingVC.h"
#import "YKToBeVIPVC.h"
#import "YKEditInforVC.h"
#import "YKLoginVC.h"
#import "YKDepositVC.h"
#import "YKMyHeaderView.h"
#import "YKMineCategoryCell.h"
#import "YKShareVC.h"
#import "YKReturnVC.h"
#import "YKCouponSegementVC.h"
#import "YKVipCell.h"
#import "YKUserAccountVC.h"
#import "YKSuitVC.h"


@interface YKMineVC ()<UITableViewDelegate,UITableViewDataSource,DXAlertViewDelegate>
{
//    YKMineheader *head;
    YKMyHeaderView *head;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *images;
@end

@implementation YKMineVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];;
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
//    [self setStatusBarBackgroundColor:[UIColor colorWithRed:246.0/255 green:102.0/255 blue:102.0/255 alpha:1]];
    [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
         head.user = [YKUserManager sharedManager].user;
        [self.tableView reloadData];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}
-(UIImageView*)imageview{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, WIDHT/1.5)];
//        _headImageView.image = [UIImage imageNamed:@"top.jpg"];
        _headImageView.backgroundColor = mainColor;
        self.origialFrame = _headImageView.frame;
    }
    return _headImageView;
}
-(void)addHeadView{
    WeakSelf(weakSelf)
    head= [[YKMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, WIDHT/1.5-30+20)];
    if (HEIGHT==812) {
        head= [[YKMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, WIDHT/1.5+20)];
    }
    if (WIDHT==375) {
        head= [[YKMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, WIDHT/1.5+20)];
    }
    head.userInteractionEnabled = YES;
     self.tableView.tableHeaderView=head;
    
    head.VIPClickBlock = ^(NSInteger VIPStatus){
                if (VIPStatus==1) {//使用中
                    YKWalletVC *wallet = [YKWalletVC new];
                    wallet.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:wallet animated:YES];
                }
                if (VIPStatus==2) {//已过期,充值会员
                    YKWalletVC *wallet = [YKWalletVC new];
                    wallet.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:wallet animated:YES];
                }
                if (VIPStatus==3) {//无押金,充押金
                    YKWalletVC *wallet = [YKWalletVC new];
                    wallet.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:wallet animated:YES];
                }
                if (VIPStatus==4) {//未开通
                    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
       
                    [weakSelf presentViewController:nav animated:YES completion:^{
        
                    }];
                }
            };
    
            head.viewClickBlock = ^(){
                if ([Token length] == 0) {
                    [weakSelf Login];
                    return ;
                }else {
                    YKEditInforVC *set = [[YKEditInforVC alloc]initWithNibName:@"YKEditInforVC" bundle:[NSBundle mainBundle]];
                    set.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:set animated:YES];
                }
            };
    
        head.btnClickBlock = ^(NSInteger tag){
            if ([Token length] == 0) {
                [weakSelf Login];
            }else {
                if (tag==103) {
                    //优惠劵
                    YKCouponSegementVC *coupon = [YKCouponSegementVC new];
                    coupon.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:coupon animated:YES];
                    return ;
                }
                if (tag==104) {
                    //钱包，资金账户
                    YKUserAccountVC *account = [YKUserAccountVC new];
                    account.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:account animated:YES];
                    return ;
                }
                if (tag==102) {
                    //心愿单
                    YKSuitVC *suit = [YKSuitVC new];
                    suit.isFromeProduct = YES;
                    suit.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:suit animated:YES];
                    return ;
                }
                
                //历史订单
                YKMySuitBagVC *suit = [YKMySuitBagVC new];
                suit.selectedIndex = tag+1;
                suit.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:suit animated:YES];
            }
        };
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人中心";
    [self.view addSubview:[self imageview]];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addHeadView];

    
    self.images = [NSArray array];
    self.images = @[@"question",@"address",@"kefu-1",@"setting"];
    self.titles = [NSArray array];
    self.titles = @[@"常见问题",@"我的地址",@"联系客服",@"设置"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==1) {
        return 10;
//    }
//    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"F4f4f4"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Token length] == 0) {
        return 50;
    }
    
    if (indexPath.section==0) {
        return 240;
    }
    if (indexPath.section==1) {
        return 185;
    }
   
        return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([Token length] == 0) {
        return 4;
    }else {
        if (section==0||section==1) {
            return 1;
        }else {
            return 4;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([Token length] == 0) {
        return 1;
    }else {
        return 3;
    }
        
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Token length] == 0) {
        static NSString *ID = @"cell";
        YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
            mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
            mycell.image.image = [UIImage imageNamed:self.images[indexPath.row]];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
        if (indexPath.section==0) {
            static NSString *ID = @"cell";
            YKVipCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (mycell == nil) {
                mycell = [[NSBundle mainBundle] loadNibNamed:@"YKVipCell" owner:self options:nil][0];
            }
            mycell.user = [YKUserManager sharedManager].user;
            WeakSelf(weakSelf)
            mycell.btnClick = ^(void){
                if ([mycell.user.effective intValue]==1) {//使用中
                    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
                    
                    [weakSelf presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
                if ([mycell.user.effective intValue]==2) {//已过期,充值会员
                    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
                    
                    [weakSelf presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
                if ([mycell.user.effective intValue]==3) {//无押金,充押金
                    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
                    
                    [weakSelf presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
                if ([mycell.user.effective intValue]==4) {//未开通
                    YKToBeVIPVC *vip = [[YKToBeVIPVC alloc]initWithNibName:@"YKToBeVIPVC" bundle:[NSBundle mainBundle]];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vip];
                    
                    [weakSelf presentViewController:nav animated:YES completion:^{
                        
                    }];
                }
            };
            mycell.selectionStyle = UITableViewCellSelectionStyleNone;
            return mycell;
        }
        if (indexPath.section==1) {
            static NSString *ID = @"cell";
            YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (mycell == nil) {
                mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][2];
                mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
            }
            mycell.selectionStyle = UITableViewCellSelectionStyleNone;
            return mycell;
        }
    
            static NSString *ID = @"cell";
            YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (mycell == nil) {
                mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
                mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
                mycell.image.image = [UIImage imageNamed:self.images[indexPath.row]];
            }
               mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    
    
}

- (void)kefu{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
        return;
    }
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alertview.delegate = self;
    [alertview show];
}
- (void)login{
    YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
    [self presentViewController:login animated:YES completion:^{
    
    }];
    login.hidesBottomBarWhenPushed = YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([Token length] == 0) {
            if (indexPath.row==1) {//地址
                [self Login];
            }if (indexPath.row==0) {
                YKNormalQuestionVC *normal = [YKNormalQuestionVC new];
                normal.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:normal animated:YES];
            }if (indexPath.row==2) {
                [self kefu];
            }if (indexPath.row==3) {
              
                YKSettingVC *set = [[YKSettingVC alloc]initWithNibName:@"YKSettingVC" bundle:[NSBundle mainBundle]];
                set.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:set animated:YES];
                
            }
            
        
    }else {
        if (indexPath.section==0){
            //会员
        }
    
        if (indexPath.section==1) {
            //邀请
            YKShareVC *share = [YKShareVC new];
            share.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:share animated:YES];
        }
        if (indexPath.section==2) {
            if (indexPath.row==0) {
                YKNormalQuestionVC *normal = [YKNormalQuestionVC new];
                normal.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:normal animated:YES];
            }
            if (indexPath.row==1) {
                YKAddressVC *address = [YKAddressVC new];
                address.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:address animated:YES];
            }
            if (indexPath.row==2) {
                [self kefu];
            }
            if (indexPath.row==3) {
                YKSettingVC *set = [[YKSettingVC alloc]initWithNibName:@"YKSettingVC" bundle:[NSBundle mainBundle]];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
            }
            
        }
    }
}
- (void)dxAlertView:(DXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        YKChatVC *chatService = [[YKChatVC alloc] init];
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = RoundCloudServiceId;
        chatService.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController :chatService animated:YES];
    }else {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
            NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
            NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
            if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                /// 大于等于10.0系统使用此openURL方法
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
            return;
        }
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertview.delegate = self;
        [alertview show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//取消
        
    }
    if (buttonIndex==1) {//拨打
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}


- (void)Login{
    YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
    [self presentViewController:login animated:YES completion:^{
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //往上滑动offset增加，往下滑动，yoffset减小
    CGFloat yoffset = scrollView.contentOffset.y;
    //处理背景图的放大效果和往上移动的效果
    if (yoffset>0) {//往上滑动
        
        _headImageView.frame = ({
            CGRect frame = self.origialFrame;
            frame.origin.y = self.origialFrame.origin.y - yoffset;
            frame;
        });
        
    }else {//往下滑动，放大处理
        _headImageView.frame = ({
            CGRect frame = self.origialFrame;
            frame.size.height = self.origialFrame.size.height - yoffset;
            frame.size.width = frame.size.height*1.5;
            frame.origin.x = _origialFrame.origin.x - (frame.size.width-_origialFrame.size.width)/2;
            frame;
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIScrollView * scrollView = (UIScrollView *)object;
    
    if (self.tableView != scrollView) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if (scrollView.contentOffset.y>0) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if (scrollView.contentOffset.y>100) {
        self.navigationController.navigationBar.alpha = 1;
        
    }else {
        self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/100 ;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        if (scrollView.contentOffset.y<=0) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
        
    }
}

@end
