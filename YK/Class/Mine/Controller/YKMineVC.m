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
//    [self setStatusBarBackgroundColor:[UIColor colorWithRed:246.0/255 green:102.0/255 blue:102.0/255 alpha:1]];
    [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
         head.user = [YKUserManager sharedManager].user;
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [self setStatusBarBackgroundColor:self.view.backgroundColor];
     [self.navigationController.navigationBar setHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    head= [[YKMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, WIDHT/1.5)];
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
            }
            ;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];


    
    [self.view addSubview:[self imageview]];
    [self.view addSubview:self.tableView];
    [self addHeadView];

    
    self.images = [NSArray array];
    self.images = @[@"qianbao",@"gerenziliao",@"yaoqing",@"question",@"kefu-1",@"setting"];
    self.titles = [NSArray array];
    self.titles = @[@"我的钱包",@"个人资料",@"邀请有奖",@"常见问题",@"联系客服",@"设置"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"F8f8f8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 106*WIDHT/414;
    }
    return WIDHT/3*2*108/124;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(weakSelf)
    if (indexPath.section==0) {
        YKMineBagCell *bagCell = [[NSBundle mainBundle] loadNibNamed:@"YKMineBagCell" owner:self options:nil][0];
        bagCell.scanBlock = ^(NSInteger tag){
            if ([Token length] == 0) {
                [weakSelf Login];
            }else {
                YKMySuitBagVC *suit = [YKMySuitBagVC new];
                suit.selectedIndex = tag;
                suit.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:suit animated:YES];
            }
        };
        bagCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return bagCell;
    }
    
    static NSString *identifer = @"cell";
    YKMineCategoryCell *cell = [[YKMineCategoryCell alloc]init];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell initWithTitleArray:self.titles ImageArray:self.images];
    cell.clickBlock = ^(NSInteger tag){
        if ([Token length] == 0) {
            if (tag!=3&&tag!=4) {
                [self Login];
                return;
            }
        }
       
            if (tag==0) {//钱包
                YKWalletVC *wallet = [YKWalletVC new];
                wallet.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wallet animated:YES];
            }
            if (tag==1) {//个人资料
                YKEditInforVC *set = [[YKEditInforVC alloc]initWithNibName:@"YKEditInforVC" bundle:[NSBundle mainBundle]];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
                
            }
            if (tag==2) {//收货地址
                YKShareVC *share = [YKShareVC new];
                share.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:share animated:YES];
            }
            if (tag==3) {//常见问题
                YKNormalQuestionVC *normal = [YKNormalQuestionVC new];
                normal.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:normal animated:YES];
            }
            if (tag==4) {//联系客服
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
                
//                if ([Token length] == 0) {
//                    YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
//                    [self presentViewController:login animated:YES completion:^{
//
//                    }];
//                    login.hidesBottomBarWhenPushed = YES;
//                    return;
//                }
//
//                DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"温馨提示" message:@"客服服务时间:10:00-19:00" cancelBtnTitle:@"拨打电话" otherBtnTitle:@"在线客服"];
//                alertView.delegate = self;
//                [alertView show];
                
               
            }
            if (tag==5) {//设置
//                YKReturnVC *re = [[YKReturnVC alloc]init];
                YKSettingVC *set = [[YKSettingVC alloc]initWithNibName:@"YKSettingVC" bundle:[NSBundle mainBundle]];
                set.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:set animated:YES];
            }
            
        
    };
    return cell;
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

@end
