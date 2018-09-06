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
#import "DCCycleScrollView.h"
#import "YKProductAdCell.h"
#import "YKLinkWebVC.h"
#import "YKStyleView.h"

@interface YKSearchVC ()<UICollectionViewDelegate, UICollectionViewDataSource,DCCycleScrollViewDelegate>
{
    BOOL hadScroll;//已经添加
    BOOL hadButtons;
    BOOL hadtitle1;
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


@end

@implementation YKSearchVC

- (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [UD setBool:YES forKey:@"atSearch"];
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
    layoutView.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 66);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
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
  
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [self getData];
    [self initUpBtn];
    
}

- (void)initUpBtn{
    self.upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upBtn.frame = CGRectMake(WIDHT, HEIGHT-150, 35, 35);
    [self.upBtn setBackgroundImage:[UIImage imageNamed:@"置顶图标"] forState:UIControlStateNormal];
    [self.view addSubview:self.upBtn];
    [self.view bringSubviewToFront:self.upBtn];
    [self.upBtn addTarget:self action:@selector(up) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)up{
    [self.collectionView scrollToTopAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        if (scrollView == self.collectionView&&HEIGHT!=814)
        {
            if (self.collectionView.contentOffset.y>360) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.upBtn.frame = CGRectMake(WIDHT-60, HEIGHT-150, 35, 35);
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.upBtn.frame = CGRectMake(WIDHT, HEIGHT-150, 0, 0);
                }];
            }
        }
  
}
- (void)getData{
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
    //加广告位
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.productList[indexPath.row] ];
    if ([dic[@"adUrl"] isEqual:[NSNull null]]) {//正常商品
        CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
        YKProduct *procuct = [[YKProduct alloc]init];
        [procuct initWithDictionary:self.productList[indexPath.row]];
        cell.product = procuct;
        return cell;
    }//展示广告
    YKProductAdCell *cell = (YKProductAdCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YKProductAdCell" forIndexPath:indexPath];
    [cell.imageC sd_setImageWithURL:[NSURL URLWithString:dic[@"clothingImgUrl"]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    [cell.imageC setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
}

//头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(self.view.frame.size.width, (WIDHT-48)/3*2+50+170);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf(weakSelf)
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        
        //风格
        YKStyleView *styleView = [[YKStyleView alloc]init];
        styleView.styleArray = self.styleArray;
        styleView.frame = CGRectMake(0, 0, WIDHT, (WIDHT-48)/3*2+50);
        if (hadScroll) {
            [head addSubview:styleView];
            hadScroll = NO;
        }
        styleView.toDetailBlock = ^(NSString *styleId,NSString *styleName){//筛选风格
            weakSelf.styleId = styleId;
            NSLog(@"传过来的Id==%@",styleId);
            weakSelf.pageNum = 1;
            [weakSelf filterProductWithCategoryId:_categoryId sortId:_sortId styleId:styleId];
        };

        if (self.titles.count!=0) {
            self.titleView =  [[NSBundle mainBundle] loadNibNamed:@"YKSearchHeader" owner:self options:nil][0];
            self.titleView.frame = CGRectMake(0,styleView.frame.size.height + styleView.frame.origin.y,head.frame.size.width, 170);
            [self.titleView setCategoryList:self.titles CategoryIdList:self.categotyIds sortIdList:self.sortIds sortList:self.sortTitles];
            //筛选
            self.titleView.filterBlock = ^(NSString *categoryId,NSString *sortId){
                _pageNum = 1;
                _sortId = sortId;
                _categoryId = categoryId;
                [weakSelf filterProductWithCategoryId:categoryId sortId:sortId styleId:weakSelf.styleId];
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
    if ([dic[@"adUrl"] isEqual:[NSNull null]]) {//正常商品
        CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.productId = cell.goodsId;
        detail.titleStr = cell.goodsName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else {//广告，到h5
        YKLinkWebVC *web =[YKLinkWebVC new];
        web.url = dic[@"adUrl"];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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

@end
