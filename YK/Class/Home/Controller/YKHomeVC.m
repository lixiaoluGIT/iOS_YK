//
//  YKHomeVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

//640x960、640x1136、750x1334、1242x2208、1125x2436
#define h [UIScreen mainScreen].bounds.size.height
#define w [UIScreen mainScreen].bounds.size.width
#import "YKHomeVC.h"
#import "CGQCollectionViewCell.h"

#import "ZYCollectionView.h"
#import "YKBaseScrollView.h"

#import "WMHCustomScroll.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"
#import "YKProductDetailVC.h"
#import "YKBrandDetailVC.h"
#import "YKMessageVC.h"
#import "YKShareVC.h"
#import "YKLoginVC.h"
#import "YKLinkWebVC.h"
#import "YKSearchVC.h"
#import "YKHomeDesCell.h"
#import "MTAConfig.h"
#import "MTA.h"
#import "YKWeekNewView.h"
#import "DCCycleScrollView.h"

@interface YKHomeVC ()<UICollectionViewDelegate, UICollectionViewDataSource,YKBaseScrollViewDelete,WMHCustomScrollViewDelegate,DCCycleScrollViewDelegate>
{
    BOOL hadAppearCheckVersion;
    BOOL hadtitle1;
    BOOL hadtitle11;
    BOOL hadtitle3;
    BOOL hadtitle2;
    BOOL hadtitle4;
    BOOL hadtitle5;
}
@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *images2;
//真实数据源
@property (nonatomic,strong)NSArray *imagesArr;
@property (nonatomic,strong)NSArray *imageClickUrls;
@property (nonatomic,strong)NSArray *brandArray;
@property (nonatomic,strong)NSMutableArray *productArray;
@property (nonatomic,strong)NSDictionary  *weeknewDic;//每周上新
@property (nonatomic,strong)NSMutableArray *hotWears;//热门穿搭
@property (nonatomic,strong)YKScrollView *scroll;
@property (nonatomic,strong)YKScrollView *scroll1;

@property (nonatomic,strong)DCCycleScrollView *banner1;
@property (nonatomic,strong)DCCycleScrollView *banner2;
@property (nonatomic,strong)YKWeekNewView *weekNew;
@end

@implementation YKHomeVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //分享弹框
    [[YKHomeManager sharedManager]showAleartViewToShare];
    
    [UD setBool:NO forKey:@"atSearch"];
}
- (void)toSearch{
    YKSearchVC *search = [[YKSearchVC alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = self.tabBarController.viewControllers[1];
    search.hidesBottomBarWhenPushed = YES;
    self.tabBarController.selectedViewController = nav;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *)appName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"%@",app_Name);
    return app_Name;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [NC addObserver:self selector:@selector(toSearch) name:@"tosearch" object:nil];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //腾讯统计
    [[MTAConfig getInstance] setSmartReporting:YES];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
    [[MTAConfig getInstance] setDebugEnable:YES];

    NSString *tencentKey;
    //主包
    if ([[self appName] isEqualToString:@"衣库"]) {
        tencentKey = @"IC4C21RR8IRZ";
    }
    //CPA-1
    if ([[self appName] isEqualToString:@"共享衣橱"]) {
        tencentKey = @"I8YF7DJ3F8AX";
    }
    //CPS
    if ([[self appName] isEqualToString:@"女神的衣柜"]) {
        tencentKey = @"IZR5975UXRWF";
    }
    
    [MTA startWithAppkey:tencentKey];
    
    [MTA setAccount:@"其它账号" type:AT_OTH];
    //请求数据
    self.images2 = [NSArray array];
//
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]}];
    UIImage *titleImages = [UIImage imageNamed:@"title"];
    UIImageView *newTitleView = [[UIImageView alloc] initWithImage:titleImages];
    self.navigationItem.titleView = newTitleView;
    
    self.view.backgroundColor =[ UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-72)/2, (w-72)/2*240/150);
    
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-170*WIDHT/414) collectionViewLayout:layoutView];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-30) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
    self.collectionView.hidden = YES;
    
    
    //监听tableView 偏移量
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [self dd];
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    _pageNum = 1;
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _pageNum = 1;
//        [self dd];
//    }];
    WeakSelf(weakSelf)
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum ++;
        //请求更多商品
        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:@"" sortId:@"2" brandId:@"" OnResponse:^(NSArray *array) {
            [self.collectionView.mj_footer endRefreshing];
            if (array.count==0) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.collectionView.mj_footer endRefreshing];
                for (int i=0; i<array.count; i++) {
                    [self.productArray addObject:array[i]];
                }
                
                [self.collectionView reloadData];
            }
        }];
        
    }];

    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 20, 20);
    [releaseButton addTarget:self action:@selector(toMessage) forControlEvents:UIControlEventTouchUpInside];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"wuxiaoxi"] forState:UIControlStateNormal];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    
    //检查版本更新
    //    [self performSelector:@selector(checkVersion) withObject:nil afterDelay:2.2];
    
}

- (void)checkVersion{
    [[YKUserManager sharedManager]checkVersion];
}

- (void)toMessage{
    if ([Token length] == 0) {
        YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
        [self presentViewController:login animated:YES completion:^{
            
        }];
        login.hidesBottomBarWhenPushed = YES;
        return;
    }
    YKMessageVC *mes = [YKMessageVC new];
    mes.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mes animated:YES];
}

- (NSMutableArray *)getImageArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"homeImgUrl"]];
    }
    return imageArray;
}

- (NSMutableArray *)getImageClickUrlsArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"homeLinkUrl"]];
    }
    return imageArray;
}

-(void)dd{
    
    NSInteger num = 1;
    NSInteger size = 04;
    [[YKHomeManager sharedManager]getMyHomePageDataWithNum:num Size:size OnResponse:^(NSDictionary *dic) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
                if (!hadAppearCheckVersion) {
                    [self checkVersion];
                    hadAppearCheckVersion = YES;
                }
        self.collectionView.hidden = NO;
        NSArray *array = [NSArray arrayWithArray:dic[@"data"][@"loopPic"]];
        self.imagesArr = [self getImageArray:array];
        self.imageClickUrls = [NSArray array];
        self.imageClickUrls = [self getImageClickUrlsArray:array];
        self.brandArray = [NSArray arrayWithArray:dic[@"data"][@"thematicActivities"]];
        self.productArray = [NSMutableArray arrayWithArray:dic[@"data"][@"productList"][@"list"]];
        self.weeknewDic = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"weekNewProduct"]];
        self.hotWears = [NSMutableArray arrayWithArray:dic[@"data"][@"hotWears"]];

//        hadtitle1 = YES;
        if (self.brandArray.count!=0) {
            _scroll.activityArray = [NSMutableArray arrayWithArray:self.brandArray];
            _scroll1.activityArray = [NSMutableArray arrayWithArray:self.brandArray];
//            _banner1.imageArray = [NSMutableArray arrayWithArray:self.brandArray];
        }
        [_weekNew initWithDic:self.weeknewDic];
        [self.collectionView reloadData];
        
    }];
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

    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.productArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    YKProduct *procuct = [[YKProduct alloc]init];
    [procuct initWithDictionary:self.productArray[indexPath.row]];
    cell.product = procuct;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(WIDHT, WIDHT*0.52+100+320*2+100+WIDHT*0.84);
}

#pragma mark - scrollViewDelegate
-(void)scrollViewImageClick:(WMHCustomScroll *)WMHView{
    NSLog(@"%.f",WMHView.WMHScroll.contentOffset.x / WIDHT - 1);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        headerView.backgroundColor =[UIColor whiteColor];
        
        //banner图
//        ZYCollectionView * cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.55)];
//        cycleView.imagesArr = self.imagesArr;
//        cycleView.delegate  = self;
//        cycleView.placeHolderImageName = @"banner.jpg";
//        [headerView addSubview:cycleView];
        
        //轮播图
        YKBaseScrollView *cycleView = [[YKBaseScrollView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.58)];
        cycleView.imagesArr = self.imagesArr;
        cycleView.delegate = self;
        [headerView addSubview:cycleView];
        WeakSelf(weakSelf)
        
        //文字miao s
        YKHomeDesCell *desCell = [[NSBundle mainBundle] loadNibNamed:@"YKHomeDesCell" owner:self options:nil][0];
        desCell.selectionStyle = UITableViewCellEditingStyleNone;
        desCell.frame = CGRectMake(0, WIDHT*0.58, WIDHT, 82);
        [headerView addSubview:desCell];

        //活动文字（专题活动）
        YKRecommentTitleView  *ti2 =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][2];
        ti2.frame = CGRectMake(0, WIDHT*0.58+82,WIDHT, 100);
//        ti2.backgroundColor = [UIColor redColor];
        if (!hadtitle4) {
            [headerView addSubview:ti2];
            hadtitle4 = YES;
        }
        //
        _banner1  = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, ti2.frame.size.height+ ti2.frame.origin.y,WIDHT, WIDHT*0.52) shouldInfiniteLoop:YES imageGroups:[NSMutableArray arrayWithArray:self.brandArray]];
//        [DCCycleScrollView cycleScrollViewWithFrame:];
        _banner1.autoScrollTimeInterval = 3;
        _banner1.autoScroll = NO;
        _banner1.isZoom = YES;
        _banner1.itemSpace = 0;
        _banner1.imgCornerRadius = 0;
        _banner1.itemWidth = self.view.frame.size.width - 100;
        if (self.brandArray.count==1) {
            _banner1.itemWidth = self.view.frame.size.width - 48;
            _banner1.userInteractionEnabled = YES;
        }
        _banner1.delegate = self;
        _banner1.isSearch = 1;
//        _banner1.backgroundColor = [UIColor redColor];
        if (!hadtitle1&&self.brandArray.count>0) {
                [headerView addSubview:_banner1];
                hadtitle1 = YES;
        }
        
//        _scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollView" owner:self options:nil][1];
//        _scroll.frame = CGRectMake(0, WIDHT*0.58+82,WIDHT, 320);
//        [_scroll resetUI];
//        if (self.brandArray.count!=0) {
//            _scroll.brandArray = [NSMutableArray arrayWithArray:self.brandArray];
//        }
//
//        _scroll.clickALLBlock = ^(){
//            YKALLBrandVC *brand = [YKALLBrandVC new];
//            brand.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:brand animated:YES];
//        };
//
//        _scroll.toDetailBlock = ^(NSString *url,NSString *brandName){
//            YKLinkWebVC *web =[YKLinkWebVC new];
//            web.url = url;
//            web.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:web animated:YES];
//        };
//        if (!hadtitle1) {
//            [headerView addSubview:_scroll];
//            hadtitle1 = YES;
//        }
        
        
        
        //本周上新
        _weekNew = [[NSBundle mainBundle] loadNibNamed:@"YKWeekNewView" owner:self options:nil][0];
        _weekNew.frame = CGRectMake(0, _banner1.frame.origin.y + _banner1.frame.size.height, WIDHT, WIDHT*0.84);
        _weekNew.toDetailBlock = ^(void){
            YKLinkWebVC *web =[YKLinkWebVC new];
            web.url = weakSelf.weeknewDic[@"productUrl"];
            web.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:web animated:YES];
        };
        if (!hadtitle3) {
            [headerView addSubview:_weekNew];
            hadtitle3 = YES;
        }
        
        YKRecommentTitleView  *ti3 =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][3];
        ti3.frame = CGRectMake(0, _weekNew.frame.size.height + _weekNew.frame.origin.y,WIDHT, 100);
        //        ti.backgroundColor = [UIColor redColor];
        if (!hadtitle5) {
            [headerView addSubview:ti3];
            hadtitle5 = YES;
        }
        _banner2  = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, ti3.frame.size.height+ ti3.frame.origin.y,WIDHT, WIDHT*0.52) shouldInfiniteLoop:YES imageGroups:[NSMutableArray arrayWithArray:self.hotWears]];
        //        [DCCycleScrollView cycleScrollViewWithFrame:];
        _banner2.autoScrollTimeInterval = 3;
        _banner2.autoScroll = NO;
        _banner2.isZoom = YES;
        _banner2.itemSpace = 0;
        _banner2.imgCornerRadius = 0;
        _banner2.itemWidth = self.view.frame.size.width -100;
        if (self.hotWears.count==1) {
            _banner2.itemWidth = self.view.frame.size.width -48;
            _banner2.userInteractionEnabled = YES;
        }
        _banner2.delegate = self;
        _banner2.isSearch = 2;
        //        _banner1.backgroundColor = [UIColor redColor];
        if (!hadtitle11&&self.brandArray.count>0) {
            [headerView addSubview:_banner2];
            hadtitle11 = YES;
        }
        //热门穿搭
//        _scroll1=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollView" owner:self options:nil][1];
//        _scroll1.frame = CGRectMake(0, _weekNew.frame.size.height + _weekNew.frame.origin.y ,WIDHT, 320);
//                [_scroll1 resetUI];
//                if (self.brandArray.count!=0) {
//                    _scroll.brandArray = [NSMutableArray arrayWithArray:self.brandArray];
//                }
        
//        _scroll1.clickALLBlock = ^(){
//            YKALLBrandVC *brand = [YKALLBrandVC new];
//            brand.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:brand animated:YES];
//        };
        
//        _scroll1.toDetailBlock = ^(NSString *url,NSString *brandName){
//            YKLinkWebVC *web =[YKLinkWebVC new];
//            web.url = url;
//            web.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:web animated:YES];
//         };
////        [headerView addSubview:_scroll1];
//
//        if (!hadtitle11) {
//            [headerView addSubview:_scroll1];
//            hadtitle11 = YES;
//        }
        
        //推荐标题
        YKRecommentTitleView  *ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][0];
        ti.frame = CGRectMake(0, _banner2.frame.size.height + _banner2.frame.origin.y,WIDHT, 100);
//        ti.backgroundColor = [UIColor redColor];
        if (!hadtitle2) {
            [headerView addSubview:ti];
            hadtitle2 = YES;
        }
        
        return headerView;
    }
    
    return nil;
}
-(void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dic;
     YKLinkWebVC *web =[YKLinkWebVC new];
    if (cycleScrollView == _banner1) {//专题活动
        dic = [NSDictionary dictionaryWithDictionary:self.brandArray[index]];
        web.url = dic[@"specialLink"];
    }else {//热门穿搭
        dic = [NSDictionary dictionaryWithDictionary:self.hotWears[index]];
        web.url = dic[@"hotWearUrl"];
    }
    
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16, 24, 16, 24);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 24;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.row);
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
    detail.productId = cell.goodsId;
    detail.titleStr = cell.goodsName;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index === %ld",indexPath.row);
    
}

//- (void)ZYCollectionViewClick:(NSInteger)index {
//    //跳转到网页
//    YKLinkWebVC *web =[YKLinkWebVC new];
//    web.url = self.imageClickUrls[index];
//    web.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:web animated:YES];
//    
//}

- (void)YKBaseScrollViewImageClick:(NSInteger)index{
    //跳转到网页
    YKLinkWebVC *web =[YKLinkWebVC new];
    web.url = self.imageClickUrls[index-1];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

@end
