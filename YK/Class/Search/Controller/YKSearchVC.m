//
//  YKSearchVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#define h [UIScreen mainScreen].bounds.size.height
#define w [UIScreen mainScreen].bounds.size.width
#import "YKSearchVC.h"
#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKSearchHeader.h"
#import "YKProductDetailVC.h"
#import "YKBrand.h"
#import "YKBrandDetailVC.h"

@interface YKSearchVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL hadScroll;//已经添加
    BOOL hadButtons;
 }

@property (nonatomic,strong)NSString* categoryId;
@property (nonatomic,strong)NSString* sortId;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)YKScrollView *scroll;
@property (nonatomic, strong)YKSearchHeader *titleView;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSMutableDictionary *cellDic;

//二级
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *categotyIds;
//三级
@property (nonatomic, strong) NSMutableArray *sortTitles;
@property (nonatomic, strong) NSMutableArray *sortIds;

@property (nonatomic,strong)NSMutableArray *imagesArr;
@property (nonatomic,strong)NSDictionary *brand;
@property (nonatomic,strong)NSArray *brandArray;
@property (nonatomic,strong)NSMutableArray *secondLevelCategoryList;
@property (nonatomic,strong)NSMutableArray *thirdLevelCategoryList;
@property (nonatomic,strong)NSMutableArray *productList;


@end

@implementation YKSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]}];
    self.categoryId = @"";
    self.sortId = @"";
    self.cellDic = [[NSMutableDictionary alloc] init];

       self.view.backgroundColor =[ UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((w-72)/2, (w-72)/2*240/180);
    layoutView.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 66);
    //layoutView.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 150);
    
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

//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _pageNum = 0;
//        [self getData];
//    }];
    _pageNum = 1;
    WeakSelf(weakSelf)
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum ++;
        //请求更多商品
        
        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:self.categoryId sortId:self.sortId brandId:@"" OnResponse:^(NSArray *array) {
            
            NSLog(@"--%@,---%@,---%@",self.categoryId,self.sortId,array);
            if (array.count==0) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.collectionView.mj_footer endRefreshing];
                for (int i=0; i<array.count; i++) {
                    [self.productList addObject:array[i]];
                }
                
                [self.collectionView reloadData];
            }
        }];
        }];
  

    //获取数据
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [self getData];
    
}

- (void)getData{
    [[YKSearchManager sharedManager]getSelectClothPageDataWithNum:1 Size:2 OnResponse:^(NSDictionary *dic) {
        
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        //品牌
        self.brandArray = [NSArray arrayWithArray:dic[@"data"][@"brandList"]];
        
        hadScroll = YES;
        //二级类目
        self.secondLevelCategoryList = [NSMutableArray arrayWithArray:dic[@"data"][@"secondLevelCategoryList"]];
        self.titles = [NSMutableArray array];
        self.categotyIds = [NSMutableArray array];
        self.titles = [self arrayWithArray:self.secondLevelCategoryList type:2];
        self.categotyIds = [self brandsIdarrayWithArray:self.secondLevelCategoryList type:2];
        //三级类目
        self.thirdLevelCategoryList = [NSMutableArray arrayWithArray:dic[@"data"][@"sortList"]];
        self.sortTitles = [NSMutableArray array];
        self.sortIds = [NSMutableArray array];
        self.sortTitles = [self arrayWithArray:self.thirdLevelCategoryList type:3];
        self.sortIds = [self brandsIdarrayWithArray:self.thirdLevelCategoryList type:3];
        
        //商品
        self.productList = [NSMutableArray arrayWithArray:dic[@"data"][@"productList"][@"list"]];
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }];
}

//title
- (NSMutableArray *)arrayWithArray:(NSArray *)array type:(NSInteger)type{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if (type==2) {
            [titles addObject:dic[@"catName"]];
        }
        if (type==3) {
            [titles addObject:dic[@"clothingSortName"]];
        }
        
    }
    return titles;
    
}
//brandId
- (NSMutableArray *)brandsIdarrayWithArray:(NSArray *)array type:(NSInteger)type{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if (type==2) {
            [titles addObject:dic[@"catId"]];
        }
        if (type==3) {
            [titles addObject:dic[@"clothingSortId"]];
        }
    }
    
    return titles;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.productList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    YKProduct *procuct = [[YKProduct alloc]init];
    [procuct initWithDictionary:self.productList[indexPath.row]];
    cell.product = procuct;
    return cell;
}

//头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//    if (section==0) {
        return CGSizeMake(self.view.frame.size.width, 280 + 190);
//    }else {
//        return CGSizeMake(self.view.frame.size.width, 125);
//    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(weakSelf)
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        
        //品牌
        _scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollView" owner:self options:nil][0];
        _scroll.frame = CGRectMake(0,0,WIDHT, 280);
        if (self.brandArray.count!=0) {
             _scroll.brandArray = [NSMutableArray arrayWithArray:self.brandArray];
        }
       _scroll.clickALLBlock = ^(){
            YKALLBrandVC *brand = [YKALLBrandVC new];
            brand.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:brand animated:YES];
        };
        _scroll.toDetailBlock = ^(NSString *brandId,NSString *brandName){
            NSLog(@"所点品牌ID:%@",brandId);
            YKBrandDetailVC *brand = [YKBrandDetailVC new];
            brand.hidesBottomBarWhenPushed = YES;
            brand.brandId = brandId;
            brand.titleStr = brandName;
            
            [weakSelf.navigationController pushViewController:brand animated:YES];
        };
        if (hadScroll) {
            [head addSubview:_scroll];
            hadScroll = NO;
        }
        
       
      
        
        if (self.titles.count!=0) {
            self.titleView =  [[NSBundle mainBundle] loadNibNamed:@"YKSearchHeader" owner:self options:nil][0];
            self.titleView.frame = CGRectMake(0, 280,head.frame.size.width, 190);
            [self.titleView setCategoryList:self.titles CategoryIdList:self.categotyIds sortIdList:self.sortIds sortList:self.sortTitles];
            //筛选
            self.titleView.filterBlock = ^(NSString *categoryId,NSString *sortId){
                _pageNum = 1;
                _sortId = sortId;
                _categoryId = categoryId;
                [weakSelf filterProductWithCategoryId:categoryId sortId:sortId];
            };
            if (!hadButtons) {
                [head addSubview:self.titleView];
                hadButtons = YES;
            }
            
        }
        
            return head;
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
    
}

- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
}

- (void)filterProductWithCategoryId:(NSString *)CategoryId sortId:(NSString *)sortId{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:CategoryId sortId:sortId brandId:@"" OnResponse:^(NSArray *array) {
        
        [self.productList removeAllObjects];

        if (array.count==0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
}


@end
