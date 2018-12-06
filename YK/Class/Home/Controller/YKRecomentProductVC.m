//
//  YKRecomentProductVC.m
//  YK
//
//  Created by edz on 2018/12/5.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKRecomentProductVC.h"

#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"

#import "YKProductDetailHeader.h"
#import "YKBrandDetailHeader.h"
#import "CBSegmentView.h"
#import "YKProductDetailVC.h"
#import "YKSPDetailVC.h"
#import "YKRecProductHeaderView.h"

@interface YKRecomentProductVC ()
<UICollectionViewDelegate, UICollectionViewDataSource,ZYCollectionViewDelegate,UINavigationControllerDelegate>{
    BOOL hadMakeHeader;
    CBSegmentView *sliderSegmentView ;
    BOOL hadMakeSegment;
    UIPercentDrivenInteractiveTransition *interactiveTransition;
    YKRecProductHeaderView * _acH;
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

@implementation YKRecomentProductVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)getDetailInfor{
    
//    [[YKHomeManager sharedManager]getBrandDetailInforWithBrandId:[self.brandId integerValue] OnResponse:^(NSDictionary *dic) {
//
//        [self.collectionView reloadData];
//    }];
}
//title

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
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
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
//    title.text = self.title;
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
//    title.font = PingFangSC_Medium(kSuitLength_H(14));
//
//    self.navigationItem.titleView = title;
    
    
    
    //请求数据
    [self getDetailInfor];
    
    self.images = [NSArray array];
    
    self.view.backgroundColor =[ UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-30)/2, (WIDHT-30)/2*240/140);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT+20) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
    self.collectionView.hidden = NO;
    
    self.catrgoryId = @"";
    WeakSelf(weakSelf)
    _pageNum = 1;
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        _pageNum ++;
//       //请求更多商品
//        [[YKHomeManager sharedManager]requestForMoreProductsWithNumPage:_pageNum typeId:self.catrgoryId sortId:@"" sytleId:@"0" brandId:self.scroll.brand.brandId OnResponse:^(NSArray *array) {
//            [self.collectionView.mj_footer endRefreshing];
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
        
//    }];
    
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.title = [NSString stringWithFormat:@"%@",dic[@"title"]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Medium(kSuitLength_H(14));
    
    self.navigationItem.titleView = title;
    
    //请求商品
    NSArray *clothingIdList = [NSArray arrayWithArray:dic[@"clothingIdList"]];
    [[YKSearchManager sharedManager]filterDataWithCategoryIdList:nil colourIdList:nil elementIdList:nil labelIdList:nil seasonIdList:nil styleIdList:nil updateDay:nil page:0 size:20 exist:0 clothingIdList:clothingIdList OnResponse:^(NSDictionary *dic) {
        self.productList = [NSMutableArray arrayWithArray:dic[@"data"]];
        [self.collectionView reloadData];
    }];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.productList.count;
//    return 100;
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
    return CGSizeMake(WIDHT, kSuitLength_H(300));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
//            headerView.backgroundColor =[UIColor redColor];
            _acH = [[YKRecProductHeaderView alloc]init];
             [ _acH initWithImage:[NSString stringWithFormat:@"%@",_dic[@"img2"]] content:[NSString stringWithFormat:@"%@",_dic[@"introduce"]]];
            headerView.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(300));
            _acH.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(300));
            if (!hadMakeHeader) {
                [headerView addSubview:_acH];
                hadMakeHeader = YES;
            }
           
            return headerView;
            
        }
        
        
    }
    
    return nil;
}
//设置大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDHT-30)/2, (WIDHT-30)/2*240/140);
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

- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
}

@end
