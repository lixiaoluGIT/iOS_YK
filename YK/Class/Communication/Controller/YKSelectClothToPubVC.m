//
//  YKSelectClothToPubVC.m
//  YK
//
//  Created by EDZ on 2018/5/8.
//  Copyright © 2018年 YK. All rights reserved.
//

//#import "YKSelectClothToPubVC.h"
//#import "CGQCollectionViewCell.h"
//#import "TopPublicVC.h"
//#import "YKNoDataView.h"
//
//@interface YKSelectClothToPubVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
//{
//    YKNoDataView *NoDataView;
//    NSInteger _pageNum;
//}
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSMutableArray *productArray;
//@end
//
//@implementation YKSelectClothToPubVC
//
//- (NSMutableArray *)productArray{
//    if (!_productArray) {
//        _productArray = [NSMutableArray array];
//    }
//    return _productArray;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self getData];
//    self.title = @"选择衣服";
//
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 20, 44);
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
//        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
//    }
//    btn.adjustsImageWhenHighlighted = NO;
//    //    btn.backgroundColor = [UIColor redColor];
//    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
//    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
//        negativeSpacer.width = -18;
//    }
//
//    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
//    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
//    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layoutView.itemSize = CGSizeMake((WIDHT-72)/2, (WIDHT-72)/2*240/140);
//
////    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-170*WIDHT/414) collectionViewLayout:layoutView];
//        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layoutView];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.collectionView];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
//    self.collectionView.hidden = YES;
//    WeakSelf(weakSelf)
//    _pageNum = 1;
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        _pageNum ++;
//        //请求更多商品
//        [[YKCommunicationManager sharedManager]getHistoryOrderToPublicWithNum:_pageNum Size:10 OnResponse:^(NSDictionary *dic) {
//            [self.collectionView.mj_footer endRefreshing];
//            NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
//            if (array.count==0) {
//                [weakSelf.collectionView.mj_footer endRefreshing];
//            }else {
//                [weakSelf.collectionView.mj_footer endRefreshing];
//                for (int i=0; i<array.count; i++) {
//                    [self.productArray addObject:array[i]];
//                }
//
//                [self.collectionView reloadData];
//            }
//        }];
//
//    }];
//
//    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
//    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"wuyifu"] statusDes:@"租过衣服才可以晒图哦～" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{
//
//    }];
//
//    NoDataView.frame = CGRectMake(0, 120+BarH, WIDHT,HEIGHT-162);
//    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
//    [self.view addSubview:NoDataView];
//    NoDataView.hidden = YES;
//
//    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
//}
//
//- (void)getData{
//    [[YKCommunicationManager sharedManager]getHistoryOrderToPublicWithNum:1 Size:10 OnResponse:^(NSDictionary *dic) {
//        _productArray = [NSMutableArray arrayWithArray:dic[@"data"]];
//        if (_productArray.count == 0) {
//            //
////            [smartHUD alertText:self.view alert:@"没有衣服可晒" delay:1.5];
//            NoDataView.hidden = NO;
//            self.collectionView.hidden = YES;
//            self.collectionView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
//        }else {
//            [self.collectionView reloadData];
//            NoDataView.hidden = YES;
//            self.collectionView.hidden = NO;
//            self.collectionView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//        }
//    }];
//}
//- (void)leftAction{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//
//    return _productArray.count;
//}
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
//    YKProduct *procuct = [[YKProduct alloc]init];
//    [procuct initWithDictionary:_productArray[indexPath.row]];
//    cell.product = procuct;
//    return cell;
//}
//
////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(16, 24, 16, 24);
//}
////设置每个item水平间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 16;
//}
//
////设置每个item垂直间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 24;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld", (long)indexPath.row);
//    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
//
//    TopPublicVC *hmpositionVC = [[TopPublicVC alloc] init];
//    hmpositionVC.clothingId = cell.goodsId;
//    hmpositionVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:hmpositionVC animated:YES];
////    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hmpositionVC];
////    [self presentViewController:nav animated:YES completion:nil];
//
////    YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
////    detail.productId = cell.goodsId;
////    detail.titleStr = cell.goodsName;
////    detail.hidesBottomBarWhenPushed = YES;
////    [self.navigationController pushViewController:detail animated:YES];
//}

////
//  YKSelectClothToPubVC.m
//  YK
//
//  Created by EDZ on 2018/5/8.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSelectClothToPubVC.h"
#import "CGQCollectionViewCell.h"
#import "TopPublicVC.h"
#import "YKNoDataView.h"
#import "YKSuitEnsureCell.h"
#import "YKPublicCell.h"

@interface YKSelectClothToPubVC ()<UITableViewDelegate, UITableViewDataSource>
{
    YKNoDataView *NoDataView;
    NSInteger _pageNum;
}

@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YKSelectClothToPubVC

- (NSMutableArray *)productArray{
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}

- (void)viewDidAppear:(BOOL)animated{
//    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

   [self getData];
    self.title = @"选择衣服";

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    //    btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }

    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-72)/2, (WIDHT-72)/2*240/140);

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    
//    self.tableView.hidden = YES;
    
    YKPublicCell *header = [[NSBundle mainBundle] loadNibNamed:@"YKPublicCell" owner:self options:nil][0];
    header.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = header;
//
//    WeakSelf(weakSelf)
//    _pageNum = 1;
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        _pageNum ++;
//        //请求更多商品
//        [[YKCommunicationManager sharedManager]getHistoryOrderToPublicWithNum:_pageNum Size:10 OnResponse:^(NSDictionary *dic) {
//            [self.tableView.mj_footer endRefreshing];
//            NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
//            if (array.count==0) {
//                [weakSelf.tableView.mj_footer endRefreshing];
//            }else {
//                [weakSelf.tableView.mj_footer endRefreshing];
//                for (int i=0; i<array.count; i++) {
//                    [self.productArray addObject:array[i]];
//                }
//
//                [self.tableView reloadData];
//            }
//        }];
//
//    }];

    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"wuyifu"] statusDes:@"租过衣服才可以晒图哦～" hiddenBtn:YES actionTitle:@"去逛逛" actionBlock:^{

    }];

    NoDataView.frame = CGRectMake(0, 120+BarH, WIDHT,HEIGHT-162);
    self.view.backgroundColor = [UIColor colorWithHexString:@"fffff"];
    [self.view addSubview:NoDataView];
    NoDataView.hidden = YES;

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
//    [self getData];
}

- (void)getData{
    
    [[YKCommunicationManager sharedManager]getHistoryOrderToPublicWithNum:1 Size:10000 OnResponse:^(NSDictionary *dic) {
        _productArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        if (_productArray.count == 0) {

            NoDataView.hidden = NO;
//            self.tableView.hidden = YES;
            self.tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        }else {
            [self.tableView reloadData];
            NoDataView.hidden = YES;
//            self.tableView.hidden = NO;
            self.tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        }
    }];
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 152;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _productArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKSuitEnsureCell *mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitEnsureCell" owner:self options:nil][0];
    YKSuit *suit = [[YKSuit alloc]init];
    [suit initWithDictionary:_productArray[indexPath.row]];
//    suit.clothingId = _productArray[indexPath.row][@"clothingId"];
//    suit.clothingPrice = _productArray[indexPath.row][@"clothingPrice"];
//    suit.clothingBrandName = _productArray[indexPath.row][@"brandName"];
//    suit.clothingImgUrl = _productArray[indexPath.row][@"clothingImgUrl"];
//    suit.clothingName = _productArray[indexPath.row][@"clothingName"];
//    suit.clothingStockType = _productArray[indexPath.row][@""];
    mycell.suit = suit;
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    YKSuitEnsureCell *mycell = (YKSuitEnsureCell *)[tableView cellForRowAtIndexPath:indexPath];
    TopPublicVC *hmpositionVC = [[TopPublicVC alloc] init];
    hmpositionVC.clothingId = mycell.suit.clothingId;
    hmpositionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hmpositionVC animated:YES];

}

@end


