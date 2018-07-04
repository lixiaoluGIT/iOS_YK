//
//  YKActivityDetailVC.m
//  YK
//
//  Created by edz on 2018/6/14.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKActivityDetailVC.h"
#import "YKActivityheader.h"
#import "NewDynamicsTableViewCell.h"
#import "YKComheader.h"
#import "YKSelectClothToPubVC.h"
#import "YKProductDetailVC.h"
#import "YKActivityDetailVC.h"

@interface YKActivityDetailVC ()<UITableViewDelegate,UITableViewDataSource,NewDynamicsCellDelegate>
@property (nonatomic,strong)YKActivityheader *acH;
@property (nonatomic, nonnull,strong)NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation YKActivityDetailVC

- (void)viewWillDisappear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.activity.activityTitle stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
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
     [self.view addSubview:self.dynamicsTable];
    
    
    _pageNum = 1;
    
    [self refreshData];
    WeakSelf(weakSelf)
    self.dynamicsTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [weakSelf refreshData];
    }];
    
    self.dynamicsTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [weakSelf getMoreData];
    }];
}
//上拉加载
- (void)getMoreData{
    //请求列表信息
    [[YKCommunicationManager sharedManager]requestCommunicationListWithCommunicationType:0 Num:_pageNum Size:10 clothingId:@"" activityId:_activity.activityId OnResponse:^(NSDictionary *dic) {
        NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"][@"articleVOS"]];
        
        [self.dynamicsTable.mj_footer endRefreshing];
        
        NSMutableArray *array = [NSMutableArray array];
        if (currentArray.count==0) {
            [self.dynamicsTable.mj_footer endRefreshing];
            return ;
        }else {
            [self.dynamicsTable.mj_footer endRefreshing];
            for (int i=0; i<currentArray.count; i++) {
                [array addObject:currentArray[i]];
            }
            
            //            [self.dynamicsTable reloadData];
        }
        
        for (id dict in array) {
            //字典转模型
            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];//字典转模型
            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
            [self.layoutsArr addObject:layout];
        }
        
        [self.dynamicsTable reloadData];
    }];
}

- (void)refreshData{
    //请求列表信息
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [[YKCommunicationManager sharedManager]requestCommunicationListWithCommunicationType:0 Num:1 Size:10 clothingId:@"-1" activityId:_activity.activityId OnResponse:^(NSDictionary *dic) {
        NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"][@"articleVOS"]];
        [self.dynamicsTable.mj_header endRefreshing];
        [self.layoutsArr removeAllObjects];
        if (currentArray.count==0) {
            [self.dynamicsTable.mj_footer endRefreshing];
        }else {
            [self.dynamicsTable.mj_footer endRefreshing];
            _dataArray = [NSMutableArray arrayWithArray:currentArray];

        }
    
        for (id dict in _dataArray) {
            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];//字典转模型
            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
            [self.layoutsArr addObject:layout];
        }

        [self.dynamicsTable reloadData];

    }];
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)dataArray{
    if (_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
#pragma mark - getter
-(UITableView *)dynamicsTable
{
    if (!_dynamicsTable) {
        _dynamicsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT) style:UITableViewStylePlain];
        _dynamicsTable.dataSource = self;
        _dynamicsTable.delegate = self;
        _dynamicsTable.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIView *headerView = [[UIView alloc]init];
        headerView.frame = CGRectMake(0, 0, WIDHT, 400);
//        YKActivityheader
        _acH = [[NSBundle mainBundle]loadNibNamed:@"YKActivityheader" owner:nil options:nil][0];
        _acH.frame = CGRectMake(0, 0, WIDHT, 400);
        _acH.activity = _activity;
        WeakSelf(weakSelf)
        _acH.attendActivityBlock = ^(NSString *activityId){
            if ([Token length] == 0) {
                [smartHUD alertText:weakSelf.view alert:@"请先登录" delay:1.5];
                return;
            }
            YKSelectClothToPubVC *sele = [[YKSelectClothToPubVC alloc]init];
            sele.activityId = activityId;
            sele.activityName = weakSelf.activity.activityTitle;
            sele.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:sele animated:YES];
        };
        [headerView addSubview:_acH];
        
        _dynamicsTable.tableHeaderView = headerView;
        
        [_dynamicsTable registerClass:[NewDynamicsTableViewCell class] forCellReuseIdentifier:@"NewDynamicsTableViewCell"];
        if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
            _dynamicsTable.estimatedRowHeight = 0;
        }
    }
    return _dynamicsTable;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    return layout.height+100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDynamicsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewDynamicsTableViewCell"];
//    cell.isShowOnComments = YES;
    cell.layout = self.layoutsArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - NewDynamiceCellDelegate
-(void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUser:(NSString *)userId
{
    NSLog(@"点击了用户");
}
-(void)DidClickMoreLessInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    layout.model.isOpening = !layout.model.isOpening;
    [layout resetLayout];
    CGRect cellRect = [self.dynamicsTable rectForRowAtIndexPath:indexPath];
    
    [self.dynamicsTable reloadData];
    
    if (cellRect.origin.y < self.dynamicsTable.contentOffset.y + 64) {
        [self.dynamicsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
-(void)DidClickGrayViewInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSLog(@"点击了灰色区域");
}
//点赞
-(void)DidClickThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    
    if ([Token length]==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:2];
        return;
    }
    //点赞
    cell.pl.userInteractionEnabled = NO;
    [[YKCommunicationManager sharedManager]setLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        //把当前userid加入点赞数组
        cell.pl.userInteractionEnabled = YES;
        [model.fabulous addObject:[YKUserManager sharedManager].user.userId];
        //刷新当前cell
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}
//取消点赞
-(void)DidClickCancelThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    if ([Token length]==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:2];
        return;
    }
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    cell.pl.userInteractionEnabled = NO;
    [[YKCommunicationManager sharedManager]cancleLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        //把当前userid加入点赞数组
        cell.pl.userInteractionEnabled = YES;
        [model.fabulous removeObject:[YKUserManager sharedManager].user.userId];
        //刷新当前cell
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    //    NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.fabulous];
    //    WS(weakSelf);
    //    [newThumbArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSDictionary * thumbDic = obj;
    //        if ([thumbDic[@"userid"] isEqualToString:@"12345678910"]) {
    //            [newThumbArr removeObject:obj];
    //            model.fabulous = [newThumbArr copy];
    //            [layout resetLayout];
    //            [weakSelf.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //            *stop = YES;
    //        }
    //    }];
}

-(void)DidClickSpreadInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSLog(@"点击了推广");
}
//关注
- (void)DidConcernInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    [[YKCommunicationManager sharedManager]setConcernWithUserId:model.userId OnResponse:^(NSDictionary *dic) {
        __block BOOL isContain = NO;
        [[YKCommunicationManager sharedManager].concernArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *s = [NSString stringWithFormat:@"%@",obj];
            NSString *s1 = [NSString stringWithFormat:@"%@",model.userId];
            if ([s isEqual:s1]) {
                isContain = YES;
                NSLog(@"%@-索引%d",obj, (int)idx);
            }
        }];
        if (!isContain) {
            [[YKCommunicationManager sharedManager].concernArray addObject:model.userId];
        }
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
//取消关注
- (void)DidCancelConcernInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    [[YKCommunicationManager sharedManager]cancleConcernWithUserId:model.userId OnResponse:^(NSDictionary *dic) {
  
        __block  NSMutableArray *cArray = [NSMutableArray array];
        [[YKCommunicationManager sharedManager].concernArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *s = [NSString stringWithFormat:@"%@",obj];
            NSString *s1 = [NSString stringWithFormat:@"%@",model.userId];
            [cArray addObject:s];
            if ([s isEqual:s1]) {
                [cArray removeObject:s1];
                NSLog(@"%@-索引%d",obj, (int)idx);
            }
            [YKCommunicationManager sharedManager].concernArray = [NSMutableArray arrayWithArray:cArray];
        }];
        
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)DidClickDeleteInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    if ([model.classify isEqual:@"1"]) {
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.productId = model.clothingId;
        detail.titleStr = @"商品详情";
        //    detail.productId = @"438";
        [self.navigationController pushViewController:detail animated:YES];
    } else  if ([model.classify isEqual:@"1"]) {
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.productId = model.clothingId;
        detail.titleStr = @"商品详情";
        //    detail.productId = @"438";
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.productId = model.clothingId;
        detail.titleStr = @"商品详情";
        //    detail.productId = @"438";
        [self.navigationController pushViewController:detail animated:YES];
    }
}
@end
