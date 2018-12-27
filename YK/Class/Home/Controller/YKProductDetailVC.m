//
//  YKProductDetailVC.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKProductDetailVC.h"

#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"
#import "YKProductDetailHeader.h"
#import "YKProductDetailButtom.h"
#import "YKDetailFootView.h"
#import "YKYifuScanCell.h"
#import "YKLoginVC.h"
#import "YKBrandDetailVC.h"
#import "YKSuitVC.h"
//#import "CLImageTypesetView.h"
#import "CLImageBrowserController.h"
//#import "YKShareManager.h"

//#import <UMSocialCore/UMSocialCore.h>
#import <UMShare/UMShare.h>
#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import "YKMainVC.h"
#import "DractLineCell.h"
#import "dractLineTwoCell.h"

#import "YKHomeDesCell.h"
#import "DynamicsModel.h"
#import "NewDynamicsLayout.h"
#import "NewDynamicsTableViewCell.h"
#import "YKNoDataView.h"
#import "YKProductCommentVC.h"
#import "YKEditSizeVC.h"
#import "YKCartVC.h"
#import "YKProductAleartView.h"
#import "YKSignalSuitVC.h"
#import "YKSearchSegmentVC.h"
#import "YKSizeTitleView.h"
#import "YKBuyOrderVC.h"

@interface YKProductDetailVC ()
<UICollectionViewDelegate, UICollectionViewDataSource,ZYCollectionViewDelegate,DXAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,NewDynamicsCellDelegate>{
    BOOL hadMakeHeader;
    ZYCollectionView * cycleView;
    YKProductDetailHeader *scroll;
    NewDynamicsLayout * layout;
    BOOL hadLoadCommentCell;
    YKNoDataView *NoDataView;
    CGFloat totalHeight;
    BOOL hadUserTable;
    BOOL hadTabel;
    BOOL hadl;
    BOOL hadTi;
    BOOL hadNoDataView;
    BOOL hadll;
    BOOL hadCom;
    BOOL hadMoreBtn;
    BOOL hadTi0;
    BOOL hadShakeBtn;
    BOOL hadCycleView;
    BOOL hadArray;
    NewDynamicsTableViewCell * cell;
   __block YKDetailFootView *buttom;
   __block YKProductAleartView *aleartView;
    UIView *backView;
    BOOL isShake;//是否伸缩
    UIView *collectionheaderView;
    UILabel *line;
    UILabel *line2;
    YKRecommentTitleView  *ti;
    YKRecommentTitleView  *ti3;
    YKHomeDesCell  *ti0;
    UIButton *moreBtn;
    UIButton *shakeBtn;
    YKSizeTitleView *sizeTitleView;
}
@property (nonatomic, strong) NSArray * imagesArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *images2;
@property (nonatomic, assign) CGRect origialFrame;
@property (nonatomic,assign)NSString *sizeNum;
@property (nonatomic,strong)NSString *sizeType;
@property (nonatomic,assign)BOOL hadStock;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *mySizeTable;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSArray *userSizeArray;

@property (nonatomic,strong)NSMutableArray *commentsArray;//评论数组
@property (nonatomic,strong)NSMutableArray *layoutsArr;

@property (nonatomic,strong)NSString *clothingCreatedate;//上新时间

//真实数据

@end

@implementation YKProductDetailVC

- (NSMutableArray *)layoutsArr{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    
//    self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/280 ;
    self.navigationController.navigationBar.hidden = NO;
//    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
//    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    
//    self.product = [YKProduct new];
    
//    [self getPruductDetail];
//    if ([UD boolForKey:@"hadNewSize"]) {
//        [self getPruductDetail];
//        [UD setBool:NO forKey:@"hadNewSize"];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    
//    [self.collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)getPruductDetail{
    [[YKHomeManager sharedManager]getProductDetailInforWithProductId:[self.productId intValue] type:_isSP  OnResponse:^(NSDictionary *dic) {
        
        self.collectionView.hidden = NO;
        self.product  = [YKProduct new];
        YKProductDetail *productDetail = [YKProductDetail new];
        [productDetail initWithDictionary:dic];
        self.product.productDetail = productDetail;
        scroll.product = self.product.product;
        scroll.brand = self.product.brand;
        aleartView.product = self.product.product;
        scroll.recomment = productDetail.product[@"clothingExplain"];
        self.imagesArr = [self getImageArray:self.product.bannerImages];
        NSArray *sizeArray = [NSArray arrayWithArray:dic[@"data"][@"sizeTableVos"]];
        NSDictionary *userSizeDic = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"userSizeTable"]];
        if (_isSP) {//pei s
            _sizeNum = scroll.product[@"clothingStockDTOS"][0][@"clothingStockId"];
        }
        
        self.clothingCreatedate = [NSString stringWithFormat:@"%@",dic[@"data"][@"clothingDetail"][@"clothingCreatedate"]];
        //生成表格需要的数组
        if (sizeArray.count>0) {
            self.dataArray = [[YKHomeManager sharedManager]getSizeArray:sizeArray];
        }
        //用户尺码表
       self.userSizeArray = [[YKHomeManager sharedManager]getUserSizeArray:userSizeDic];
        
        //评论
        NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"][@"article"]];
 
        if (currentArray.count==0) {
            //无评论
            
        }else {
            _commentsArray = [NSMutableArray arrayWithArray:currentArray];
        }
        for (id dict in _commentsArray) {
            //字典转模型
            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];//字典转模型
             layout = [[NewDynamicsLayout alloc] initWithModel:model];
            [self.layoutsArr addObject:layout];
        }
        
        [buttom initWithIsLike:productDetail.isInCollectionFolder total:productDetail.occupiedClothes];
        
//        [self performSelector:@selector(showButtom) withObject:nil afterDelay:0.1];
        [self showButtom];
        
        if (!hadArray) {
            cycleView.imagesArr = self.imagesArr;
            cycleView.delegate  = self;
            hadArray = YES;
        }
        
        
        [self.collectionView reloadData];
    }];
}

- (void)showButtom{
    [UIView animateWithDuration:0.25 animations:^{
//        buttom.backgroundColor = [UIColor blackColor];
        buttom.frame = CGRectMake(0,HEIGHT-kSuitLength_H(50),WIDHT, kSuitLength_H(50));
        //iphone x 适配,排除安全区
        if (HEIGHT == 812) {
            buttom.frame = CGRectMake(0,HEIGHT-kSuitLength_H(70),WIDHT, kSuitLength_H(50));
        }
    }] ;
}

- (NSMutableArray *)getImageArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"clothingImgUrl"]];
    }
    return imageArray;
}
- (void)viewDidLoad {

    [super viewDidLoad];
    _isSP = NO;
    isShake = YES;//尺码表默认展开
    [self getPruductDetail];
            
    _sizeNum = 0;
    if (_isFromShare) {
        self.title = @"商品详情";
    }else{
        self.title = self.titleStr;
    }
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    //    btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn1.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn1.adjustsImageWhenHighlighted = NO;
    //    btn.backgroundColor = [UIColor redColor];
    [btn1 setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Medium(kSuitLength_H(14));
    self.navigationItem.titleView = title;
    
    //请求数据
    self.images = [NSArray array];
    self.view.backgroundColor =[ UIColor whiteColor];
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
     layoutView.itemSize = CGSizeMake((WIDHT-30)/2, (WIDHT-30)/2*240/140);
//    -TOPH-20
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, MSH-kSuitLength_H(30)) collectionViewLayout:layoutView];
    if (HEIGHT==812) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, MSH-kSuitLength_H(30)) collectionViewLayout:layoutView];
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YKYifuScanCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YKYifuScanCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
    self.collectionView.hidden = YES;
    
    
    //监听tableView 偏移量
    //    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    //    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    //    self.refresh = [YyxHeaderRefresh header];
    //
    //    self.refresh.tableView = self.collectionView;
    //    [self dd];
    //    CATWEAKSELF
    //    self.refresh.beginRefreshingBlock = ^(YyxHeaderRefresh *refreshView){
    //        [weakSelf dd];
    //    };
    //
    //       // [BQActivityView showActiviTy];
    [LBProgressHUD showHUDto:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [BQActivityView hideActiviTy];
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        self.collectionView.hidden = NO;
    });
    
    UIButton *btn11=[UIButton buttonWithType:UIButtonTypeCustom];
    btn11.frame = CGRectMake(3, BarH-44, 44, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 12) {
        btn11.frame = CGRectMake(5, BarH-44, 44, 44);
    }
    btn11.adjustsImageWhenHighlighted = NO;
    [btn11 setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn11 addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn11];
    
    WeakSelf(weakSelf)
    buttom =  [[NSBundle mainBundle] loadNibNamed:@"YKDetailFootView" owner:self options:nil][0];
    buttom.frame = CGRectMake(0,HEIGHT,WIDHT, kSuitLength_H(50));
    //iphone x 适配,排除安全区
    if (HEIGHT == 812) {
      buttom.frame = CGRectMake(0,HEIGHT,WIDHT, kSuitLength_H(50));
    }
//    buttom.product = self.product;
    buttom.canBuy = YES;
    buttom.likeSelectBlock = ^(BOOL isLike){
        if (isLike) {
            [weakSelf deCollect];
        }else{
            [weakSelf collect];
        }
    };
    buttom.AddToCartBlock = ^(void){//添加到购物车
        [weakSelf addTOCart:3];
       
    };
    buttom.buyBlock = ^(void){
        [weakSelf addTOCart:2];
    };

    buttom.ToSuitBlock = ^(void){//去衣袋
        
        if ([Token length] == 0) {
            [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
                
            }];

            return;
        }
        
        YKSearchSegmentVC *chatVC = [[YKSearchSegmentVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = weakSelf.tabBarController.viewControllers[3];
        chatVC.hidesBottomBarWhenPushed = YES;
        weakSelf.tabBarController.selectedViewController = nav;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        YKSignalSuitVC *suit = [[YKSignalSuitVC alloc] init];
//
//        [weakSelf.navigationController pushViewController:suit animated:YES];
    };
    
    [self.view addSubview:buttom];
    
    backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor blackColor];
    backView.frame = [UIScreen mainScreen].bounds;
    backView.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    backView.hidden = YES;
    
    aleartView = [[NSBundle mainBundle]loadNibNamed:@"YKProductAleartView" owner:nil options:nil][0];
    aleartView.frame = CGRectMake(0, HEIGHT, WIDHT, kSuitLength_H(300));
    aleartView.selectBlock = ^(NSString *typeId, NSString *type) {
        _sizeNum = typeId;
        _sizeType = type;
    };
    aleartView.addTOCartBlock = ^(NSString *type){
        [weakSelf addTOCart:3];
    };
    aleartView.favouriteBlock = ^(NSString *type){
        [weakSelf collect];
    };
    aleartView.buyBlock = ^(NSString *type){
        [weakSelf addTOCart:2];
    };
    aleartView.disBLock = ^(void){
        [weakSelf disMiss];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:aleartView];
    
    cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, WIDHT*1.1)];
    sizeTitleView = [[YKSizeTitleView alloc]init];
    scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKProductDetailHeader" owner:self options:nil][0];
    ti0 =  [[NSBundle mainBundle] loadNibNamed:@"YKHomeDesCell" owner:self options:nil][1];
    shakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDHT, self.dataArray.count*40) style:UITableViewStylePlain];
    line = [[UILabel alloc]init];
    ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][4];
    cell = [[NewDynamicsTableViewCell alloc]init];
    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    ti3 = [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][1];
    line2 = [[UILabel alloc]init];
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatHeaderView];
}

- (void)creatHeaderView{
    collectionheaderView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)disMiss{
    [UIView animateWithDuration:0.25 animations:^{
        aleartView.frame = CGRectMake(0, HEIGHT, WIDHT, kSuitLength_H(300));
    }completion:^(BOOL finished) {
        backView.hidden = YES;
    }];
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
- (void)leftAction{
    if (_isFromShare) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = [YKMainVC new];
        CATransition *anim = [CATransition animation];
        anim.duration = .3;
        anim.type = @"fade";
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.tabBarController setSelectedIndex:0];
}

//取消收藏
- (void)deCollect{
   
    NSMutableArray *shopCartList = [NSMutableArray array];
    [shopCartList addObject:self.productId];
    [[YKSuitManager sharedManager]deleteCollecttwithShoppingCartId:shopCartList OnResponse:^(NSDictionary *dic) {
        [self getPruductDetail];
    }];
    
}

//收藏商品
- (void)collect{
    if ([Token length] == 0) {
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            
        }];
        return;
    }
    
    if (_sizeNum==0 && !_isSP) {
//        [smartHUD alertText:self.view alert:@"请选择尺码大小" delay:1.2];
        //弹出尺码选择的页面
        
        [UIView animateWithDuration:0.25 animations:^{
            backView.hidden = NO;
            aleartView.frame = CGRectMake(0, HEIGHT-kSuitLength_H(300), WIDHT, kSuitLength_H(300));
            aleartView.type = 1;
        }];
        return ;
    }
    
    [[YKSuitManager sharedManager]collectWithclothingId:self.productId clothingStckType:_sizeNum OnResponse:^(NSDictionary *dic) {
        [self disMiss];
        [self getPruductDetail];
    
    }];
}

- (void)addTOCart:(NSInteger)actionStatus{
    //未登录
    
    if ([Token length] == 0) {
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            
        }];

        return;
    }
    if (_sizeNum==0 && !_isSP) {
//        [smartHUD alertText:self.view alert:@"请选择尺码大小" delay:1.2];
        //弹出尺码选择的页面
        
        [UIView animateWithDuration:0.25 animations:^{
            backView.hidden = NO;
            aleartView.frame = CGRectMake(0, HEIGHT-kSuitLength_H(300), WIDHT, kSuitLength_H(300));
            aleartView.type = actionStatus;
        }];
        
        return ;
    }
    
    if (actionStatus==2) {//跳到购买确认订单页面
        
        YKBuyOrderVC *buyOrder = [[YKBuyOrderVC alloc]init];
        //商品信息传过去
        buyOrder.product = self.product.product;
        //商品尺码id传过去
        buyOrder.sizeId = self.sizeNum;
        //尺码大小
        buyOrder.sizeNum = self.sizeType;
        [self.navigationController pushViewController:buyOrder animated:YES];
        
        [self disMiss];
        return;
    }
    [[YKSuitManager sharedManager]addToShoppingCartwithclothingId:self.productId clothingStckType:_sizeNum OnResponse:^(NSDictionary *dic) {
        //添加购物车动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addToCartSuccess" object:self userInfo:nil];
        [self disMiss];
        [self getPruductDetail];
        
    }];
}
-(void)dd{
    
    int random = self.images2.count;
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 1; i < random; i++) {
        int randomIndex = arc4random_uniform(random);
        [temp addObject:self.images2[randomIndex]];
    }
    if (temp.count) {
        self.images = [temp copy];
    }
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self.refresh endRefreshing];
        [self.collectionView reloadData];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
//    if (scrollView.contentOffset.y>kSuitLength_H(500)) {
//
//        self.navigationController.navigationBar.alpha = 1;
//        self.navigationController.navigationBar.hidden = NO;
//    }else {
//
//        self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/kSuitLength_H(500) ;
//        self.navigationController.navigationBar.hidden = NO;
//    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
//        return self.product.pruductDetailImgs.count;
        return 0;
    }
    return self.product.productList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    
    
    if (indexPath.section==1) {
        YKProduct *product = [YKProduct new];
        [product initWithDictionary:self.product.productList[indexPath.row]];
        cell.product = product;
        return cell;
    }
    YKYifuScanCell *scan = (YKYifuScanCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YKYifuScanCell" forIndexPath:indexPath];
    
    [scan.imageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:self.product.pruductDetailImgs[indexPath.row][@"clothingImgUrl"]]] placeholderImage:[UIImage imageNamed:@"商品详情头图"]];
    [scan.imageView setContentMode:UIViewContentModeScaleAspectFill];
    scan.imageArray = [self getImageArray:self.product.pruductDetailImgs];
    scan.num = indexPath.row;
    return scan;
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


//头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
       
            return CGSizeMake(WIDHT, WIDHT*1.1+230);
        
    }

    if (isShake) {
        if (self.layoutsArr.count>0){
            
            return CGSizeMake(WIDHT, 20+self.dataArray.count*40+170+layout.height+75+80-30);
        }
        else {
            
            return CGSizeMake(WIDHT, 20+self.dataArray.count*40+170+150+80-30);
        }
    }else {
        if (self.layoutsArr.count>0){
            
            return CGSizeMake(WIDHT, 20+170+layout.height+75+80-30);
        }
        else {
            
            return CGSizeMake(WIDHT, 20+170+150+80-30);
        }
    }
}

//TODO:此处代码需优化
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    WeakSelf(weakSelf)
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
            headerView.backgroundColor =[UIColor whiteColor];
            //轮播图
//            cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, WIDHT*1.1)];
//            cycleView.imagesArr = self.imagesArr;
//            cycleView.delegate  = self;
//            self.origialFrame = cycleView.frame;
            
            if (!hadCycleView) {
                [headerView addSubview:cycleView];
                hadCycleView = YES;
                cycleView.imagesArr = self.imagesArr;
                cycleView.delegate  = self;
                self.origialFrame = cycleView.frame;
            }
           
            

            scroll.selectBlock = ^(NSString *typeId,NSString *type,BOOL hadStock){
                weakSelf.sizeNum = typeId;
                weakSelf.sizeType = type;
                weakSelf.hadStock = hadStock;
                
                buttom.hadStock = hadStock;
            };
            scroll.toDetailBlock = ^(NSInteger brandId,NSString *brandName){
                YKBrandDetailVC *brand = [YKBrandDetailVC new];
                brand.hidesBottomBarWhenPushed = YES;
                brand.brandId = [NSString stringWithFormat:@"%ld",brandId];
                brand.titleStr = brandName;
                
                [weakSelf.navigationController pushViewController:brand animated:YES];
            };
            scroll.frame = CGRectMake(0, WIDHT*1.1,WIDHT, 330);
            scroll.clothingCreatedate = self.clothingCreatedate;
            if (!hadMakeHeader) {
                [headerView addSubview:scroll];
                hadMakeHeader = YES;
            }
            return headerView;
            
        }
        if (indexPath.section==1) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2" forIndexPath:indexPath];
            headerView.backgroundColor =[UIColor whiteColor];
            
            
            
//            YKHomeDesCell  *ti0 =  [[NSBundle mainBundle] loadNibNamed:@"YKHomeDesCell" owner:self options:nil][1];
            //尺码表标题
            sizeTitleView.frame = CGRectMake(0,0,WIDHT, 50);
            sizeTitleView.backgroundColor = [UIColor whiteColor];
            if (!hadTi0) {
                [headerView addSubview:sizeTitleView];
                if ( self.userSizeArray.count==1) {//只有我的这个字段，说明没有添加尺码
                    sizeTitleView.hasEditSize = NO;
                }else {
                    sizeTitleView.hasEditSize = YES;
                }
                //测试数据
                sizeTitleView.recSize = @"均码";
                sizeTitleView.toEditSizeBlock = ^(void){
                    [weakSelf toEdit];
                };
                hadTi0 = YES;
            }
//            if ( self.userSizeArray.count==1) {//只有我的这个字段，说明没有添加尺码
//                sizeTitleView.hasEditSize = NO;
//            }else {
//                 sizeTitleView.hasEditSize = YES;
//            }
//            //测试数据
//            sizeTitleView.recSize = @"均码";
//            sizeTitleView.toEditSizeBlock = ^(void){
//                [weakSelf toEdit];
//            };
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toEdit)];
//            [sizeTitleView addGestureRecognizer:tap];
            

//            if (!hadTi0) {
//                [headerView addSubview:sizeTitleView];
//                hadTi0 = YES;
//            }
//            [headerView addSubview:ti0];
            
            //收缩按钮
//            UIButton *shakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [shakeBtn setImage:[UIImage imageNamed:@"箭头上"] forState:UIControlStateNormal];
            if (!hadShakeBtn) {
                 [sizeTitleView addSubview:shakeBtn];
                hadShakeBtn = YES;
            }
            [shakeBtn addTarget:self action:@selector(shake:) forControlEvents:UIControlEventTouchUpInside];
//            shakeBtn.frame = CGRectMake(WIDHT-32, 0, 40, 30);
            [shakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(sizeTitleView.mas_centerY);
                make.right.mas_equalTo(sizeTitleView.mas_right).offset(0);
                make.width.height.mas_offset(kSuitLength_H(60));
            }];
            //tableView内存需优化
//            self.mySizeTable.backgroundColor = [UIColor redColor];
//            self.mySizeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDHT, 40*2) style:UITableViewStylePlain];
//            self.mySizeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//            self.mySizeTable.delegate = self;
//            self.mySizeTable.dataSource = self;
//            if (!hadUserTable) {
//                [headerView addSubview:self.mySizeTable];
//                hadUserTable = YES;
//            }
//
//            [self.mySizeTable reloadData];
            
            
//            YKHomeDesCell  *ti2 =  [[NSBundle mainBundle] loadNibNamed:@"YKHomeDesCell" owner:self options:nil][2];
//            ti2.frame = CGRectMake(0, 50,WIDHT, 50);
//            [headerView addSubview:ti2];
//            line = [[UILabel alloc]init];
            if (isShake) {//展开
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.frame = CGRectMake(0, 50, WIDHT, self.dataArray.count*40);
                    self.tableView.hidden = NO;
                    line.frame = CGRectMake(0, self.tableView.bottom, WIDHT, 10);
                }];
            }else{//收起
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.frame = CGRectMake(0, 50, WIDHT, 0);
                    self.tableView.hidden = YES;
                     line.frame = CGRectMake(0, self.tableView.bottom, WIDHT, 10);
                }];
            }
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            if (!hadTabel) {
                [headerView addSubview:self.tableView];
                hadTabel = YES;
            }
            [self.tableView reloadData];
            
//            灰线
//            UILabel *line = [[UILabel alloc]init];
            line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
            if (isShake) {
                [UIView animateWithDuration:0.3 animations:^{
                    line.frame = CGRectMake(0, 50+self.dataArray.count*40, WIDHT, 10);
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                     line.frame = CGRectMake(0, 50, WIDHT, 10);
                }];
                
            }
            if (!hadl) {
                [headerView addSubview:line];
                hadl = YES;
            }

            
//            YKRecommentTitleView  *ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][4];
            
            if (isShake) {
                [UIView animateWithDuration:0.3 animations:^{
                    ti.frame = CGRectMake(0,self.dataArray.count*40+70+10,WIDHT, 64);
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    ti.frame = CGRectMake(0,80,WIDHT, 64);
                }];
               
            }
//            ti.backgroundColor = [UIColor redColor];
         
            
            
            if (!hadTi) {
                [headerView addSubview:ti];
                hadTi = YES;
            }
            //评论Cell
            //TODO:优化
            
            UIView *lastView = [[UIView alloc]init];
//            cell = [[NewDynamicsTableViewCell alloc]init];
            cell.isShowInProductDetail = YES;
            cell.delegate = self;

            if (self.layoutsArr.count>0) {
                NoDataView.hidden = YES;
                cell.hidden = NO;
                cell.layout = self.layoutsArr[0];
                layout = self.layoutsArr[0];
//                cell.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT, layout.height);
                if (isShake) {
                    [UIView animateWithDuration:0.3 animations:^{
                        cell.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT, layout.height);
                    }];
                    
                }else{
                    [UIView animateWithDuration:0.3 animations:^{
                       cell.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT, layout.height);
                    }];
                    
                }
                [cell reSetUI];
                

                lastView = cell;
                
                //查看更多评论
             
                [moreBtn setBackgroundImage:[UIImage imageNamed:@"chakangengduo"] forState:UIControlStateNormal];
                moreBtn.frame = CGRectMake(WIDHT/2-54, cell.bottom + 25, 108, 25);
                if (isShake) {
                    moreBtn.frame = CGRectMake(WIDHT/2-54, cell.bottom + 25, 108, 25);
                }else {
                    moreBtn.frame = CGRectMake(WIDHT/2-54, cell.bottom + 25, 108, 25);
                }
                if (!hadMoreBtn) {
                    [headerView addSubview:moreBtn];
                    hadMoreBtn = YES;
                }

                [moreBtn addTarget:self action:@selector(toMore) forControlEvents:UIControlEventTouchUpInside];
                lastView = moreBtn;

            }else {
                cell.hidden = YES;
                //无评论图
                UIView *a = [[UIView alloc]init];
                if (WIDHT==320) {
//

                    a.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT,150);
                    [headerView addSubview:a];

                }else {
//                    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
                }
               
              
                [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"pinglun"] statusDes:@"暂无评论" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{
                    
                }];
               
                if (isShake) {
                    [UIView animateWithDuration:0.3 animations:^{
                         NoDataView.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT,150);
                    }];
                    
                }else{
                    [UIView animateWithDuration:0.3 animations:^{
                        NoDataView.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT,150);
                    }];
                    
                }
                NoDataView.backgroundColor = [UIColor whiteColor];
               
                if (!hadNoDataView) {
                     [headerView addSubview:NoDataView];
                    hadNoDataView = YES;
                }
                NoDataView.hidden = NO;
//                lastView = NoDataView;
               
                if (WIDHT==320) {
                      lastView = a;
                }else {
                      lastView = NoDataView;
                }
                totalHeight = 20+60+self.dataArray.count*40+170+150;
            }
            
            
            if (!hadLoadCommentCell) {
                [headerView addSubview:cell];
                hadLoadCommentCell = YES;
            }

           

            if (isShake) {
                [UIView animateWithDuration:0.3 animations:^{
                    if (self.layoutsArr.count>0) {
                        line2.frame = CGRectMake(0, lastView.frame.size.height + lastView.frame.origin.y+25, WIDHT, 10);
                    }else {
                        line2.frame = CGRectMake(0, lastView.frame.size.height + lastView.frame.origin.y, WIDHT, 10);
                    }
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    if (self.layoutsArr.count>0) {
                        line2.frame = CGRectMake(0, lastView.frame.size.height + lastView.frame.origin.y+25, WIDHT, 10);
                    }else {
                        line2.frame = CGRectMake(0, lastView.frame.size.height + lastView.frame.origin.y, WIDHT, 10);
                    }
                }];
                
            }
            
           
            line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
//            [headerView addSubview:line2];
            if (!hadll) {
                [headerView addSubview:line2];
                hadll = YES;
            }
            lastView = line2;
            
//            YKRecommentTitleView  *ti3 =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][1];
//            ti3.frame = CGRectMake(0,lastView.frame.size.height + lastView.frame.origin.y,WIDHT, 70);
            if (isShake) {
                [UIView animateWithDuration:0.3 animations:^{
                    ti3.frame = CGRectMake(0,lastView.frame.size.height + lastView.frame.origin.y,WIDHT, 70);
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    ti3.frame = CGRectMake(0,lastView.frame.size.height + lastView.frame.origin.y,WIDHT, 70);
                }];
                
            }
//                        ti3.backgroundColor = [UIColor redColor];
           
            if (!hadCom) {
                 [headerView addSubview:ti3];
                hadCom = YES;
            }
            return headerView;
        }
        
    }
    
    return nil;
}

- (void)shake:(UIButton *)btn{
    btn.selected = !btn.selected;
    isShake = !isShake;
    if (isShake) {
        [UIView animateWithDuration:0.5 animations:^{
            btn.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            btn.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
           
        }];
    }
    
    [self.collectionView reloadData];
}

-(void)DidClickMoreLessInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
////    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
//    NewDynamicsLayout * layout = self.layoutsArr[0];
//    layout.model.isOpening = !layout.model.isOpening;
//    [layout resetLayout];
////    CGRect cellRect = [self.collectionView rectForRowAtIndexPath:indexPath];
//    
//    [self.collectionView reloadData];
//
//    if (cellRect.origin.y < self.collectionView.contentOffset.y + 64) {
//        [self.collectionView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
}
- (void)toEdit{
    if ([Token length] == 0) {
        [smartHUD alertText:self.view alert:@"请先登录" delay:1.5];
        return;
    }
    YKEditSizeVC *edit = [[YKEditSizeVC alloc]init];
    edit.mySizeArray = _userSizeArray[1];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)toMore{
 
    YKProductCommentVC *comment = [[YKProductCommentVC alloc]init];
    comment.clothingId = self.product.productDetail.product[@"clothingId"];
    [self.navigationController pushViewController:comment animated:YES];
}
//设置大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==1) {
        return CGSizeMake((WIDHT-30)/2, (WIDHT-30)/2*240/140);
//    }
    
//    return CGSizeMake(WIDHT-48,WIDHT-48);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath.section==0) {
        NSArray *array = [self getImageArray:self.product.pruductDetailImgs];
        CLImageBrowserController *imageBrowser = [[CLImageBrowserController alloc] initWithSourceArray:array imageArray:array index:indexPath.row];
        imageBrowser.transitioningDelegate = imageBrowser;
        [self presentViewController:imageBrowser animated:YES completion:nil];
    }
    
    if (indexPath.section==1) {
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.productId = cell.goodsId;
        detail.titleStr = cell.goodsName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index === %ld",indexPath.row);
   
}

- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
    
    CLImageBrowserController *imageBrowser = [[CLImageBrowserController alloc] initWithSourceArray:_imagesArr imageArray:_imagesArr index:index];
    imageBrowser.transitioningDelegate = imageBrowser;
    [self presentViewController:imageBrowser animated:YES completion:nil];
    
}

- (void)share{
//    [[YKShareManager sharedManager]YKShareProductClothingId:@""];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]]; // 设置需要分享的平台
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"回调");
        NSLog(@"%ld",(long)platformType);
        NSLog(@"%@",userInfo);
        
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbUR =  self.imagesArr[0];
        NSString *thumbURL = [self URLEncodedString:thumbUR];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"分享一件高颜值的美衣给你-%@",self.product.productDetail.product[@"clothingName"]] descr:@"衣库家的这件衣服超美哦，忍不住想要分享给你！" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"http://img-cdn.xykoo.cn/appHtml/share/share.html?clothing_id=%@", self.product.productDetail.product[@"clothingId"]];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            NSLog(@"调用分享接口");
            
            if (error) {
                NSLog(@"调用失败%@",error);
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"调用成功");
                //弹出分享成功的提示,告诉后台,成功后getuser
                
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            //        [self alertWithError:error];
        }];
    }];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
//    if (tableView == self.mySizeTable) {
//        return self.userSizeArray.count;
//    }else {
        return self.dataArray.count;
//
//    }
//    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
        dractLineTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lineCell"];
        if (!cell) {
            cell = [[dractLineTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lineCell"];
        }
//    if (tableView==self.mySizeTable) {
//        cell.titleArr = self.userSizeArray[indexPath.row];
//        [cell setTitleRow:indexPath.row];
//    }else {
        cell.titleArr = self.dataArray[indexPath.row];
    
    //如果已编辑自己的尺码，拿到后台推荐的尺码
    //假数据
        cell.recSize = @"均码";
        [cell setTitleRow:indexPath.row];
//    }
    
 
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        return cell;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

