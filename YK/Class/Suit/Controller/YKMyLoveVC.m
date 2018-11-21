//
//  YKMyLoveVC.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#define h [UIScreen mainScreen].bounds.size.height
#define w [UIScreen mainScreen].bounds.size.width

#import "YKMyLoveVC.h"

#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKSearchHeader.h"
#import "YKProductDetailVC.h"
#import "YKBrand.h"
#import "YKBrandDetailVC.h"
#import "DCCycleScrollView.h"
#import "YKProductAdCell.h"
#import "YKLinkWebVC.h"
#import "YKStyleView.h"
#import "YKFilterHeaderView.h"
#import "YKFilterView.h"

@interface YKMyLoveVC ()<UICollectionViewDelegate, UICollectionViewDataSource,DCCycleScrollViewDelegate>
{
    BOOL hadScroll;//已经添加
    BOOL hadButtons;
    BOOL hadtitle1;
    CGFloat lastContentOffset;
}
@property (nonatomic,strong)DCCycleScrollView *banner1;
@property (nonatomic,strong)NSString* categoryId;
@property (nonatomic,strong)NSString* sortId;
@property (nonatomic,strong)NSString*styleId;
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

@property (nonatomic,strong)NSMutableArray *styleArray;

@property (nonatomic,strong)NSMutableArray *imagesArr;
@property (nonatomic,strong)NSDictionary *brand;
@property (nonatomic,strong)NSArray *brandArray;
@property (nonatomic,strong)NSMutableArray *secondLevelCategoryList;
@property (nonatomic,strong)NSMutableArray *thirdLevelCategoryList;
@property (nonatomic,strong)NSMutableArray *productList;
@property (nonatomic,strong)UIButton *upBtn;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)NSMutableArray *collectStatusArray;



@end

@implementation YKMyLoveVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UD setBool:YES forKey:@"atSearch"];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]}];
    self.categoryId = @"";
    self.sortId = @"";
    self.styleId = @"0";
    self.cellDic = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor =[ UIColor whiteColor];
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-30)/2, (w-30)/2*240/140);
   
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, self.view.bounds.size.height - kSuitLength_H(50)) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    layoutView.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 66);
//    layoutView.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 66);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YKProductAdCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YKProductAdCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
    self.collectionView.hidden = YES;
    _pageNum = 1;
    WeakSelf(weakSelf)
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum ++;
        //请求更多商品
        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:self.categoryId sortId:self.sortId sytleId:self.styleId brandId:@"" OnResponse:^(NSArray *array) {
            
            NSLog(@"--%@,---%@,---%@",self.categoryId,self.sortId,array);
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
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        //请求更多商品
        [weakSelf getData];
    }];
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [self getData];

//    self.titleView =  [[NSBundle mainBundle] loadNibNamed:@"YKSearchHeader" owner:self options:nil][0];
//    self.titleView.frame = CGRectMake(0,0,WIDHT, kSuitLength_H(130));
//    self.origialFrame = self.titleView.frame;
//    //筛选
//    self.titleView.filterBlock = ^(NSString *categoryId,NSString *sortId){
//        _pageNum = 1;
//        _sortId = sortId;
//        _categoryId = categoryId;
//        [weakSelf filterProductWithCategoryId:categoryId sortId:sortId styleId:weakSelf.styleId];
//    };
//    [self.view addSubview:self.titleView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//
////    NSLog(@"%lf",scrollView.contentOffset.y);
//    if (scrollView == self.collectionView)
//    {
//
////        向上推
//
//        if (scrollView.contentOffset.y>lastContentOffset) {
//
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"up" object:nil userInfo:nil];
//            self.collectionView.frame = CGRectMake(0, kSuitLength_H(130), self.view.bounds.size.width, HEIGHT-kSuitLength_V(150));
//
//             self.titleView.frame = CGRectMake(0,0, WIDHT, kSuitLength_H(130));
//
//        }
//
//
//
//
//    if (scrollView.contentOffset.y< lastContentOffset )
//        {
////            //向下
////            [UIView animateWithDuration:0.25 animations:^{
//                self.collectionView.frame = CGRectMake(0, kSuitLength_H(130), self.view.bounds.size.width, HEIGHT-kSuitLength_V(100));
//                self.titleView.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(130));
////            }];
//
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"down" object:nil userInfo:nil];
//
//
//        }
//
////
//    }
    
}
- (void)getData{
    [[YKSuitManager sharedManager]getCollectListOnResponse:^(NSDictionary *dic) {
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        self.collectStatusArray = [NSMutableArray array];
        for (int i=0; i<self.dataArray.count; i++) {
            [self.collectStatusArray addObject:@"1"];
        }
        if (self.dataArray.count==0) {//显示scrollView
//            self.tableView.hidden = YES;
//            NoDataView.hidden = NO;
//            buttom.hidden = YES;
//            _addCCView.hidden = YES;
//            [self.tableView setEditing:NO animated:YES];
//            [self resetMasonrys];
//            self.goodsIsClips = NO;
        }else {
//            self.tableView.hidden = NO;
//            buttom.hidden = NO;
//            _addCCView.hidden=  NO;
//            NoDataView.hidden = YES;
            [self.collectionView reloadData];
        }
    }];
    [[YKSearchManager sharedManager]getSelectClothPageDataWithNum:1 Size:2 OnResponse:^(NSDictionary *dic) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        //配饰数组
        self.styleArray = [NSMutableArray arrayWithArray:dic[@"data"][@"clothingStyles"]];
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
        
         [self.titleView setCategoryList:self.titles CategoryIdList:self.categotyIds sortIdList:self.sortIds sortList:self.sortTitles];
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
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.dataArray[indexPath.row] ];
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    YKProduct *procuct = [[YKProduct alloc]init];
    [procuct initWithDic:dic];
    cell.isInLoveVC = YES;
    cell.product = procuct;
    cell.changeCollectStatus = ^(NSInteger status){
        if (status==0) {//取消喜欢
            [self.collectStatusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        if (status==1) {//喜欢
            [self.collectStatusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil]];
    };
      [cell showLoveBtn:self.collectStatusArray[indexPath.row]];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    //    return CGSizeMake(self.view.frame.size.width, (WIDHT-48)/3*2+40+kSuitLength_H(160));
    return CGSizeMake(WIDHT, kSuitLength_H(130));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(weakSelf)
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footer;
    }
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        
        self.titleView =  [[NSBundle mainBundle] loadNibNamed:@"YKSearchHeader" owner:self options:nil][0];
        self.titleView.frame = CGRectMake(0,0,WIDHT, kSuitLength_H(130));
        self.origialFrame = self.titleView.frame;
        //筛选
        self.titleView.filterBlock = ^(NSString *categoryId,NSString *sortId){
            _pageNum = 1;
            _sortId = sortId;
            _categoryId = categoryId;
            [weakSelf filterProductWithCategoryId:categoryId sortId:sortId styleId:weakSelf.styleId];
        };
        
        if (!hadScroll) {
            [head addSubview:self.titleView];
            hadScroll = YES;
        }
        [self.titleView setUserInteractionEnabled:YES];
        
        return head;
    }
    
    return nil;
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.productList[indexPath.row] ];
   
        CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.productId = cell.goodsId;
        detail.titleStr = cell.goodsName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
}

- (void)filterProductWithCategoryId:(NSString *)CategoryId sortId:(NSString *)sortId styleId:(NSString *)styleId{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:CategoryId sortId:sortId sytleId:styleId  brandId:@"" OnResponse:^(NSArray *array) {
        
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
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    if (scrollView==self.collectionView) {
        lastContentOffset = scrollView.contentOffset.y;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.upBtn.alpha = 0;
}

@end
