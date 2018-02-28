//
//  YKHomeVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//
#define h [UIScreen mainScreen].bounds.size.height
#define w [UIScreen mainScreen].bounds.size.width
#import "YKHomeVC.h"
#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "WMHCustomScroll.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"
#import "YyxHeaderRefresh.h"
#import "YKProductDetailVC.h"
#import "YKBrandDetailVC.h"
#import "YKMessageVC.h"
#import "YKShareVC.h"
#import "YKLoginVC.h"
#import "YKLinkWebVC.h"


@interface YKHomeVC ()<UICollectionViewDelegate, UICollectionViewDataSource,ZYCollectionViewDelegate,WMHCustomScrollViewDelegate>
{
    BOOL hadAppearCheckVersion;
    BOOL hadtitle1;
    BOOL hadtitle2;
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

@property (strong, nonatomic) YyxHeaderRefresh *refresh;
@property (nonatomic,strong)YKScrollView *scroll;
@end

@implementation YKHomeVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //分享弹框
    [[YKHomeManager sharedManager]showAleartViewToShare];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    
    //请求数据
    self.images2 = [NSArray array];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]}];
    self.view.backgroundColor =[ UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-72)/2, (w-72)/2*240/180);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layoutView];
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
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self dd];
    }];
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
    releaseButton.frame = CGRectMake(0, 25, 25, 25);
    [releaseButton addTarget:self action:@selector(toMessage) forControlEvents:UIControlEventTouchUpInside];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
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
        NSArray *array = [NSArray arrayWithArray:dic[@"data"][@"imgList"]];
        self.imagesArr = [self getImageArray:array];
        self.imageClickUrls = [NSArray array];
        self.imageClickUrls = [self getImageClickUrlsArray:array];
        self.brandArray = [NSArray arrayWithArray:dic[@"data"][@"brandList"]];
        self.productArray = [NSMutableArray arrayWithArray:dic[@"data"][@"productList"][@"list"]];

//        hadtitle1 = YES;
        if (self.brandArray.count!=0) {
            _scroll.brandArray = [NSMutableArray arrayWithArray:self.brandArray];
        }
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
    
    if (scrollView.contentOffset.y>100) {
        self.refresh.hidden = YES;
    }else {
        self.refresh.hidden = NO;
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
    
    return CGSizeMake(WIDHT, WIDHT*0.55 +200 +60);
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
        ZYCollectionView * cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.55)];
        cycleView.imagesArr = self.imagesArr;
        cycleView.delegate  = self;
        cycleView.placeHolderImageName = @"banner.jpg";
        [headerView addSubview:cycleView];
        WeakSelf(weakSelf)
        
        //品牌
        _scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollView" owner:self options:nil][0];
        _scroll.frame = CGRectMake(0, WIDHT*0.55,WIDHT, 200);
        [_scroll resetUI];
//        if (self.brandArray.count!=0) {
//            _scroll.brandArray = [NSMutableArray arrayWithArray:self.brandArray];
//        }
        
        _scroll.clickALLBlock = ^(){
            YKALLBrandVC *brand = [YKALLBrandVC new];
            brand.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:brand animated:YES];
        };
        _scroll.toDetailBlock = ^(NSString *brandId,NSString *brandName){
            NSLog(@"所点品牌ID:%@",brandId);
            YKBrandDetailVC *brand = [YKBrandDetailVC new];
            brand.titleStr = brandName;
            brand.hidesBottomBarWhenPushed = YES;
            brand.brandId = brandId;
            
            [weakSelf.navigationController pushViewController:brand animated:YES];
        };
        
        //
        if (!hadtitle1) {
            [headerView addSubview:_scroll];
            hadtitle1 = YES;
        }
        
        
        
        
        //推荐标题
        YKRecommentTitleView  *ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][0];
        ti.frame = CGRectMake(0, WIDHT*0.55+200,WIDHT, 60);
        
        if (!hadtitle2) {
            [headerView addSubview:ti];
            hadtitle2 = YES;
        }
        
        return headerView;
    }
    
    return nil;
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

- (void)ZYCollectionViewClick:(NSInteger)index {
    //跳转到网页
    YKLinkWebVC *web =[YKLinkWebVC new];
    web.url = self.imageClickUrls[index];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    
}


@end
