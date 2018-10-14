//
//  YKSuitVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuitVC.h"
#import "YKSuitCell.h"
#import "YKSuitDetailVC.h"
#import "YKLoginVC.h"
#import "YKProductDetailVC.h"
#import "YKSearchVC.h"
#import "YKSPDetailVC.h"
#import "YKAddCCouponView.h"
#import "YKBuyAddCCVC.h"
#define vH  56*WIDHT/414

@interface YKSuitVC ()<UITableViewDelegate,UITableViewDataSource>
{
    YKNoDataView *NoDataView;
    BOOL ccbuttom;
    BOOL bt;
}
@property (nonatomic,strong)UIButton *selectAll;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)YKAddCCouponView *addCCView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)NSMutableDictionary  *array;//重用标识
//goodsTableView是否已经滑动过
@property(nonatomic,assign) BOOL goodsIsClips;

//底部全选背景
@property(nonatomic,weak) UIView *bottomBgView;
//全选按钮上的图片
@property(nonatomic,weak) UIImageView *selectAllImageView;
//存储cell
@property (nonatomic,strong)NSMutableArray *cellArray;

@end

@implementation YKSuitVC
- (void)viewWillDisappear:(BOOL)animated{
    [_mulitSelectArray removeAllObjects];
    [selectDeArray removeAllObjects];
    [selectDeShoppingCartList removeAllObjects];
    [YKSuitManager sharedManager].suitAccount = 0;


   
    [self resetMasonrys];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, WIDHT, HEIGHT-100*WIDHT/414);
        [self.view layoutIfNeeded];
    }];
    [self.tableView setEditing:NO animated:YES];
    [_mulitSelectArray removeAllObjects];
    [selectDeArray removeAllObjects];
    [selectDeShoppingCartList removeAllObjects];
    [self.tableView reloadData];
    self.selectAll.selected = NO;
    self.selectAllImageView.image = [UIImage imageNamed:@"weixuanzhong"];
    [self setLeftBar];
    self.goodsIsClips = NO;
}

//获取心愿单列表
- (void)getShoppingList{
    
    [[YKSuitManager sharedManager]getCollectListOnResponse:^(NSDictionary *dic) {
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        
        [self setLeftBar];
        if (self.dataArray.count==0) {
            self.tableView.hidden = YES;
            NoDataView.hidden = NO;
            _btn.hidden = YES;
            _addCCView.hidden = YES;
            [self.tableView setEditing:NO animated:YES];
            [self resetMasonrys];
            self.goodsIsClips = NO;
        }else {
            self.tableView.hidden = NO;
            _btn.hidden = NO;
            _addCCView.hidden=  NO;
            NoDataView.hidden = YES;
            [self.tableView reloadData];
        }
    }];
//    [[YKSuitManager sharedManager]getShoppingListOnResponse:^(NSDictionary *dic) {
//        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
//
//         [self setLeftBar];
//        if (self.dataArray.count==0) {
//            self.tableView.hidden = YES;
//            NoDataView.hidden = NO;
//            _btn.hidden = YES;
//            _addCCView.hidden = YES;
//            [self.tableView setEditing:NO animated:YES];
//            [self resetMasonrys];
//            self.goodsIsClips = NO;
//        }else {
//            self.tableView.hidden = NO;
//            _btn.hidden = NO;
//            _addCCView.hidden=  NO;
//            NoDataView.hidden = YES;
//            [self.tableView reloadData];
//        }
       

//    }];
    
    //查询加衣劵
//    [[YKSuitManager sharedManager]searchAddCCOnResponse:^(NSDictionary *dic) {
//        [_addCCView reloadData];
//    }];
}

- (void)setLeftBar{
    UIBarButtonItem *rightBarItem ;
    if (_dataArray.count == 0) {
        rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    }else {
        if (self.tableView.editing) {
             rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
        }else {
            rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
            
        }
    }
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"000000"];
}
- (void)viewWillAppear:(BOOL)animated{
    [_mulitSelectArray removeAllObjects];
    [selectDeArray removeAllObjects];
    [selectDeShoppingCartList removeAllObjects];
    [YKSuitManager sharedManager].isHadCC = NO;
    [YKSuitManager sharedManager].isUseCC = NO;
    [self getShoppingList];
    
    _array = [NSMutableDictionary dictionary];
    self.dataArray = [NSMutableArray array];
    [self.tableView reloadData];
    [[YKSuitManager sharedManager].suitArray removeAllObjects];
    _btn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]}];
    
    //添加返回按钮
    if (_isFromeProduct) {
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
        title.text = @"我的心愿单";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        title.font = PingFangSC_Semibold(20);
        self.navigationItem.titleView = title;
    }
    //添加编辑按钮
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"afafaf"];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-130) style:UITableViewStylePlain];
    if (_isFromeProduct) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-56*WIDHT/414) style:UITableViewStylePlain];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.tableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    _mulitSelectArray = [[NSMutableArray alloc] init];
    selectDeArray = [[NSMutableArray alloc]init];
    selectDeShoppingCartList = [[NSMutableArray alloc]init];
    _cellArray  = [[NSMutableArray alloc]init];

    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"shangpin"] statusDes:@"暂无心愿单" hiddenBtn:NO actionTitle:@"去逛逛" actionBlock:^{
        YKSearchVC *searchVC = [[YKSearchVC alloc] init];
        searchVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[1];
        searchVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
 
    NoDataView.frame = CGRectMake(0, 98+BarH, WIDHT,HEIGHT-162);
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:NoDataView];
    NoDataView.hidden = YES;

    self.tableView.allowsMultipleSelection = YES;
//    [self setupBottomStatus];
    
    [self setButtom];//底部视图
    
}

- (void)setButtom{
    WeakSelf(weakSelf)
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addCCView = [[NSBundle mainBundle]loadNibNamed:@"YKAddCCouponView" owner:nil options:nil][0];
    
    _addCCView.ensureBlock = ^(void){//加入衣袋
        [weakSelf toDetail];
    };
    if (WIDHT==320) {
        _addCCView.frame = CGRectMake(0, self.view.frame.size.height-120*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==375){
        _addCCView.frame = CGRectMake(0, self.view.frame.size.height-110*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==414){
        _addCCView.frame = CGRectMake(0, self.view.frame.size.height-105*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (HEIGHT == 812) {
        _addCCView.frame = CGRectMake(0, self.view.frame.size.height-148*WIDHT/414, self.view.frame.size.width, 48*WIDHT/414);
    }
    if (_isFromeProduct) {
        if (WIDHT==320) {
            _addCCView.frame = CGRectMake(0, self.view.frame.size.height-48*WIDHT/414, self.view.frame.size.width, 48*WIDHT/414);
        }
        if (WIDHT==375){
            _addCCView.frame = CGRectMake(0, self.view.frame.size.height-48*WIDHT/414, self.view.frame.size.width, 48*WIDHT/414);
        }
        if (WIDHT==414){
            _addCCView.frame = CGRectMake(0, self.view.frame.size.height-48*WIDHT/414, self.view.frame.size.width, 48*WIDHT/414);
        }
        if (HEIGHT == 812) {
            _addCCView.frame = CGRectMake(0, self.view.frame.size.height-80*WIDHT/414, self.view.frame.size.width, 48*WIDHT/414);
        }
        
    }

        [self.view addSubview:_addCCView];
  

 
        [self setupBottomStatus];
  
   
    
}
- (void)setupBottomStatus{
    UIView *bottomBgView = [[UIView alloc]init];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    [self.view bringSubviewToFront:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(54);
        make.height.mas_equalTo(@54);
    }];
    self.bottomBgView = bottomBgView;
    
    //左侧全选按钮
    [self setLeftSelectAllBtn];
    //右侧删除按钮
    [self setRightDeleteBtn];
}

//左侧全选按钮
- (void)setLeftSelectAllBtn{
    _selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_selectAll setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAll setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [_selectAll addTarget:self action:@selector(clickSelectAll:) forControlEvents:UIControlEventTouchUpInside];
    _selectAll.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomBgView addSubview:_selectAll];
    _selectAll.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [_selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.bottomBgView);
        make.width.mas_equalTo(@120);
    }];
   
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"weixuanzhong"];
    [_selectAll addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectAll).offset(24);
        make.centerY.equalTo(_selectAll);
        make.width.height.mas_equalTo(@20);
    }];
    self.selectAllImageView = imageView;
    
    UILabel *la = [[UILabel alloc]init];
    la.text = @"全选";
    la.font = PingFangSC_Semibold(14);
    la.textColor = mainColor;
    [_selectAll addSubview:la];
    la.textAlignment = NSTextAlignmentLeft;

    [la mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(12);
        make.centerY.equalTo(_selectAll.mas_centerY);
    }];
}
//全选按钮点击事件
- (void)clickSelectAll:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        //添加购物车ID
        for (NSDictionary *cart in _dataArray) {
            NSString *selectShoppingCardId = cart[@"shoppingCartId"];
            if (![selectDeShoppingCartList containsObject:selectShoppingCardId]) {
                [selectDeShoppingCartList addObject:selectShoppingCardId];
            }
        }
        
        //添加当前第几行
        for (int index=0;index<_dataArray.count;index++) {
            NSString *selectRow  = [NSString stringWithFormat:@"%d",index];
            if (![selectDeArray containsObject:selectRow]) {
                [selectDeArray addObject:selectRow];
            }
        }
        self.selectAllImageView.image = [UIImage imageNamed:@"xuanzhong"];
    }else{
        [selectDeArray removeAllObjects];
        [selectDeShoppingCartList removeAllObjects];
        self.selectAllImageView.image = [UIImage imageNamed:@"weixuanzhong"];
    }
    
    for (YKSuitCell *cell in _cellArray) {
        cell.collectBtn.selected = btn.selected;
        [cell setDeleteBtnStatus:cell.collectBtn.selected];
    }
}
//右侧删除按钮
- (void)setRightDeleteBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"EE2D2D "];
    [self.bottomBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomBgView);
        make.width.mas_equalTo(@(WIDHT-120));
        make.height.equalTo(@56);
    }];
    [btn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
}
- (void)delete{
    if (selectDeArray.count==0) {
        [smartHUD alertText:self.view alert:@"请选择要删除的商品" delay:1.2];
        return;
    }
    
//    for (int index=0; index<selectDeArray.count; index++) {
//        YKSuitCell *cell = _cellArray[[selectDeArray[index] intValue]];
        [[YKSuitManager sharedManager]deleteFromShoppingCartwithShoppingCartId:selectDeShoppingCartList OnResponse:^(NSDictionary *dic) {
            [_mulitSelectArray removeAllObjects];
            [selectDeArray removeAllObjects];
            [selectDeShoppingCartList removeAllObjects];
            [_cellArray removeAllObjects];
            [self getShoppingList];
            [[YKSuitManager sharedManager]clear];
            
        }];
//    }
    
}
- (void)edit:(UIBarButtonItem *)btn{
    if (_dataArray.count==0) {
        btn.title = @"";
        return;
    }
    [[YKSuitManager sharedManager]clear];
    _btn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    self.goodsIsClips = !self.goodsIsClips;
    _addCCView.hidden = !_addCCView.hidden;
    if (self.goodsIsClips) {
        [self updateMasonrys];
        btn.title = @"完成";
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 0, WIDHT, HEIGHT-vH);
            [self.view layoutIfNeeded];
        }];
        [self.tableView setEditing:YES animated:YES];
    }else{
        btn.title = @"管理";
        [self resetMasonrys];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 0, WIDHT, HEIGHT-50*WIDHT/414);
            
            [self.view layoutIfNeeded];
        }];
        [self.tableView setEditing:NO animated:YES];
        [_mulitSelectArray removeAllObjects];
        [selectDeArray removeAllObjects];
        [selectDeShoppingCartList removeAllObjects];
        [self.tableView reloadData];
        self.selectAll.selected = NO;
        self.selectAllImageView.image = [UIImage imageNamed:@"weixuanzhong"];
    }
}

//Method
- (void)updateMasonrys{
    [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        
        if (_isFromeProduct) {
            make.bottom.equalTo(self.view).offset(0);
            
        }else {
            make.bottom.equalTo(self.view).offset(-50);
        }
        
        //iphone x 适配
        if (HEIGHT == 812) {
            if (_isFromeProduct) {
                make.bottom.equalTo(self.view).offset(-24);
            }else {
                make.bottom.equalTo(self.view).offset(-83);
            }
        }
        make.height.mas_equalTo(vH);
    }];
}
- (void)resetMasonrys{
    [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(vH);
        make.height.mas_equalTo(vH);
    }];
}
- (void)toDetail{
    
    if ([Token length]==0) {
        YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
        [self presentViewController:login animated:YES completion:^{
            
        }];
        login.hidesBottomBarWhenPushed = YES;
        return;
    }
    
    if ([YKSuitManager sharedManager].suitAccount==0) {
        [smartHUD alertText:self.view alert:@"请先选择商品" delay:1.2];
        return;
    }

    //todo:接口，判断一共可加入几个衣服,用用户剩余衣位判断
    [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"判断sheng yu衣位数" delay:1.2];
//        YKSuitDetailVC *detail = [YKSuitDetailVC new];
//        detail.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    NSString *status = [self.dataArray[indexPath.row][@"clothingStockNum"] intValue]  > 0 ?@"1":@"0";
//    CGFloat h = [YKSuitCell heightForCell:status];
    
    return 115;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YKSuitCell *mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitCell" owner:self options:nil][0];
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    YKSuit *suit = [[YKSuit alloc]init];
    [suit initWithDictionary:self.dataArray[indexPath.row]];
    mycell.suit = suit;
    mycell.selectClickBlock = ^(NSInteger status){
        if (self.tableView.editing) {
            [[YKSuitManager sharedManager]clear];
            return ;
        }
        NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
       if ([_mulitSelectArray containsObject:selectRow]) {
            [_mulitSelectArray removeObject:selectRow];
            
        }else{
            [_mulitSelectArray addObject:selectRow];
        }
      
        if (status==0) {
            _btn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        }else {
            _btn.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
            
        }

    };
    //字符串
    NSString* selectRow = [NSString stringWithFormat:@"%ld",indexPath.row];

    //数组中包含当前行号，设置对号
    [mycell setSelectBtnStatus:[_mulitSelectArray  containsObject:selectRow]];
    [mycell setDeleteBtnStatus:[selectDeArray containsObject:selectRow]];
    if (![_cellArray containsObject:mycell]) {
        [_cellArray addObject:mycell];
    }
        return mycell;
}

//选中cell时调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        YKSuitCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.collectBtn.selected = !cell.collectBtn.selected;
        
        NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSString *shoppingCardId = cell.suit.shoppingCartId;
        //购物车ID
        if ([selectDeShoppingCartList containsObject:shoppingCardId]) {
            [selectDeShoppingCartList removeObject:shoppingCardId];
            
        }else{
            [selectDeShoppingCartList addObject:shoppingCardId];
        }
        //选中行
        if ([selectDeArray containsObject:selectRow]) {
            [selectDeArray removeObject:selectRow];
            
        }else{
            [selectDeArray addObject:selectRow];
        }
        if (selectDeArray.count == _dataArray.count) {
            self.selectAll.selected = YES;
            self.selectAllImageView.image = [UIImage imageNamed:@"xuanzhong"];
        }else {
            self.selectAll.selected = NO;
            self.selectAllImageView.image = [UIImage imageNamed:@"weixuanzhong"];
        }
        if (cell.collectBtn.selected) {
            [cell.collectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }else{
            [cell.collectBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        }
    }else{
        //非编辑状态下
        YKSuitCell *mycell = (YKSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (mycell.suit.classify==1) {
            YKProductDetailVC *detail = [YKProductDetailVC new];
            detail.productId = mycell.suitId;
            detail.titleStr = mycell.suit.clothingName;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }else {
            YKSPDetailVC *detail = [YKSPDetailVC new];
            detail.productId = mycell.suitId;
            detail.titleStr = mycell.suit.clothingName;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
        
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //编辑设置成自定义的必须把系统的设置为None
    return UITableViewCellEditingStyleNone;
}

@end
