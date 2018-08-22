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

#import "YKWeekNewView.h"
#import "DCCycleScrollView.h"
#import "YKHomeCrollView.h"

#import "DynamicsModel.h"
#import "NewDynamicsLayout.h"
#import "NewDynamicsTableViewCell.h"



@interface YKHomeVC ()<UICollectionViewDelegate, UICollectionViewDataSource,YKBaseScrollViewDelete,WMHCustomScrollViewDelegate,DCCycleScrollViewDelegate,NewDynamicsCellDelegate>
{
    BOOL hadAppearCheckVersion;
    BOOL hadtitle1;
    BOOL hadtitle11;
    BOOL hadtitle3;
    BOOL hadtitle2;
    BOOL hadtitle4;
    BOOL hadtitle5;
    BOOL rqmy;
    BOOL dpct;
    BOOL rqps;
    BOOL jmst;
    BOOL jxst;
    BOOL com1;
    BOOL com2;
    CGFloat lastContentOffset;
    UIImageView *image;
    //
    NewDynamicsTableViewCell * cell1;
    NewDynamicsLayout * layout1;
    //
    NewDynamicsTableViewCell * cell2;
    NewDynamicsLayout * layout2;
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

@property (nonatomic,strong)NSMutableArray *layoutsArr1;
@property (nonatomic,strong)NSArray *layoutsArr2;
@end

@implementation YKHomeVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [image removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    image.hidden = NO;
    [self showPoint];
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
    //弹框
//    [[YKHomeManager sharedManager]showAleart];
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
    layoutView.itemSize = CGSizeMake((WIDHT-30)/2, (w-30)/2*240/140);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-170*WIDHT/414) collectionViewLayout:layoutView];
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-30) collectionViewLayout:layoutView];
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
        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:@"" sortId:@"2" sytleId:@"0" brandId:@"" OnResponse:^(NSArray *array) {
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

- (void)showPoint{
    image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"悬浮窗"]];
    if (HEIGHT==812) {
        image.frame = CGRectMake(WIDHT-80, HEIGHT-150, 45, 45);
    }else {
        image.frame = CGRectMake(WIDHT-80, HEIGHT-130, 55, 55);
    }
//    [image sizeToFit];
    [[UIApplication sharedApplication].keyWindow addSubview:image];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(invite)];
    [image setUserInteractionEnabled:YES];
    [image addGestureRecognizer:tap];
}

- (void)invite{
    YKShareVC *share = [[YKShareVC alloc]init];
    share.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:share animated:YES];
 }

- (void)aleart{
    [[YKHomeManager sharedManager]showAleart];
}

- (NSMutableArray *)layoutsArr1{
    if (!_layoutsArr1) {
        _layoutsArr1 = [NSMutableArray array];
    }
    return _layoutsArr1;
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
        [self performSelector:@selector(aleart) withObject:nil afterDelay:1];
        self.collectionView.hidden = NO;
        NSArray *array = [NSArray arrayWithArray:dic[@"data"][@"loopPic"]];
        self.imagesArr = [self getImageArray:array];
        self.imageClickUrls = [NSArray array];
        self.imageClickUrls = [self getImageClickUrlsArray:array];
        self.brandArray = [NSArray arrayWithArray:dic[@"data"][@"thematicActivities"]];
        self.productArray = [NSMutableArray arrayWithArray:dic[@"data"][@"productList"][@"list"]];
        self.weeknewDic = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"suitwith"][@"content"]];
        self.hotWears = [NSMutableArray arrayWithArray:dic[@"data"][@"fashionWears"]];

        NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"][@"article"][@"articleVOS"]];
        
     
        for (id dict in currentArray) {
            //字典转模型
            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];//字典转模型
            layout1 = [[NewDynamicsLayout alloc] initWithModel:model];
            [self.layoutsArr1 addObject:layout1];
        }
       
        
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
 
    if (WIDHT == 375) {
        return CGSizeMake(WIDHT, WIDHT*0.52+60+320*2+60+WIDHT*0.8-40 + WIDHT-20 + WIDHT-20 + layout1.height+layout2.height+15-60 + 60+20+20-30);
    }
    if(WIDHT == 414){
        return CGSizeMake(WIDHT, WIDHT*0.52+60+320*2+60+WIDHT*0.8 + WIDHT-40 + WIDHT-40+ layout1.height + layout2.height + 15 + 60+20+20-40);
    }else {
        return CGSizeMake(WIDHT, WIDHT*0.52+60+320*2+60+WIDHT*0.8-40 + WIDHT-20 + WIDHT-20 +layout1.height+ layout2.height + 15 + 60+20+20-40);
    }
}

#pragma mark - scrollViewDelegate
-(void)scrollViewImageClick:(WMHCustomScroll *)WMHView{
    NSLog(@"%.f",WMHView.WMHScroll.contentOffset.x / WIDHT - 1);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        
        //banner图
//        ZYCollectionView *cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.55)];
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
        desCell.frame = CGRectMake(0, cycleView.frame.size.height + cycleView.frame.origin.y, WIDHT, 92);
//        desCell.backgroundColor=[UIColor redColor];
        [headerView addSubview:desCell];

        //人气美衣
        YKHomeCrollView *homeScrollView = [[NSBundle mainBundle] loadNibNamed:@"YKHomeCrollView" owner:self options:nil][0];
        homeScrollView.selectionStyle = UITableViewCellEditingStyleNone;
        homeScrollView.frame = CGRectMake(0, WIDHT*0.58+92, WIDHT, WIDHT-40);
        if (HEIGHT!=414) {
            homeScrollView.frame = CGRectMake(0, WIDHT*0.58+92, WIDHT, WIDHT-20);
        }
        [homeScrollView initWithType:1 productList:nil OnResponse:^{
            NSLog(@"qu");
        }];
        if (!rqmy) {
            [headerView addSubview:homeScrollView];
            rqmy = YES;
        }
        
        //活动文字（专题活动）
        YKRecommentTitleView  *ti2 =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][2];
        ti2.frame = CGRectMake(0, homeScrollView.frame.size.height + homeScrollView.frame.origin.y,WIDHT, 60);
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
        _banner1.itemSpace = -32;
        _banner1.imgCornerRadius = 0;
        _banner1.itemWidth = self.view.frame.size.width - 48;
        if (self.brandArray.count==1) {
            _banner1.itemWidth = self.view.frame.size.width - 48;
            _banner1.itemSpace = 0;
        }
        _banner1.delegate = self;
        _banner1.isSearch = 1;
        _banner1.toDetailBlock = ^(NSInteger index){
            NSDictionary *dic;
            YKLinkWebVC *web =[YKLinkWebVC new];
            web.needShare = YES;
            
                dic = [NSDictionary dictionaryWithDictionary:self.brandArray[index]];
                web.url = dic[@"specialLink"];
                if (web.url.length == 0) {
                    return;
                }
                web.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:web animated:YES];
        };
 
        if (!hadtitle1&&self.brandArray.count>0) {
                [headerView addSubview:_banner1];
                hadtitle1 = YES;
        }
 
        
        
        
        //本周上新>>>搭配成套
        _weekNew = [[NSBundle mainBundle] loadNibNamed:@"YKWeekNewView" owner:self options:nil][0];
        _weekNew.frame = CGRectMake(0, _banner1.frame.origin.y + _banner1.frame.size.height, WIDHT, WIDHT*0.8);
        _weekNew.toDetailBlock = ^(void){
            //临时判断，五一之前走这个
//            if ([steyHelper validateWithStartTime:@"2018-04-24" withExpireTime:@"2018-04-30"]) {
                YKSearchVC *search = [[YKSearchVC alloc] init];
                search.hidesBottomBarWhenPushed = YES;
                UINavigationController *nav = weakSelf.tabBarController.viewControllers[1];
                search.hidesBottomBarWhenPushed = YES;
                weakSelf.tabBarController.selectedViewController = nav;
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            }else {
//                YKLinkWebVC *web = [YKLinkWebVC new];
//                web.url = weakSelf.weeknewDic[@"productUrl"];
//                web.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController pushViewController:web animated:YES];
//            }
        };
        if (!hadtitle3) {
            [headerView addSubview:_weekNew];
            hadtitle3 = YES;
        }
        
        //人气配饰
        YKHomeCrollView *psScrollView = [[NSBundle mainBundle] loadNibNamed:@"YKHomeCrollView" owner:self options:nil][0];
        psScrollView.selectionStyle = UITableViewCellEditingStyleNone;
        psScrollView.frame = CGRectMake(0, _weekNew.frame.size.height + _weekNew.frame.origin.y, WIDHT, WIDHT-40);
        if (HEIGHT!=414) {
            psScrollView.frame = CGRectMake(0, _weekNew.frame.size.height + _weekNew.frame.origin.y, WIDHT, WIDHT-20);
        }
        [psScrollView initWithType:2 productList:nil OnResponse:^{
            NSLog(@"qu");
        }];
        if (!rqps) {
            [headerView addSubview:psScrollView];
            rqps = YES;
        }
        
        //时尚穿搭
        YKRecommentTitleView  *ti3 =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][3];
        ti3.frame = CGRectMake(0, psScrollView.frame.size.height + psScrollView.frame.origin.y,WIDHT, 60);
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
        _banner2.itemSpace = -32;
        _banner2.imgCornerRadius = 0;
        _banner2.itemWidth = self.view.frame.size.width - 48;
        if (self.hotWears.count==1) {
            _banner2.itemWidth = self.view.frame.size.width -48;
            _banner2.userInteractionEnabled = YES;
            _banner2.itemSpace = 0;
        }
        _banner2.delegate = self;
        _banner2.isSearch = 2;
        _banner2.toDetailBlock = ^(NSInteger index){
            YKLinkWebVC *web = [[YKLinkWebVC alloc]init];
            web.needShare = YES;
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:weakSelf.hotWears[index]];
            web.url = dic[@"hotWearUrl"];
            dic = [NSDictionary dictionaryWithDictionary:weakSelf.hotWears[index]];
           if (web.url.length == 0) {
                return;
            }
            web.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:web animated:YES];
        };
        //        _banner1.backgroundColor = [UIColor redColor];
        if (!hadtitle11&&self.brandArray.count>0) {
            [headerView addSubview:_banner2];
            hadtitle11 = YES;
        }
        
        //精选晒图标题
        YKRecommentTitleView  *st =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][5];
        st.frame = CGRectMake(0, _banner2.frame.origin.y + _banner2.frame.size.height,WIDHT, 60);
        //        ti.backgroundColor = [UIColor redColor];
        if (!jxst&&self.layoutsArr1.count>0) {
            [headerView addSubview:st];
            jxst = YES;
        }

        //精美晒图1
        cell1 = [[NewDynamicsTableViewCell alloc]init];
        cell1.delegate = self;
        cell1.isShowInProductDetail = YES;
        cell1.hidden = NO;
        if (self.layoutsArr1.count>0) {
            cell1.layout = self.layoutsArr1[0];
            layout1 = self.layoutsArr1[0];
            cell1.frame = CGRectMake(0, st.frame.origin.y + st.frame.size.height-14, WIDHT, layout1.height);
            [cell1 reSetUI];
        }
        if (!com1&&self.layoutsArr1.count>0) {
            [headerView addSubview:cell1];
            com1 = YES;
            NSLog(@"创建--===");
        }

        //精美晒图2
        cell2 = [[NewDynamicsTableViewCell alloc]init];
        cell2.delegate = self;
        cell2.isShowInProductDetail = YES;
        cell2.hidden = NO;
        if (self.layoutsArr1.count>0) {
            cell2.layout = self.layoutsArr1[1];
            layout2 = self.layoutsArr1[1];
            cell2.frame = CGRectMake(0, cell1.frame.origin.y + cell1.frame.size.height+10, WIDHT, layout2.height);
            [cell2 reSetUI];
        }
        if (!com2&&self.layoutsArr1.count>0) {
            [headerView addSubview:cell2];
            com2 = YES;
            NSLog(@"创建--===");
        }
//       YKHomeCrollView *stScrollView = [[NSBundle mainBundle] loadNibNamed:@"YKHomeCrollView" owner:self options:nil][0];
//        stScrollView.selectionStyle = UITableViewCellEditingStyleNone;
//        stScrollView.frame = CGRectMake(0, _banner2.frame.origin.y + _banner2.frame.size.height, WIDHT, WIDHT-40);
//        if (HEIGHT!=414) {
//            stScrollView.frame = CGRectMake(0, _banner2.frame.origin.y + _banner2.frame.size.height, WIDHT, WIDHT-20);
//        }
//        [stScrollView initWithType:3 productList:nil OnResponse:^{
//            NSLog(@"qu");
//        }];
//        if (!jmst) {
//            [headerView addSubview:stScrollView];
//            jmst = YES;
//        }
        
        //精选推荐标题
        YKRecommentTitleView  *ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][0];
        ti.frame = CGRectMake(0, cell2.frame.size.height + cell2.frame.origin.y+10,WIDHT, 60);
//        ti.backgroundColor = [UIColor redColor];
        if (!hadtitle2&&self.layoutsArr1.count>0) {
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
    web.needShare = YES;
    if (cycleScrollView == _banner1) {//专题活动
        dic = [NSDictionary dictionaryWithDictionary:self.brandArray[index]];
        web.url = dic[@"specialLink"];
    }
   
    if (cycleScrollView == _banner2) {//专题活动
        dic = [NSDictionary dictionaryWithDictionary:self.hotWears[index]];
        web.url = dic[@"hotWearUrl"];
        if (web.url.length == 0) {
            return;
        }
    }
//        dic = [NSDictionary dictionaryWithDictionary:self.hotWears[index]];
//        web.url = dic[@"hotWearUrl"];
//        if (web.url.length == 0) {
//            return;
//        }
//    }
    
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
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

- (void)YKBaseScrollViewImageClick:(NSInteger)index{
    //跳转到网页
    YKLinkWebVC *web =[YKLinkWebVC new];
    web.needShare = YES;
    web.url = self.imageClickUrls[index-1];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
//    if (scrollView == self.collectionView)
//    {
//
//        if (scrollView.contentOffset.y< lastContentOffset )
//        {
//            //向上
//            [ self.navigationController setNavigationBarHidden : NO animated : YES ];
//                        NSLog(@"向上");
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"NavigationNotHidden" object:nil userInfo:nil];
//
//        } else if (scrollView. contentOffset.y >lastContentOffset )
//        {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"NavigationHidden" object:nil userInfo:nil];
//            //向下
//                        NSLog(@"向下");
//
//
//                [ self.navigationController setNavigationBarHidden : YES animated : YES ];
//        }
//
//    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
//    if (scrollView==self.collectionView) {
//        lastContentOffset = scrollView.contentOffset.y;
//    }
    
}

@end
