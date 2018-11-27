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
#import "YKFilterHeaderView.h"
#import "YKFilterUpHeaderView.h"
#import "YKFilterView.h"

@interface YKSearchVC ()<UICollectionViewDelegate, UICollectionViewDataSource,DCCycleScrollViewDelegate>
{
    BOOL hadScroll;//已经添加
    BOOL hadButtons;
    BOOL hadtitle1;
    CGFloat lastContentOffset;
    __block YKFilterUpHeaderView *upView;
    __block YKFilterView *filterView;
    __block YKFilterHeaderView *headerView;
    NSInteger page;
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
// 标签数据
@property (nonatomic, strong) GetNewFilterOutPutDto *filterModel;

//筛选条件数据
@property (nonatomic,strong)NSArray *categoryIds;
@property (nonatomic,strong)NSArray *seasonIds;
@property (nonatomic,strong)NSString *updateDay;
@property (nonatomic,strong)NSArray *colors;
@property (nonatomic,strong)NSArray *hotTags;
@property (nonatomic,strong)NSArray *styles;
@property (nonatomic,strong)NSArray *elements;
@property (nonatomic,strong)NSString *exitStatus;//是否在架的条件


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
     layoutView.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 66);
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
    
    [self creatFilterView];
    
    _pageNum = 1;
    WeakSelf(weakSelf)
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum ++;
        //请求更多商品
        [self filterClothes];
//        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:self.categoryId sortId:self.sortId sytleId:self.styleId brandId:@"" OnResponse:^(NSArray *array) {
//
//            NSLog(@"--%@,---%@,---%@",self.categoryId,self.sortId,array);
//            if (array.count==0) {
//                [weakSelf.collectionView.mj_footer endRefreshing];
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
  
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [self getData];
    [self initUpBtn];
    
    
    //浮框
    upView  = [[YKFilterUpHeaderView alloc]init];
    upView.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(47));
    upView.hidden = YES;
    upView.filterActionDid = ^(void){
        [weakSelf showFilterView];
    };
    upView.changeTypeBlock = ^(BOOL isSelected){
        _pageNum = 1;
        headerView.isSelected = isSelected;
        if (isSelected) {
            self.exitStatus = @"0";
        }else {
            self.exitStatus = @"1";
        }
        [self filterClothes];
    
    };
    [self.view addSubview:upView];
    
    //衣位导视图
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"衣位导视图"];
    [image sizeToFit];
    image.frame = [UIApplication sharedApplication].keyWindow.frame;
    if (![UD boolForKey:@"hadap"]) {
        [[UIApplication sharedApplication].keyWindow addSubview:image];
        [UD setBool:YES forKey:@"hadap"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        image.hidden = YES;
    }];
    [image setUserInteractionEnabled:YES];
    [image addGestureRecognizer:tap];
    
//    //获取筛选数据
//    [self getFilterData];
    
    //筛选条件初始化
    _seasonIds = [NSArray array];
    _categoryIds = [NSArray array];
    _styles = [NSArray array];
    _elements = [NSArray array];
    _hotTags = [NSArray array];
    _colors = [NSArray array];
    _updateDay = @"";
    _exitStatus = @"0";
}

- (void)getFilterData{
 
    //获取筛选数据
    [[YKSearchManager sharedManager]getFilterDataOnResponse:^(NSDictionary *dic) {
        NSDictionary *filterData = [NSDictionary dictionaryWithDictionary:dic[@"data"]];

        self.filterModel = [GetNewFilterOutPutDto objectWithKeyValues:filterData];

        filterView.houseFilterOutPutDto = self.filterModel ;

        //赋值
        [filterView initDataSourseWithType:@"3" AndSelectTag:2000];
    }];
    //弹框赋值
    
    //测试数据
    NSDictionary *d = @{@"categoryName":@"连衣裙",@"id":@"categoryId"};//品类
    NSDictionary *d1 = @{@"seasonName":@"冬",@"key":@"seasonId"};//季节
    NSDictionary *d2 = @{@"colourName":@"黑红",@"key":@"colourId"};//颜色
    NSDictionary *d3 = @{@"Name":@"7天内",@"key":@"time"};//上新时间
    NSDictionary *d4 = @{@"lableName":@"美式休闲",@"key":@"lableId"};//热门标签
    NSDictionary *d5 = @{@"styleName":@"优雅",@"key":@"styleId"};//风格
    NSDictionary *d6 = @{@"elementName":@"针织",@"key":@"elementId"};//元素
    
    NSArray *a = @[d,d,d,d,d];
    NSArray *a1 = @[d1,d1,d1];
     NSArray *a2 = @[d2,d2,d2];
     NSArray *a3 = @[d3,d3,d3,d3];
     NSArray *a4 = @[d4,d4,d4];
     NSArray *a5 = @[d5,d5,d5];
     NSArray *a6 = @[d6,d6,d6];
   
    NSDictionary *dic = @{@"categoryList":a,
                          @"colourList":a1,
                          @"elementList":a2,
                          @"labelList":a3,
                          @"seasonList":a4,
                          @"styleList":a5,
                          @"updateDay":a6};
//    
//    self.filterModel = [GetNewFilterOutPutDto objectWithKeyValues:dic];
//
//    filterView.houseFilterOutPutDto = self.filterModel ;
//
//   //赋值
//    [filterView initDataSourseWithType:@"3" AndSelectTag:2000];
}

- (void)initUpBtn{
    self.upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upBtn.frame = CGRectMake(WIDHT-kSuitLength_H(45), HEIGHT-120, kSuitLength_H(35),kSuitLength_H(35));
    if (HEIGHT==812) {
        self.upBtn.frame = CGRectMake(WIDHT-kSuitLength_H(45), HEIGHT-250, kSuitLength_H(35), kSuitLength_H(35));
    
    }
    self.upBtn.alpha = 0;
    [self.upBtn setBackgroundImage:[UIImage imageNamed:@"置顶图标"] forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:self.upBtn];
//    [self.view bringSubviewToFront:self.upBtn];
    [self.upBtn addTarget:self action:@selector(up) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)up{
    [self.collectionView scrollToTopAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        if (scrollView == self.collectionView)
        {
            if (self.collectionView.contentOffset.y>360) {
                self.upBtn.alpha = (self.collectionView.contentOffset.y-360)/360;
            }else {
                self.upBtn.alpha = 0;
            }
        }
    
    if (scrollView == self.collectionView)
    {
        
        if (scrollView. contentOffset.y > WIDHT/4+kSuitLength_H(10)+kSuitLength_H(13)){
            //浮框出现
            upView.hidden = NO;
            
        }else {
            upView.hidden = YES;
        }
        
        if(scrollView.contentOffset.y > lastContentOffset && scrollView.contentOffset.y>kSuitLength_H(600)) {
            //向上推
            [[NSNotificationCenter defaultCenter]postNotificationName:@"up" object:nil userInfo:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT-kSuitLength_V(50));
            }];
        }
     
        if (scrollView.contentOffset.y< lastContentOffset )
        {
            //向下
            [UIView animateWithDuration:0.3 animations:^{
                self.collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT-kSuitLength_V(100));
            }];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"down" object:nil userInfo:nil];
            
            
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
        
        [self getFilterData];
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
    NSDictionary *dic;
    if (indexPath.row<self.productList.count) {
       dic = [NSDictionary dictionaryWithDictionary:self.productList[indexPath.row] ];
    }
    
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

//    return CGSizeMake(self.view.frame.size.width, (WIDHT-48)/3*2+40+kSuitLength_H(160));
    return CGSizeMake(WIDHT, WIDHT/4+kSuitLength_H(10)+kSuitLength_H(13) + kSuitLength_H(47));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(self.view.frame.size.width, 0);
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
        
        //风格
        YKStyleView *styleView = [[YKStyleView alloc]init];
        styleView.styleArray = self.styleArray;
        styleView.frame = CGRectMake(0, 0, WIDHT, WIDHT/4+kSuitLength_H(10)+kSuitLength_H(13));
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
        
//        //筛选三个title
//        headerView = [[YKFilterHeaderView alloc]init];
//        headerView.frame = CGRectMake(0, styleView.bottom, WIDHT, kSuitLength_H(47));
//        headerView.filterActionDid = ^(void){
//            [weakSelf showFilterView];
//        };
//        //切换商品类型（全部或在架）
//        headerView.changeTypeBlock = ^(BOOL isSelected){
//            _pageNum = 1;
//            upView.isSelected = isSelected;
//            if (isSelected) {
//                self.exitStatus = @"0";
//            }else {
//                self.exitStatus = @"1";
//            }
//            [self filterClothes];
//        };
        if (!hadButtons) {
            //筛选三个title
            headerView = [[YKFilterHeaderView alloc]init];
            headerView.frame = CGRectMake(0, styleView.bottom, WIDHT, kSuitLength_H(47));
            headerView.filterActionDid = ^(void){
                [weakSelf showFilterView];
            };
            //切换商品类型（全部或在架）
            headerView.changeTypeBlock = ^(BOOL isSelected){
                _pageNum = 1;
                upView.isSelected = isSelected;
                if (isSelected) {
                    self.exitStatus = @"0";
                }else {
                    self.exitStatus = @"1";
                }
                [self filterClothes];
            };
            [head addSubview:headerView];
            hadButtons = YES;
        }
        
//        if (self.titles.count!=0) {
//            self.titleView =  [[NSBundle mainBundle] loadNibNamed:@"YKSearchHeader" owner:self options:nil][0];
//            self.titleView.frame = CGRectMake(0,styleView.frame.size.height + styleView.frame.origin.y,head.frame.size.width, kSuitLength_H(160));
//            [self.titleView setCategoryList:self.titles CategoryIdList:self.categotyIds sortIdList:self.sortIds sortList:self.sortTitles];
//            //筛选
//            self.titleView.filterBlock = ^(NSString *categoryId,NSString *sortId){
//                _pageNum = 1;
//                _sortId = sortId;
//                _categoryId = categoryId;
//                [weakSelf filterProductWithCategoryId:categoryId sortId:sortId styleId:weakSelf.styleId];
//            };
//            if (!hadButtons) {
//                [head addSubview:self.titleView];
//                hadButtons = YES;
//            }
//
//        }
//
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

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    if (scrollView==self.collectionView) {
        lastContentOffset = scrollView.contentOffset.y;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.upBtn.alpha = 0;
}

- (void)creatFilterView{
    WeakSelf(weakSelf)
    filterView = [[YKFilterView alloc] initWithFrame:CGRectMake(screen_width, 0, 0, HEIGHT)];
    
    filterView.tabColor = [UIColor whiteColor];
    
    filterView.menuHeight = self.view.frame.size.height - kSuitLength_V((20 + 40 + 20) / 2);
    filterView.userInteractionEnabled = YES;
    
    
    //更多的回调
    filterView.moreSelectedCallback = ^(NSArray *types, NSArray *seasons, NSArray *opentimes, NSArray *colors, NSArray *hotTags, NSArray *styles, NSArray *elements) {
        _pageNum = 1;
        _categoryIds = types;
        _seasonIds = seasons;
        if (opentimes.count!=0) {
            _updateDay = opentimes[0];
        }else {
            _updateDay = @"";
        }
        _colors = colors;
        _hotTags = hotTags;
        _styles = styles;
        _elements = elements;
        
        [weakSelf filterClothes];
    };
    //点击空白的回调
    [filterView setDidSelectedCallback:^(NSString *circleId, NSString *content, NSInteger tag){
        _pageNum = 1;
        [weakSelf filterClothes];
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:filterView];
    
}

- (void)showFilterView{
    //赋值
    [filterView showDropDownWithTag:20003];
}

- (void)filterClothes{
    [[YKSearchManager sharedManager]filterDataWithCategoryIdList:_categoryIds colourIdList:_colors elementIdList:_elements labelIdList:_hotTags seasonIdList:_seasonIds styleIdList:_styles updateDay:_updateDay  page:_pageNum size:10 exist:_exitStatus OnResponse:^(NSDictionary *dic) {
        
        if ([dic[@"status"] intValue] != 200) {
            [smartHUD alertText:kWindow alert:dic[@"msg"] delay:1.2];
            [self performSelector:@selector(scrollToTop) withObject:nil afterDelay:0.8];
            return ;
        }
        
        if (_pageNum==1) {
            [self.productList removeAllObjects];
        }
        
        NSArray *list = [NSArray arrayWithArray:dic[@"data"]];
        if (list.count==0) {
            [self.collectionView.mj_footer endRefreshing];
        }else {
            [self.collectionView.mj_footer endRefreshing];
            [self.productList addObjectsFromArray:list];
        }
        if (_pageNum!=1) {
            [self.collectionView reloadData];
            return;
        }else {
            [self performSelector:@selector(scrollToTop) withObject:nil afterDelay:0.5];
            
        }
        self.collectionView.hidden = NO;
//        [self.collectionView reloadData];
    }];
}

- (void)scrollToTop{
   
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
    [self.collectionView reloadData];
}
@end
