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
#import "YKLoveNoDataView.h"
#import "YKSearchVC.h"

@interface YKMyLoveVC ()<UICollectionViewDelegate, UICollectionViewDataSource,DCCycleScrollViewDelegate>
{
    BOOL hadScroll;//已经添加
    BOOL hadButtons;
    BOOL hadtitle1;
    CGFloat lastContentOffset;
    YKLoveNoDataView *noDataView;
}
@property (nonatomic,strong)DCCycleScrollView *banner1;
@property (nonatomic,strong)NSString* categoryId;
//@property (nonatomic,strong)NSString* sortId;
@property (nonatomic,strong)NSString*styleId;
@property (nonatomic,strong)NSString*seasonId;
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
//三级
@property (nonatomic, strong) NSMutableArray *seasons;
@property (nonatomic, strong) NSMutableArray *seasonIds;

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

//筛选条件数据
//_seasonList = [NSArray array];
//_categoryList = [NSArray array];
//_styleList = [NSArray array];
//_elementList = [NSArray array];
//_hotTagList = [NSArray array];
//_colorList = [NSArray array];
//_updateDay = @"";
//_exitStatus = @"0";
@property (nonatomic,strong)NSMutableArray *categoryList;
@property (nonatomic,strong)NSMutableArray *seasonList;
@property (nonatomic,strong)NSMutableArray *styleList;
@property (nonatomic,strong)NSArray *hotTagList;
@property (nonatomic,strong)NSArray *colorList;
@property (nonatomic,strong)NSArray *elementList;
@property (nonatomic,strong)NSString *exitStatus;//是否在架的条件
@property (nonatomic,strong)NSString *updateDay;



@end

@implementation YKMyLoveVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UD setBool:YES forKey:@"atSearch"];
    if ([Token length] == 0) {
        [[YKUserManager sharedManager]showLoginViewOnResponse:^(NSDictionary *dic) {
            [self getData];
        }];
        return;
    }
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _seasonList = [NSMutableArray array];
    _categoryList = [NSMutableArray array];
    _styleList = [NSMutableArray array];
    _elementList = [NSArray array];
    _hotTagList = [NSArray array];
    _colorList = [NSArray array];
    _updateDay = @"";
    _exitStatus = @"0";
    
    self.productList = [NSMutableArray array];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"心愿单";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

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
    title.font = PingFangSC_Medium(kSuitLength_H(14));
    self.navigationItem.titleView = title;
    
    self.categoryId = @"";
    self.styleId = @"";
    self.seasonId = @"";
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
    _pageNum = 0;
    WeakSelf(weakSelf)
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum ++;
        //请求更多商品
        [weakSelf filterProductWithCategoryId:_categoryList styleId:_styleList seasonId:_seasonList];
//        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:self.categoryId sortId:self.sortId sytleId:self.styleId brandId:@"" OnResponse:^(NSArray *array) {
//
//            NSLog(@"--%@,---%@,---%@",self.categoryId,self.sortId,array);
//            if (array.count==0) {
//                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
//            }else {
//                [weakSelf.collectionView.mj_footer endRefreshing];
//                for (int i=0; i<array.count; i++) {
//                    [self.productList addObject:array[i]];
//                }
//
//                [self.collectionView reloadData];
//            }
//        }];
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 0;
        //请求更多商品
        [self filterProductWithCategoryId:self.categoryList styleId:self.styleList seasonId:self.seasonList];
//        [[YKSuitManager sharedManager]getCollectListOnResponse:^(NSDictionary *dic) {
//            self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
//            self.collectStatusArray = [NSMutableArray array];
//            for (int i=0; i<self.dataArray.count; i++) {
//                [self.collectStatusArray addObject:@"1"];
//            }
//            if (self.dataArray.count==0) {//显示scrollView
//
//                [self.collectionView.mj_header endRefreshing];
//
//                [self.collectionView.mj_footer endRefreshing];
//                noDataView.hidden = NO;
//            }else {
//                [self.collectionView.mj_footer endRefreshing];
//
//                [self.collectionView.mj_header endRefreshing];
//                noDataView.hidden = YES;
//                [self.collectionView reloadData];
//            }
//        }];
    
    }];
    
    //空白图
    noDataView = [[YKLoveNoDataView alloc]initWithFrame:CGRectMake(0, BarH+ kSuitLength_H(130)+kSuitLength_H(20), WIDHT, kSuitLength_H(500))];
    noDataView.hidden = YES;
    noDataView.selectClothes = ^{
        [weakSelf goToSearch];
    };
    [self.view addSubview:noDataView];
    
   
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}
- (void)getData{
    [[YKSearchManager sharedManager]getFilterDataOnResponse:^(NSDictionary *dic) {
        NSDictionary *filterData = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
        
        //一级类目
        self.secondLevelCategoryList = [NSMutableArray arrayWithArray:filterData[@"categoryList"]];
        self.titles = [NSMutableArray array];
        self.categotyIds = [NSMutableArray array];
        self.titles = [self arrayWithArray:self.secondLevelCategoryList type:2];
        self.categotyIds = [self brandsIdarrayWithArray:self.secondLevelCategoryList type:2];
        
        //二级类目
        self.thirdLevelCategoryList = [NSMutableArray arrayWithArray:filterData[@"styleList"]];
        self.sortTitles = [NSMutableArray array];
        self.sortIds = [NSMutableArray array];
        self.sortTitles = [self arrayWithArray:self.thirdLevelCategoryList type:3];
        self.sortIds = [self brandsIdarrayWithArray:self.thirdLevelCategoryList type:3];
        //季节
        self.seasons = [NSMutableArray array];
        self.seasonIds = [NSMutableArray array];
        NSMutableArray *seas = [NSMutableArray arrayWithArray:filterData[@"seasonList"]];
        self.seasons = [self arrayWithArray:seas type:4];
        self.seasonIds = [self brandsIdarrayWithArray:seas type:4];
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        [self.titleView setCategoryList:self.titles CategoryIdList:self.categotyIds sortIdList:self.sortIds sortList:self.sortTitles seasons:_seasons seasonIds:_seasonIds];
        
        [self filterProductWithCategoryId:self.categoryList styleId:self.styleList seasonId:self.seasonList];
//        [[YKSuitManager sharedManager]getCollectListOnResponse:^(NSDictionary *dic) {
//            self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
//            self.collectStatusArray = [NSMutableArray array];
//            for (int i=0; i<self.dataArray.count; i++) {
//                [self.collectStatusArray addObject:@"1"];
//            }
//            if (self.dataArray.count==0) {//显示scrollView
//
//                [self.collectionView.mj_footer endRefreshing];
//
//                [self.collectionView.mj_footer endRefreshing];
//                noDataView.hidden = NO;
//            }else {
//                [self.collectionView.mj_footer endRefreshing];
//
//                [self.collectionView.mj_footer endRefreshing];
//                noDataView.hidden = YES;
//            }
//
//            [self.collectionView reloadData];
//        }];
    }];
}

//title
- (NSMutableArray *)arrayWithArray:(NSArray *)array type:(NSInteger)type{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if (type==2) {
            [titles addObject:dic[@"categoryName"]];
        }
        if (type==3) {
            [titles addObject:dic[@"styleName"]];
        }
        if (type==4) {
            [titles addObject:dic[@"seasonName"]];
        }
        
    }
    return titles;
    
}
//brandId
- (NSMutableArray *)brandsIdarrayWithArray:(NSArray *)array type:(NSInteger)type{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if (type==2) {
            [titles addObject:dic[@"categoryId"]];
        }
        if (type==3) {
            [titles addObject:dic[@"styleId"]];
        }
        if (type==4) {
            [titles addObject:dic[@"seasonId"]];
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

    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.productList[indexPath.row] ];
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
        self.titleView.filterBlock = ^(NSString *categoryId,NSString *styleId,NSString *seasonId){
            _pageNum = 0;
            
            [weakSelf.categoryList removeAllObjects];
            [weakSelf.styleList removeAllObjects];
            [weakSelf.seasonList removeAllObjects];
    
            _seasonId = seasonId;
            _styleId = styleId;
            _categoryId = categoryId;
            
            [weakSelf.categoryList addObject:weakSelf.categoryId];
            [weakSelf.styleList addObject:weakSelf.styleId];
            [weakSelf.seasonList addObject:weakSelf.seasonId];
            
            if ([categoryId isEqual:@"0"]) {
                [weakSelf.categoryList removeAllObjects];
            }
            if ([styleId isEqual:@"0"]) {
                [weakSelf.styleList removeAllObjects];
            }
            if ([seasonId isEqual:@"0"]) {
                [weakSelf.seasonList removeAllObjects];
            }
            
            [weakSelf filterProductWithCategoryId:weakSelf.categoryList styleId:weakSelf.styleList seasonId:weakSelf.seasonList];
            
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
    
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.productId = cell.goodsId;
        detail.titleStr = cell.goodsName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)filterProductWithCategoryId:(NSArray *)Categorys styleId:(NSArray *)styles seasonId:(NSArray *)seasons{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
//    [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:CategoryId sortId:sortId sytleId:styleId  brandId:@"" OnResponse:^(NSArray *array) {
//
//        [self.productList removeAllObjects];
//
//        if (array.count==0) {
//            [self.collectionView.mj_footer endRefreshing];
//        }else {
//            [self.collectionView.mj_footer endRefreshing];
//            for (int i=0; i<array.count; i++) {
//                [self.productList addObject:array[i]];
//            }
//            [self.collectionView reloadData];
//        }
//
//        self.collectionView.hidden = NO;
//        [self.collectionView reloadData];
//    }];
//    NSArray *categoryId = @[categoryId];
//    NSArray *styleIdList = @[styleId];
//    NSArray *seasonIdList = @[_seasonId];
//    NSArray *categoryL = [NSArray array];
//    NSArray *colourIdList = [NSArray array];
//    NSArray *elementIdList = [NSArray array];
//    NSArray *labelIdList = [NSArray array];
//    NSArray *seasonIdList = [NSArray array];
//    NSArray *styleIdList = [NSArray array];
//
//    categoryL = @[CategoryId];
//    seasonIdList = @[styleId];
//    seasonIdList = @[seasonId];
   
    
    [[YKSuitManager sharedManager]filterDataWithCategoryIdList:Categorys colourIdList:_colorList elementIdList:_elementList labelIdList:_hotTagList seasonIdList:seasons styleIdList:styles updateDay:_updateDay page:_pageNum size:10 exist:_exitStatus OnResponse:^(NSDictionary *dic) {
        
        if (_pageNum==0) {
             [self.productList removeAllObjects];
        }
       
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
//
//        NSLog(@"dic===%@",dic);
        if (array.count==0) {
            if (_pageNum==0) {
                noDataView.hidden = NO;
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];
            }else {
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
            }
            
        }else {
            noDataView.hidden = YES;
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.productList addObjectsFromArray:array];
            self.collectionView.hidden = NO;
            [self.collectionView reloadData];
        }
        
        self.collectStatusArray = [NSMutableArray array];                    for (int i=0; i<self.productList.count; i++) {
                [self.collectStatusArray addObject:@"1"];
        }
            self.collectionView.hidden = NO;
            [self.collectionView reloadData];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.upBtn.alpha = 0;
}

- (void)goToSearch{
    YKSearchVC *chatVC = [[YKSearchVC alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = self.tabBarController.viewControllers[1];
    chatVC.hidesBottomBarWhenPushed = YES;
    self.tabBarController.selectedViewController = nav;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
