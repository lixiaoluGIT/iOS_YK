//
//  YKSPDetailVC.m
//  YK
//
//  Created by edz on 2018/6/15.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSPDetailVC.h"

#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"
#import "YKProductDetailHeader.h"
#import "YKProductDetailButtom.h"
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
#import "YKProductDetailVC.h"

@interface YKSPDetailVC ()
<UICollectionViewDelegate, UICollectionViewDataSource,ZYCollectionViewDelegate,DXAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL hadMakeHeader;
    ZYCollectionView * cycleView;
    YKProductDetailHeader *scroll;
    NewDynamicsLayout * layout;
    BOOL hadLoadCommentCell;
    YKNoDataView *NoDataView;
    CGFloat totalHeight;
    BOOL hadUserTable;
    BOOL hadTabel;
}
@property (nonatomic, strong) NSArray * imagesArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *images2;
@property (nonatomic, assign) CGRect origialFrame;
@property (nonatomic,assign)NSString *sizeNum;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *mySizeTable;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSArray *userSizeArray;

@property (nonatomic,strong)NSMutableArray *commentsArray;//评论数组
@property (nonatomic,strong)NSMutableArray *layoutsArr;

//真实数据

@end

@implementation YKSPDetailVC

- (NSMutableArray *)layoutsArr{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    self.navigationController.navigationBar.hidden = YES;
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
        
        self.product  = [YKProduct new];
        YKProductDetail *productDetail = [YKProductDetail new];
        [productDetail initWithDictionary:dic];
        self.product.productDetail = productDetail;
        scroll.product = self.product.product;
        scroll.brand = self.product.brand;
        scroll.recomment = productDetail.product[@"clothingExplain"];
        self.imagesArr = [self getImageArray:self.product.bannerImages];
        
        if (_isSP) {//pei s
            _sizeNum = scroll.product[@"clothingStockDTOS"][0][@"clothingStockId"];
        }

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
        
        [self.collectionView reloadData];
    }];
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
    [self getPruductDetail];
    
    _isSP = YES;
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
    title.font = PingFangSC_Semibold(20);
    self.navigationItem.titleView = title;
    
    //请求数据
    self.images = [NSArray array];
    self.view.backgroundColor =[ UIColor whiteColor];
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-72)/2, (WIDHT-72)/2*240/140);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-50) collectionViewLayout:layoutView];
    if (self.isFromHome) {
         self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT) collectionViewLayout:layoutView];
    }
    if (HEIGHT==812) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-80) collectionViewLayout:layoutView];
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
        self.collectionView.hidden = NO;
    });
    
    //    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    //    btn1.frame = CGRectMake(3, 20, 44, 44);
    //    btn1.adjustsImageWhenHighlighted = NO;
    //    [btn1 setImage:[UIImage imageNamed:@"newback"] forState:UIControlStateNormal];
    //    [btn1 addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:btn1];
    
    WeakSelf(weakSelf)
    YKProductDetailButtom *buttom=  [[NSBundle mainBundle] loadNibNamed:@"YKProductDetailButtom" owner:self options:nil][0];
    buttom.frame = CGRectMake(0,HEIGHT-50,WIDHT, 51);
    //iphone x 适配,排除安全区
    if (HEIGHT == 812) {
        buttom.frame = CGRectMake(0,HEIGHT-74,WIDHT, 51);
    }
    buttom.AddToCartBlock = ^(void){//添加到购物车
        [weakSelf addTOCart];
    };
    buttom.KeFuBlock = ^(void){//客服
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
        
        
        //        if ([Token length] == 0) {
        //            YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
        //            [self presentViewController:login animated:YES completion:^{
        //
        //            }];
        //            login.hidesBottomBarWhenPushed = YES;
        //            return;
        //        }
        //        YKChatVC *chatService = [[YKChatVC alloc] init];
        //        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        //        chatService.targetId = RoundCloudServiceId;
        //        chatService.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController :chatService animated:YES];
        //        DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"温馨提示" message:@"客服服务时间:10:00-19:00" cancelBtnTitle:@"拨打电话" otherBtnTitle:@"在线客服"];
        //        alertView.delegate = self;
        //        [alertView show];
        
        
        //
    };
    buttom.ToSuitBlock = ^(void){//去衣袋
        
        YKSuitVC *suit = [[YKSuitVC alloc] init];
        suit.hidesBottomBarWhenPushed = YES;
        suit.isFromeProduct = YES;
        [self.navigationController pushViewController:suit animated:YES];
        //        UINavigationController *nav = self.tabBarController.viewControllers[2];
        //        chatVC.hidesBottomBarWhenPushed = YES;
        //        self.tabBarController.selectedViewController = nav;
        //        [self.navigationController popToRootViewControllerAnimated:NO];
        
    };
    [self.view addSubview:buttom];
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

- (void)addTOCart{
    //未登录
    
    if ([Token length] == 0) {
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            
        }];
//        YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
//        [self presentViewController:login animated:YES completion:^{
//
//        }];
//        login.hidesBottomBarWhenPushed = YES;
        return;
    }
    if (_sizeNum==0 && !_isSP) {
        [smartHUD alertText:self.view alert:@"请选择尺码大小" delay:1.2];
        return ;
    }
    [[YKSuitManager sharedManager]addToShoppingCartwithclothingId:self.productId clothingStckType:_sizeNum OnResponse:^(NSDictionary *dic) {
        
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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIScrollView * scrollView = (UIScrollView *)object;
    
    if (!self.collectionView == scrollView) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if (scrollView.contentOffset.y>0) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if (scrollView.contentOffset.y>280) {
        //        self.refresh.hidden = YES;
        self.navigationController.navigationBar.alpha = 1;
        //        self.navigationController.navigationBar.hidden = NO;
    }else {
        //        self.refresh.hidden = NO;
        self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/280 ;
        //        self.navigationController.navigationBar.hidden = YES;
    }
    
    
    
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
        
        return CGSizeMake(WIDHT, WIDHT*0.82+330);
        
    }
    if (self.layoutsArr.count>0){
        
        return CGSizeMake(WIDHT, 20+60+170+layout.height+24+80-120);
    }
    else {
        
        return CGSizeMake(WIDHT, 20+60+170+150+80-170);
    }
}

//TODO:此处代码需优化
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    WeakSelf(weakSelf)
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView1 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
            headerView1.backgroundColor =[UIColor whiteColor];
            //轮播图
            cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.82+100)];
            cycleView.imagesArr = self.imagesArr;
            cycleView.delegate  = self;
            self.origialFrame = cycleView.frame;
            [headerView1 addSubview:cycleView];
            
            scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKProductDetailHeader" owner:self options:nil][0];
            
//            scroll.selectBlock = ^(NSString *type){
//                weakSelf.sizeNum = type;
//            };
            scroll.toDetailBlock = ^(NSInteger brandId,NSString *brandName){
                YKBrandDetailVC *brand = [YKBrandDetailVC new];
                brand.hidesBottomBarWhenPushed = YES;
                brand.brandId = [NSString stringWithFormat:@"%ld",brandId];
                brand.titleStr = brandName;
                
                [weakSelf.navigationController pushViewController:brand animated:YES];
            };
            scroll.frame = CGRectMake(0, WIDHT*0.82+100,WIDHT, 330);
            
            if (!hadMakeHeader) {
                [headerView1 addSubview:scroll];
                hadMakeHeader = YES;
            }
            return headerView1;
            
        }
        if (indexPath.section==1) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2" forIndexPath:indexPath];
//            headerView.backgroundColor =[UIColor redColor];
     
        //灰线
//            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDHT, 0)];
//            line.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
//            [headerView addSubview:line];
            
            
            YKRecommentTitleView  *ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][4];
            ti.frame = CGRectMake(0,0,WIDHT, 64);
          
            [headerView addSubview:ti];
            
            //评论Cell
            //TODO:优化
            
            UIView *lastView = [[UIView alloc]init];
            NewDynamicsTableViewCell * cell = [[NewDynamicsTableViewCell alloc]init];
            cell.isShowInProductDetail = YES;
            
            if (self.layoutsArr.count>0) {
                NoDataView.hidden = YES;
                cell.hidden = NO;
                cell.layout = self.layoutsArr[0];
                layout = self.layoutsArr[0];
                cell.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT, layout.height);
                
                cell.plNum.hidden = YES;
                cell.pl.hidden = YES;
                cell.linkImage.hidden = YES;
                cell.dateLabel.hidden = YES;
                cell.dividingLine.hidden = YES;
                cell.linkBtn.hidden = YES;
                cell.dz.hidden = YES;
                cell.dzNum.hidden = YES;
                cell.Line1.hidden = YES;
                cell.Line2.hidden = YES;
                cell.guanzhuImage.hidden = YES;
                
                lastView = cell;
                
                //查看更多评论
                UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [moreBtn setBackgroundImage:[UIImage imageNamed:@"chakangengduo"] forState:UIControlStateNormal];
                moreBtn.frame = CGRectMake(WIDHT/2-54, lastView.frame.size.height + lastView.frame.origin.y + 25, 108, 25);
                [headerView addSubview:moreBtn];
                [moreBtn addTarget:self action:@selector(toMore) forControlEvents:UIControlEventTouchUpInside];
                lastView = moreBtn;
                //                totalHeight = 20+60+self.dataArray.count*40+170+layout.height;
            }else {
                cell.hidden = YES;
                //无评论图
                NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
                [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"pinglun"] statusDes:@"暂无评论" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{
                    
                }];
                NoDataView.frame = CGRectMake(0, ti.frame.size.height + ti.frame.origin.y, WIDHT,150);
                NoDataView.backgroundColor = [UIColor whiteColor];
                [headerView addSubview:NoDataView];
                NoDataView.hidden = NO;
                lastView = NoDataView;
                //                totalHeight = 20+60+self.dataArray.count*40+170+150;
            }
            
            
            if (!hadLoadCommentCell) {
                [headerView addSubview:cell];
                hadLoadCommentCell = YES;
            }
            
            UILabel *line2 = [[UILabel alloc]init];
            
            if (self.layoutsArr.count>0) {
                line2.frame = CGRectMake(0, lastView.frame.size.height + lastView.frame.origin.y+25, WIDHT, 10);
            }else {
                line2.frame = CGRectMake(0, lastView.frame.size.height + lastView.frame.origin.y, WIDHT, 10);
            }
            line2.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
            [headerView addSubview:line2];
            lastView = line2;
            
            YKRecommentTitleView  *ti3 =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][1];
            ti3.frame = CGRectMake(0,lastView.frame.size.height + lastView.frame.origin.y,WIDHT, 70);
           
            [headerView addSubview:ti3];
            
            return headerView;
        }
        
    }
    
    return nil;
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
    if (indexPath.section==1) {
        return CGSizeMake((WIDHT-72)/2, (WIDHT-72)/2*240/140);
    }
    
    return CGSizeMake(WIDHT-48,WIDHT-48);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return UIEdgeInsetsMake(16, 24, 16, 24);
    }
    return UIEdgeInsetsMake(16, 24, 16, 24);
    
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 24;
    }
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 24;
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
    
//    if (indexPath.section==1) {
        if (cell.product.classify==1) {
            YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
            detail.productId = cell.goodsId;
            detail.titleStr = cell.goodsName;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
//        }else {
//            YKSPDetailVC *detail = [[YKSPDetailVC alloc]init];
//            detail.productId = cell.goodsId;
//            detail.titleStr = cell.goodsName;
//            detail.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:detail animated:YES];
//        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
