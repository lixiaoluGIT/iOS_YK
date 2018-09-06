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

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"人气配饰";
    _pageNum = 1;
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
  
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Semibold(20);
    self.navigationItem.titleView = title;
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-30)/2, (WIDHT-30)/2*240/140);
    layoutView.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 66);
    //layoutView.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 150);
    
   
    if (self.isfromhome) {
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layoutView];
    }else {
         self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-120) collectionViewLayout:layoutView];
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
   
    WeakSelf(weakSelf)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum=1;
        //请求更多商品
        [[YKSearchManager sharedManager]getPSListWithPage:_pageNum Size:10 sid:_sid OnResponse:^(NSDictionary *dic) {
            [self.productList removeAllObjects];
            NSMutableArray *array;
            if ([_sid intValue] == 1 || [_sid intValue] == 2) {
                array = [NSMutableArray arrayWithArray:dic[@"data"][@"content"]];
            }else {
                array = [NSMutableArray arrayWithArray:dic[@"data"]];
            }
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
        [[YKSearchManager sharedManager]getPSListWithPage:_pageNum Size:10 sid:_sid OnResponse:^(NSDictionary *dic) {
            NSMutableArray *array;
            if ([_sid intValue] == 1 || [_sid intValue] == 2) {
               array = [NSMutableArray arrayWithArray:dic[@"data"][@"content"]];
            }else {
                array = [NSMutableArray arrayWithArray:dic[@"data"]];
            }
            
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
    [[YKSearchManager sharedManager]getPSListWithPage:_pageNum Size:10 sid:_sid OnResponse:^(NSDictionary *dic) {
        if ([_sid intValue] == 1 || [_sid intValue] == 2) {
            self.productList = [NSMutableArray arrayWithArray:dic[@"data"][@"content"]];
        }else {
            self.productList = [NSMutableArray arrayWithArray:dic[@"data"]];
        }
        
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
    YKSPDetailVC *detail = [[YKSPDetailVC alloc]init];
    detail.isSP = YES;
    detail.productId = cell.goodsId;
    detail.titleStr = cell.goodsName;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
