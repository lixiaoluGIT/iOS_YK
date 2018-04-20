//
//  YKBrandDetailVC.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKBrandDetailVC.h"
#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"

#import "YKProductDetailHeader.h"
#import "YKBrandDetailHeader.h"
#import "CBSegmentView.h"
#import "YKProductDetailVC.h"

@interface YKBrandDetailVC ()
<UICollectionViewDelegate, UICollectionViewDataSource,ZYCollectionViewDelegate,UINavigationControllerDelegate>{
    BOOL hadMakeHeader;
    CBSegmentView *sliderSegmentView ;
    BOOL hadMakeSegment;
    UIPercentDrivenInteractiveTransition *interactiveTransition;
}
@property (nonatomic,strong)NSString *catrgoryId;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic,strong)__block YKBrandDetailHeader *scroll;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *images2;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *categotyIds;

@property (nonatomic,strong)NSMutableArray *imagesArr;
@property (nonatomic,strong)NSDictionary *brand;
@property (nonatomic,strong)NSMutableArray *secondLevelCategoryList;
@property (nonatomic,strong)NSMutableArray *productList;

@end

@implementation YKBrandDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)getDetailInfor{
    
    [[YKHomeManager sharedManager]getBrandDetailInforWithBrandId:[self.brandId integerValue] OnResponse:^(NSDictionary *dic) {
        
        //品牌
        self.brand = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"brandDetail"]];
        YKBrand *brand = [YKBrand new];
        [brand initWithDictionary:self.brand];
        _scroll.brand = brand;
        //banner图
        self.imagesArr = [NSMutableArray array];
        [self.imagesArr addObject:_scroll.brand.brandIma];
        //二级类目
        self.secondLevelCategoryList = [NSMutableArray arrayWithArray:dic[@"data"][@"secondLevelCategoryList"]];
        self.titles = [NSMutableArray array];
        self.categotyIds = [NSMutableArray array];
        self.titles = [self arrayWithArray:self.secondLevelCategoryList];
        self.categotyIds = [self brandsIdarrayWithArray:self.secondLevelCategoryList];
        //商品
        self.productList = [NSMutableArray arrayWithArray:dic[@"data"][@"productList"]];
        
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }];
}
//title
- (NSMutableArray *)arrayWithArray:(NSArray *)array{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [titles addObject:dic[@"catName"]];
    }
    return titles;
    
}
//brandId
- (NSMutableArray *)brandsIdarrayWithArray:(NSArray *)array{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [titles addObject:dic[@"catId"]];
    }
    
    return titles;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);//ios7以后右边距默认值18px，负数相当于右移，正数左移
       
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
    
    
    
    //请求数据
    [self getDetailInfor];
    
    self.images = [NSArray array];
    
    self.view.backgroundColor =[ UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-48)/2, (WIDHT-48)/2*240/150);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, WIDHT, HEIGHT+20) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
    self.collectionView.hidden = YES;
    
    self.catrgoryId = @"";
    WeakSelf(weakSelf)
    _pageNum = 1;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum ++;
        //         [weakSelf getCategoryListByBrandId:weakSelf.scroll.brand.brandId categoryId:weakSelf.catrgoryId];
        //请求更多商品
        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:self.catrgoryId sortId:@"" brandId:self.scroll.brand.brandId OnResponse:^(NSArray *array) {
            [self.collectionView.mj_footer endRefreshing];
            if (array.count==0) {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }else {
                [weakSelf.collectionView.mj_footer endRefreshing];
                for (int i=0; i<array.count; i++) {
                    [self.productList addObject:array[i]];
                }
                
                [self.collectionView reloadData];
            }
        }];
        
    }];
    
    
    _scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKBrandDetailHeader" owner:self options:nil][0];
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(3, 20, 44, 44);
    if (HEIGHT==812) {
          btn1.frame = CGRectMake(3, 44, 44, 44);
    }
    btn1.adjustsImageWhenHighlighted = NO;
    [btn1 setImage:[UIImage imageNamed:@"newback"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}


- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.tabBarController setSelectedIndex:0];
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
        self.navigationController.navigationBar.alpha = 1;
    }else {
        self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/280 ;
        
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.productList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    YKProduct *product = [[YKProduct alloc]init];
    [product initWithDictionary:self.productList[indexPath.row]];
    cell.product = product;
    return cell;
}

//头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDHT, WIDHT*0.55 +100 + 60 + _scroll.Lheight + 30);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    WeakSelf(weakSelf)
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
            headerView.backgroundColor =[UIColor whiteColor];
            ZYCollectionView * cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.55+100)];
            cycleView.imagesArr = self.imagesArr;
            cycleView.delegate  = self;
            [headerView addSubview:cycleView];
            
            _scroll.frame = CGRectMake(0, WIDHT*0.55+100,WIDHT, 30 + _scroll.Lheight);
            
            if (!hadMakeHeader) {
                [headerView addSubview:_scroll];
                hadMakeHeader = YES;
            }
            
            // sliderStyle
            if (_scroll.Lheight!=0) {
                sliderSegmentView = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, WIDHT*0.55+100 + 30 + _scroll.Lheight, self.view.frame.size.width, 55)];
                [sliderSegmentView setTitleArray:self.titles categoryIds:self.categotyIds withStyle:CBSegmentStyleSlider];
                sliderSegmentView.categotyIds = self.categotyIds;
                sliderSegmentView.titleChooseReturn = ^(NSString  *catrgoryId) {
                    _pageNum = 1;
                    weakSelf.catrgoryId = catrgoryId;
                    [weakSelf getCategoryListByBrandId:weakSelf.scroll.brand.brandId categoryId:catrgoryId];
                };
                if (!hadMakeSegment) {
                    [headerView addSubview:sliderSegmentView];
                    hadMakeSegment = YES;
                }
            }
            
            
            
            return headerView;
            
        }
        
        
    }
    
    return nil;
}
//设置大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDHT-72)/2, (WIDHT-72)/2*240/150);
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
    
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
    NSLog(@"%ld", index);
}

- (void)getCategoryListByBrandId:(NSString *)brand categoryId:(NSString *)categoryId{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:categoryId sortId:@"" brandId:self.scroll.brand.brandId OnResponse:^(NSArray *array) {
        
        [self.productList removeAllObjects];
        
        if (array.count==0) {
            [self.collectionView.mj_footer endRefreshing];
        }else {
            [self.collectionView.mj_footer endRefreshing];
            for (int i=0; i<array.count; i++) {
                [self.productList addObject:array[i]];
            }
            [self.collectionView reloadData];
        }
        
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }];
    
    //    [[YKHomeManager sharedManager]getBrandPageByCategoryWithBrandId:brand categoryId:categoryId OnResponse:^(NSDictionary *dic) {
    //        self.productList = [NSMutableArray arrayWithArray:dic[@"data"]];
    //        [self.collectionView reloadData];
    //    }];
}

@end
