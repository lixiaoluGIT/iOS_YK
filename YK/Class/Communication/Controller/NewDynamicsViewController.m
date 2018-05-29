//
//  NewDynamicsViewController.m
//  LooyuEasyBuy
//
//  Created by LXL on 2018/5/3.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "NewDynamicsViewController.h"
#import "NewDynamicsViewController+Delegate.h"
#import "NewDynamicsLayout.h"
#import "DynamicsModel.h"
#import "YKPublicCell.h"
#import "TopPublicVC.h"

#import "SDTimeLineRefreshHeader.h"//下拉刷新控件
#import "YKBaseScrollView.h"

#import "YKSelectClothToPubVC.h"
#import "YKLinkWebVC.h"

@interface NewDynamicsViewController ()<YKBaseScrollViewDelete>

@property(nonatomic,strong)SDTimeLineRefreshHeader * refreshHeader;
@property(nonatomic,strong)UISegmentedControl * segment;

@property (nonatomic,strong)YKBaseScrollView *cycleView;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *clickImageUrls;
@property (nonatomic, nonnull,strong)NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageNum;


@end

@implementation NewDynamicsViewController

- (NSMutableArray *)imageArray{
    if (_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)clickImageUrls{
    if (_clickImageUrls) {
        _clickImageUrls = [NSMutableArray array];
    }
    return _clickImageUrls;
}

- (NSMutableArray *)dataArray{
    if (_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    //有新的数据自动刷新
    if ([UD boolForKey:@"hadNews"] == YES) {
        _pageNum = 1;
        [self refreshData];
        [UD setBool:NO forKey:@"hadNews"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"朋友圈";
    [self setup];
//    [self dragUpToLoadMoreData];
//    [self dragDownToLoadMoreData];
//    [self.view addSubview:self.commentInputTF];
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment0" ofType:@"plist"];
//    NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    _pageNum = 1;
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    //请求数据
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.3];
    WeakSelf(weakSelf)
    self.dynamicsTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [weakSelf refreshData];
    }];
    
    self.dynamicsTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [weakSelf getMoreData];
    }];
    
//    [self.layoutsArr removeAllObjects];
//    for (id dict in dataArray) {
//        //字典转模型
//        DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
//        NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
//        [self.layoutsArr addObject:layout];
//    }
//    [self.dynamicsTable reloadData];
    
//    [self performSelector:@selector(refresh) afterDelay:0.1];
//    //外观代理
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//
//    //修改标题颜色
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [navigationBar setTitleTextAttributes:dict];
//
////    navigationBar.barTintColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
////    navigationBar.tintColor = [UIColor whiteColor];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //我要晒图按钮
    
    publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publicBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [self.view addSubview:publicBtn];
    [publicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_bottom).offset(-100);
        if (HEIGHT==812) {
            make.top.equalTo(self.view.mas_bottom).offset(-150);
        }
    }];
    [publicBtn addTarget:self action:@selector(Public) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)loadData{
    [self getData];
    [self refreshData];
}
- (NSMutableArray *)getImageArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"loopPicUrl"]];
    }
    return imageArray;
}
- (NSMutableArray *)getImageClickArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"loopPicLinkUrl"]];
    }
    return imageArray;
}

- (void)getData{
    [[YKCommunicationManager sharedManager]requestCommunicationImgListOnResponse:^(NSDictionary *dic) {
//        NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"][@"articleVOs"]];
        NSMutableArray *totalArray = [NSMutableArray arrayWithArray:dic[@"data"][@"articleLoopPicVOS"]];
        _imageArray = [self getImageArray:totalArray];
        _clickImageUrls = [self getImageClickArray:totalArray];
        _cycleView.imagesArr = _imageArray;
        [self.dynamicsTable.mj_header endRefreshing];
//        [self.layoutsArr removeAllObjects];
//        if (currentArray.count==0) {
//            [self.dynamicsTable.mj_footer endRefreshing];
//        }else {
//            [self.dynamicsTable.mj_footer endRefreshing];
//            _dataArray = [NSMutableArray arrayWithArray:currentArray];
//
//        }
//
//        for (id dict in _dataArray) {
//            //字典转模型
//            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];//字典转模型
//            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
//            [self.layoutsArr addObject:layout];
//        }
//
//        [self.dynamicsTable reloadData];
    }];
}

- (void)refreshData{
    //请求列表信息
    [[YKCommunicationManager sharedManager]requestCommunicationListWithNum:_pageNum Size:10 clothingId:@"-1" OnResponse:^(NSDictionary *dic) {
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
    [[YKCommunicationManager sharedManager]requestCommunicationListWithNum:_pageNum Size:10 clothingId:@"-1" OnResponse:^(NSDictionary *dic) {
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
- (void)Public{
    if ([Token length] == 0) {
        [smartHUD alertText:self.view alert:@"请先登录" delay:1.5];
        return;
    }
    YKSelectClothToPubVC *sele = [[YKSelectClothToPubVC alloc]init];
    sele.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sele animated:YES];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sele];
//        [self presentViewController:nav animated:YES completion:nil];
//    TopPublicVC *hmpositionVC = [[TopPublicVC alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hmpositionVC];
//    [self presentViewController:nav animated:YES completion:nil];
}
- (void)refresh{
     [self.dynamicsTable reloadData];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
    CGRect frame = _commentInputTF.frame;
    frame.origin.y = self.view.frame.size.height;
    _commentInputTF.frame = frame;
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = _commentInputTF.frame;
    frame.origin.y = keyBoardFrame.origin.y - 45;
    _commentInputTF.frame = frame;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [SVProgressHUD dismiss];
    [JRMenuView dismissAllJRMenu];
}
- (void)setup
{
    [self.view addSubview:self.dynamicsTable];
    
}
#pragma mark - 下啦刷新
- (void)dragDownToLoadMoreData
{
    [[YKCommunicationManager sharedManager]requestCommunicationListWithNum:2 Size:10 clothingId:@"-1" OnResponse:^(NSDictionary *dic) {
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
#pragma mark - 上拉加载更多数据
- (void)dragUpToLoadMoreData
{
//    [self.dynamicsTable.footer beginRefreshing];
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    // 设置文字
    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中......" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];

    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];

    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];

    // 设置footer
    self.dynamicsTable.mj_footer = footer;
}
- (void)loadMoreData
{
    //执行事件
        
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment0" ofType:@"plist"];
//        NSArray * dataArray = [NSArray arrayWithContentsOfFile:plistPath];
//
//        for (id dict in dataArray) {
//            DynamicsModel * model = [DynamicsModel modelWithDictionary:dict];
//            NewDynamicsLayout * layout = [[NewDynamicsLayout alloc] initWithModel:model];
//            [self.layoutsArr addObject:layout];
//        }
//        [self.dynamicsTable reloadData];
        [self.dynamicsTable.mj_footer endRefreshingWithNoMoreData];
    
    [self.dynamicsTable.mj_header endRefreshing];
}
#pragma mark - getter
-(UITableView *)dynamicsTable
{
    if (!_dynamicsTable) {
        _dynamicsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-170) style:UITableViewStylePlain];
        _dynamicsTable.dataSource = self;
        _dynamicsTable.delegate = self;
        _dynamicsTable.separatorStyle = UITableViewCellSeparatorStyleNone;

        _cycleView = [[YKBaseScrollView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.58)];
        
//        _cycleView.imagesArr = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612217&di=f0a200f1da4510619be8ef47cc9cd74c&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0193dd57ad44300000018c1b6ea932.jpg%402o.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612218&di=7e6eadd43105fdd712e9187d5d4f703b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01b5f55780cfca0000018c1b5326f9.jpg%402o.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612215&di=bf7a100c20dca202bd1f2427f6cc229b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01973759a45b87a801211d25e6b311.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525692612213&di=377404f36aefd024c6a4eec3f3ce8a2b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01649759a8c8f6a8012028a9e6dd1a.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525693155271&di=6c5c0ff1c2de534ef6a90e6e12acc46b&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014bcd585e1c14a801219c7738e3c4.png%402o.jpg"];
        _cycleView.imagesArr = _imageArray;
        _cycleView.delegate = self;
        
        _dynamicsTable.tableHeaderView = _cycleView;
    
        [_dynamicsTable registerClass:[NewDynamicsTableViewCell class] forCellReuseIdentifier:@"NewDynamicsTableViewCell"];
        if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
            _dynamicsTable.estimatedRowHeight = 0;
        }

//        UITapGestureRecognizer * tableViewGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//            [_commentInputTF resignFirstResponder];
//        }];
//
//        tableViewGesture.cancelsTouchesInView = NO;
//        [_dynamicsTable addGestureRecognizer:tableViewGesture];
    }
    return _dynamicsTable;
}

- (void)YKBaseScrollViewImageClick:(NSInteger)index{
    //跳转到网页
    YKLinkWebVC *web =[YKLinkWebVC new];
    web.url = _clickImageUrls[index-1];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if (scrollView == self.dynamicsTable)
    {
        
        if (scrollView.contentOffset.y< lastContentOffset )
        {
            //向上
            [ self.navigationController setNavigationBarHidden : NO animated : YES ];
        } else if (scrollView. contentOffset.y >lastContentOffset )
        {
            //向下
            [ self.navigationController setNavigationBarHidden : YES animated : YES ];
        }
        
        CGFloat sectionHeaderHeight = 69; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}
-(UITextField *)commentInputTF
{
    if (!_commentInputTF) {
        _commentInputTF = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 45)];
        _commentInputTF.backgroundColor = [UIColor lightGrayColor];
        _commentInputTF.delegate = self;
        _commentInputTF.textColor = [UIColor whiteColor];
    }
    return _commentInputTF;
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    if (scrollView==_dynamicsTable) {
         lastContentOffset = scrollView.contentOffset.y;
    }
    
}


@end
