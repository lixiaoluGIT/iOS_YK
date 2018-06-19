//
//  YKSPVC.m
//  YK
//
//  Created by edz on 2018/6/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKSPVC.h"
#import "CGQCollectionViewCell.h"
#import "YKProductDetailVC.h"
#import "YKSPDetailVC.h"

@interface YKSPVC ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSInteger _pageNum;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *productList;
@end

@implementation YKSPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-72)/2, (WIDHT-72)/2*240/140);
    layoutView.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 66);
    //layoutView.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 150);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-120) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
   
    WeakSelf(weakSelf)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum=1;
        //请求更多商品
        [[YKSearchManager sharedManager]getPSListWithPage:_pageNum Size:10 OnResponse:^(NSDictionary *dic) {
            [self.productList removeAllObjects];
            NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"data"]];
            [self.collectionView.mj_header endRefreshing];
            if (array.count==0) {
                [weakSelf.collectionView.mj_header endRefreshing];
            }else {
                [weakSelf.collectionView.mj_header endRefreshing];
                for (int i=0; i<array.count; i++) {
                    [self.productList addObject:array[i]];
                }
                
                [self.collectionView reloadData];
            }
            
        }];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum ++;
        //请求更多商品
        [[YKSearchManager sharedManager]getPSListWithPage:_pageNum Size:10 OnResponse:^(NSDictionary *dic) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"data"]];
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
    [self getDataList];
}

- (void)getDataList{
    [[YKSearchManager sharedManager]getPSListWithPage:_pageNum Size:10 OnResponse:^(NSDictionary *dic) {
        self.productList = [NSMutableArray arrayWithArray:dic[@"data"]];
        [self.collectionView reloadData];
    }];
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
    return CGSizeMake(0,0);
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
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    YKSPDetailVC *detail = [[YKSPDetailVC alloc]init];
    detail.isSP = YES;
    detail.productId = cell.goodsId;
    detail.titleStr = cell.goodsName;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
