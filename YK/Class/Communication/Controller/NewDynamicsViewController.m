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
#import "YKComheader.h"
#import "YKActivityDetailVC.h"
#import "YKActivity.h"

@interface NewDynamicsViewController ()<YKBaseScrollViewDelete>

@property(nonatomic,strong)SDTimeLineRefreshHeader * refreshHeader;
@property(nonatomic,strong)UISegmentedControl * segment;

@property (nonatomic,strong)YKBaseScrollView *cycleView;
@property (nonatomic,strong)YKComheader *comHeader;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *clickImageUrls;
@property (nonatomic, nonnull,strong)NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic,assign)CommunicationType CommunicationType;
@property (nonatomic,strong)YKActivity *activity;
@property (nonatomic,strong)NSDictionary *headerActivity;
@property (nonatomic,strong)NSMutableArray *a;

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
        [self refreshData:_CommunicationType];
        [UD setBool:NO forKey:@"hadNews"];
    }
    [[YKCommunicationManager sharedManager]getUserConcernListOnResponse:^(NSDictionary *dic) {
       
    }];
    //收缩动画
    publicBtn.hidden = NO;
//    [UIView animateWithDuration:0.25 animations:^{
//        publicBtn.frame = CGRectMake(kSuitLength_H(110), HEIGHT-kSuitLength_V(110), WIDHT-kSuitLength_H(220), kSuitLength_H(44));
//    }];
    
   
 }

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //收缩动画
    [JRMenuView dismissAllJRMenu];
    publicBtn.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:@"__cust_event_2"];
    
    [ self.navigationController setNavigationBarHidden : NO animated : YES ];
    
    self.title = @"朋友圈";
    [self setup];
    _CommunicationType = SELECTED;
    
    _pageNum = 1;

    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    self.dynamicsTable.hidden = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
    WeakSelf(weakSelf)
    self.dynamicsTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
        _pageNum = 1;
        [weakSelf refreshData:_CommunicationType];
        if (WIDHT==414) {
//            [weakSelf.dynamicsTable setContentOffset:CGPointMake(0, 320) animated:YES];
        }
        
    }];
    
    self.dynamicsTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [weakSelf getMoreData];
    }];

    //我要晒图按钮
    publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publicBtn setBackgroundImage:[UIImage imageNamed:@"我要晒图"] forState:UIControlStateNormal];
    [self.view addSubview:publicBtn];
    publicBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(138)/2, HEIGHT-kSuitLength_H(200), kSuitLength_H(138), kSuitLength_H(40));
    if (HEIGHT==812) {
        publicBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(138)/2, HEIGHT-kSuitLength_H(300), kSuitLength_H(138), kSuitLength_H(40));
    }else
    if (WIDHT==320) {
          publicBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(138)/2, HEIGHT-kSuitLength_H(230), kSuitLength_H(138), kSuitLength_H(40));
    }else
        if (WIDHT==414) {
           publicBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(138)/2, HEIGHT-kSuitLength_H(200), kSuitLength_H(138), kSuitLength_H(40));
        }
    else {
            publicBtn.frame = CGRectMake(WIDHT/2-kSuitLength_H(138)/2, HEIGHT-kSuitLength_H(250), kSuitLength_H(138), kSuitLength_H(40));
        }
    [publicBtn addTarget:self action:@selector(Public) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)loadData{
    [[YKCommunicationManager sharedManager]getUserConcernListOnResponse:^(NSDictionary *dic) {
        [self getData];
        [self refreshData:_CommunicationType];
    }];
    
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
        self.dynamicsTable.hidden = NO;
        NSMutableArray *totalArray = [NSMutableArray arrayWithArray:dic[@"data"][@"articleLoopPicVOS"]];
        _headerActivity = [NSDictionary dictionaryWithDictionary:dic[@"data"][@"communityActivity"]];
        _imageArray = [self getImageArray:totalArray];
        _clickImageUrls = [self getImageClickArray:totalArray];
        _a = [NSMutableArray array];
        [_a addObject:_headerActivity[@"mainDiagram"]];
        _activity = [[YKActivity alloc]init];
        [_activity initWithDic:_headerActivity];
        _cycleView.imagesArr = _a;
        _comHeader.imageArray = _imageArray;
        _comHeader.clickUrlArray = _clickImageUrls;
        [self.dynamicsTable.mj_header endRefreshing];
    }];
}

- (void)refreshData:(CommunicationType)CommunicationType{
    //请求列表信息
    [[YKCommunicationManager sharedManager]requestCommunicationListWithCommunicationType:CommunicationType Num:_pageNum Size:10 clothingId:@"-1" activityId:@"" OnResponse:^(NSDictionary *dic) {
        NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"][@"articleVOS"]];
        [self.dynamicsTable.mj_header endRefreshing];
        [self.layoutsArr removeAllObjects];
        [_dataArray removeAllObjects];
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
//上拉加载
- (void)getMoreData{
    //请求列表信息
    [[YKCommunicationManager sharedManager]requestCommunicationListWithCommunicationType:_CommunicationType  Num:_pageNum Size:10 clothingId:@"-1" activityId:@"" OnResponse:^(NSDictionary *dic) {
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
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
////    [JRMenuView dismissAllJRMenu];
//}

- (void)setup
{
    [self.view addSubview:self.dynamicsTable];
    
}

#pragma mark - getter
-(UITableView *)dynamicsTable
{
    if (!_dynamicsTable) {
        _dynamicsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-170) style:UITableViewStylePlain];
        _dynamicsTable.dataSource = self;
        _dynamicsTable.delegate = self;
        _dynamicsTable.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIView *headerView = [[UIView alloc]init];
        headerView.frame = CGRectMake(0, 0, WIDHT, self.view.frame.size.width*0.58 + kSuitLength_H(115));
        _cycleView = [[YKBaseScrollView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.58)];
        _cycleView.imagesArr = _a;
        _cycleView.delegate = self;
        [headerView addSubview:_cycleView];
        
        _comHeader = [[NSBundle mainBundle]loadNibNamed:@"YKComheader" owner:nil options:nil][0];
        _comHeader.frame = CGRectMake(0, _cycleView.frame.size.height + _cycleView.frame.origin.y, WIDHT, kSuitLength_H(115));
        WeakSelf(weakSelf)
        _comHeader.changeCommunicationTypeBlock = ^(CommunicationType CommunicationType){
            [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
            _pageNum = 1;
            _CommunicationType = CommunicationType;
            [weakSelf.layoutsArr removeAllObjects];
            [weakSelf.dataArray removeAllObjects];
            [weakSelf refreshData:CommunicationType];
            if (WIDHT==414) {
//                [weakSelf.dynamicsTable setContentOffset:CGPointMake(0, 320) animated:YES];
            }
        };
        _comHeader.clickIndexToWebViewBlock = ^(NSString *webUrl){
            YKLinkWebVC *web =[YKLinkWebVC new];
            web.url = webUrl;
            web.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:web animated:YES];
        };
        _comHeader.imageArray = _imageArray;
        if (_clickImageUrls.count>0) {
             _comHeader.clickUrlArray = _clickImageUrls;
        }
       [headerView addSubview:_comHeader];
        
        _dynamicsTable.tableHeaderView = headerView;
    
        [_dynamicsTable registerClass:[NewDynamicsTableViewCell class] forCellReuseIdentifier:@"NewDynamicsTableViewCell"];
        if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
            _dynamicsTable.estimatedRowHeight = 0;
        }
    }
    return _dynamicsTable;
}

- (void)YKBaseScrollViewImageClick:(NSInteger)index{
    
    YKActivityDetailVC *detail =[YKActivityDetailVC new];
    detail.activity = _activity;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if (scrollView == self.dynamicsTable)
    {

        if (scrollView.contentOffset.y< lastContentOffset )
        {
            //向上
//            [ self.navigationController setNavigationBarHidden : NO animated : YES ];
        } else if (scrollView. contentOffset.y >lastContentOffset )
        {
            //向下
//            [ self.navigationController setNavigationBarHidden : YES animated : YES ];
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

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    if (scrollView==_dynamicsTable) {
         lastContentOffset = scrollView.contentOffset.y;
    }
}


@end
