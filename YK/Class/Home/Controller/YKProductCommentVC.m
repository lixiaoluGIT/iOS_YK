//
//  YKProductCommentVC.m
//  YK
//
//  Created by edz on 2018/5/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKProductCommentVC.h"
#import "NewDynamicsLayout.h"
#import "DynamicsModel.h"

#import "YKBaseScrollView.h"

#import "YKSelectClothToPubVC.h"
#import "YKLinkWebVC.h"
#import "NewDynamicsTableViewCell.h"

@interface YKProductCommentVC ()
<NewDynamicsCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UISegmentedControl * segment;

@property (nonatomic,strong)YKBaseScrollView *cycleView;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *clickImageUrls;
@property (nonatomic, nonnull,strong)NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic,nonnull,strong)NSMutableArray *layoutsArr;

@end

@implementation YKProductCommentVC


- (NSMutableArray *)dataArray{
    if (_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)layoutsArr{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"全部评论";
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
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
    [self setup];
    
    _pageNum = 1;
  
    //请求数据
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

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshData{
    //请求列表信息
    [[YKCommunicationManager sharedManager]requestCommunicationListWithNum:_pageNum Size:10 clothingId:self.clothingId OnResponse:^(NSDictionary *dic) {
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
            //字典转模型
            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];//字典转模型
            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
            [self.layoutsArr addObject:layout];
        }
        
        
        [self.dynamicsTable reloadData];
        
    }];
}
//上拉加载
- (void)getMoreData{
    //请求列表信息
    [[YKCommunicationManager sharedManager]requestCommunicationListWithNum:_pageNum Size:10 clothingId:self.clothingId OnResponse:^(NSDictionary *dic) {
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




-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [SVProgressHUD dismiss];
//    [JRMenuView dismissAllJRMenu];
}
- (void)setup
{
  [self.view addSubview:self.dynamicsTable];
}
#pragma mark - 下啦刷新
- (void)dragDownToLoadMoreData
{
    [[YKCommunicationManager sharedManager]requestCommunicationListWithNum:2 Size:10 clothingId:self.clothingId OnResponse:^(NSDictionary *dic) {
        [self.dynamicsTable.mj_header endRefreshing];
        NSArray * dataArray = [NSArray arrayWithArray:dic[@"data"]];
        
        [self.layoutsArr removeAllObjects];
        for (id dict in dataArray) {
            //字典转模型
            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];//字典转模型
            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
            [self.layoutsArr addObject:layout];
        }
        
        [self.dynamicsTable reloadData];
    }];
}

#pragma mark - getter
-(UITableView *)dynamicsTable
{
    if (!_dynamicsTable) {
        _dynamicsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _dynamicsTable.dataSource = self;
        _dynamicsTable.delegate = self;
        
        _dynamicsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
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
    return layout.height+115;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDynamicsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewDynamicsTableViewCell"];
    cell.isShowOnComments = YES;
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
    
    //点赞
    [[YKCommunicationManager sharedManager]setLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        //把当前userid加入点赞数组
        [model.fabulous addObject:[YKUserManager sharedManager].user.userId];
        //刷新当前cell
        [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];

}
//取消点赞
-(void)DidClickCancelThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;
    
    [[YKCommunicationManager sharedManager]cancleLikeCommunicationWithArticleId:model.articleId OnResponse:^(NSDictionary *dic) {
        //把当前userid加入点赞数组
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
@end
