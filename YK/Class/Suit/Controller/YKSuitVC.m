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

#define vH  56*WIDHT/414

@interface YKSuitVC ()<UITableViewDelegate,UITableViewDataSource>
{
    YKNoDataView *NoDataView;
}
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)NSMutableDictionary  *array;//重用标识
//goodsTableView是否已经滑动过
@property(nonatomic,assign) BOOL goodsIsClips;

//底部全选背景
@property(nonatomic,weak) UIView *bottomBgView;
//全选按钮上的图片
@property(nonatomic,weak) UIImageView *selectAllImageView;

@end

@implementation YKSuitVC
- (void)viewWillDisappear:(BOOL)animated{
    [_mulitSelectArray removeAllObjects];
    [YKSuitManager sharedManager].suitAccount = 0;
}

- (void)getShoppingList{
    [[YKSuitManager sharedManager]getShoppingListOnResponse:^(NSDictionary *dic) {
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        
        if (self.dataArray.count==0) {
            self.tableView.hidden = YES;
            NoDataView.hidden = NO;
            _btn.hidden = YES;
        }else {
            self.tableView.hidden = NO;
            _btn.hidden = NO;
            NoDataView.hidden = YES;
            [self.tableView reloadData];
        }
       

    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mulitSelectArray removeAllObjects];
    
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
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]}];
    
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
        title.text = @"衣袋";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        title.font = PingFangSC_Regular(17);
        self.navigationItem.titleView = title;
    }
    //添加编辑按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"afafaf"];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-100) style:UITableViewStylePlain];
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
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
   if (WIDHT==320) {
        _btn.frame = CGRectMake(0, self.view.frame.size.height-120*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==375){
        _btn.frame = CGRectMake(0, self.view.frame.size.height-110*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==414){
        _btn.frame = CGRectMake(0, self.view.frame.size.height-100*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (_isFromeProduct) {
        if (WIDHT==320) {
            _btn.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
        }
        if (WIDHT==375){
            _btn.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
        }
        if (WIDHT==414){
            _btn.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
        }
    }
    [_btn setTitle:@"确认衣袋" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.titleLabel.font = PingFangSC_Regular(14);
    _btn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    [_btn addTarget:self action:@selector(toDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    _mulitSelectArray = [[NSMutableArray alloc] init];
    
    WeakSelf(weakSelf)
    NoDataView = [[NSBundle mainBundle] loadNibNamed:@"YKNoDataView" owner:self options:nil][0];
    [NoDataView noDataViewWithStatusImage:[UIImage imageNamed:@"shangpin"] statusDes:@"暂无商品" hiddenBtn:NO actionTitle:@"去逛逛" actionBlock:^{
        [weakSelf.tabBarController setSelectedIndex:1];
    }];
 
    NoDataView.frame = CGRectMake(0, 98+64, WIDHT,HEIGHT-162);
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.view addSubview:NoDataView];
    NoDataView.hidden = YES;

    self.tableView.allowsMultipleSelection = YES;
    [self setupBottomStatus];
}
- (void)setupBottomStatus{
    UIView *bottomBgView = [[UIView alloc]init];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(50);
        make.height.mas_equalTo(@50);
    }];
    self.bottomBgView = bottomBgView;
    
    //左侧全选按钮
    [self setLeftSelectAllBtn];
    //右侧删除按钮
    [self setRightDeleteBtn];
}

//左侧全选按钮
- (void)setLeftSelectAllBtn{
    UIButton *selectAll = [[UIButton alloc]init];
    [selectAll setTitle:@"全选" forState:UIControlStateNormal];
    [selectAll setTitleColor:[UIColor colorWithHexString:@"A1A1A1"] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(clickSelectAll) forControlEvents:UIControlEventTouchUpInside];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomBgView addSubview:selectAll];
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.bottomBgView);
        make.width.mas_equalTo(@164);
    }];
    //图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"weixuanzhong"];
    [selectAll addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAll).offset(20);
        make.centerY.equalTo(selectAll);
        make.width.height.mas_equalTo(@25);
    }];
    self.selectAllImageView = imageView;
}
//全选按钮点击事件
- (void)clickSelectAll{
    for (YKSuitCell *cell in self.tableView.visibleCells) {
        cell.collectBtn.selected = !cell.collectBtn.selected;
            if (cell.collectBtn.selected) {
                [cell.collectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
                    self.selectAllImageView.image = [UIImage imageNamed:@"xuanzhong"];
            }else{
                    [cell.collectBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
                    self.selectAllImageView.image = [UIImage imageNamed:@"weixuanzhong"];
            }
    }
}
//右侧删除按钮
- (void)setRightDeleteBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"FF5A5A"];
    [self.bottomBgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomBgView);
        make.width.mas_equalTo(@(WIDHT-164));
    }];
}
- (void)edit:(UIBarButtonItem *)btn{
    self.goodsIsClips = !self.goodsIsClips;
    if (self.goodsIsClips) {
        [self updateMasonrys];
        btn.title = @"删除";
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 0, WIDHT, HEIGHT-vH);
            [self.view layoutIfNeeded];
        }];
        [self.tableView setEditing:YES animated:YES];
    }else{
        btn.title = @"管理";
//        btn.action = []
        
        [self resetMasonrys];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0, 0, WIDHT, HEIGHT-50*WIDHT/414);
            [self.view layoutIfNeeded];
        }];
        [self.tableView setEditing:NO animated:NO];
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

        YKSuitDetailVC *detail = [YKSuitDetailVC new];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *status = [self.dataArray[indexPath.row][@"clothingStockNum"] intValue]  > 0 ?@"1":@"0";
    CGFloat h = [YKSuitCell heightForCell:status];
    
    return h;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSString *identifier = [self.array objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    
    YKSuitCell *mycell = [[NSBundle mainBundle] loadNibNamed:@"YKSuitCell" owner:self options:nil][0];

    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    YKSuit *suit = [[YKSuit alloc]init];
    [suit initWithDictionary:self.dataArray[indexPath.row]];
    mycell.suit = suit;
    mycell.selectClickBlock = ^(NSInteger status){
        NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        //判断数组中有没有被选中行的行号,
        if ([_mulitSelectArray containsObject:selectRow]) {
            [_mulitSelectArray removeObject:selectRow];
            
        }else{
            [_mulitSelectArray addObject:selectRow];
        }
        NSLog(@"选中的行_mulitSelectArray = %@",_mulitSelectArray);
        if (status==0) {
            _btn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        }else {
            _btn.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
            
        }

    };
    //字符串
    NSString* selectRow = [NSString stringWithFormat:@"%ld",indexPath.row];

    //数组中包含当前行号，设置对号
        [mycell setSelectBtnStatus:[_mulitSelectArray  containsObject:selectRow]];
   
    return mycell;
}

//选中cell时调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing) {
        YKSuitCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.collectBtn.selected = !cell.collectBtn.selected;
        if (cell.collectBtn.selected) {
            [cell.collectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }else{
            [cell.collectBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        }
    }else{
        //非编辑状态下
        YKSuitCell *mycell = (YKSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        YKProductDetailVC *detail = [YKProductDetailVC new];
        detail.productId = mycell.suitId;
        detail.titleStr = mycell.suit.clothingName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}
- (NSString *)getFilePath
{
    NSString* filePath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/saveData"];
    return filePath;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //编辑设置成自定义的必须把系统的设置为None
    return UITableViewCellEditingStyleNone;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YKSuitCell *ce = (YKSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//    NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        [[YKSuitManager sharedManager]deleteFromShoppingCartwithShoppingCartId:ce.suit.shoppingCartId OnResponse:^(NSDictionary *dic) {
//
//            if ([_mulitSelectArray containsObject:selectRow]) {
//                [_mulitSelectArray removeObject:selectRow];
//                [[YKSuitManager sharedManager]cancelSelectCurrentPruduct:ce.suit];
//                [YKSuitManager sharedManager].suitAccount--;
//            }
//
//                //TODO:需重新分配数据,选中状态的保存,此处有BUG
//                for (NSString *row in _mulitSelectArray) {
//
//                    int rowInter = [row intValue];
//
//                    int seleRowInter = [selectRow intValue];
//
//                    if (rowInter >= seleRowInter) {
//                        rowInter--;
//                        [_mulitSelectArray removeObject:row];
//                        [_mulitSelectArray addObject:@(rowInter)];
//                    }
//                }
//
////                [YKSuitManager sharedManager].suitAccount--;
////            }
//
//
//                if ([YKSuitManager sharedManager].suitAccount==0) {
//                    _btn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
//                }else {
//                    _btn.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
//
//                }
//
//            [self.dataArray removeObjectAtIndex:indexPath.row];
//            // 删除列表中数据
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//             NSLog(@"选中array:%@",_mulitSelectArray);
//
////            [self getShoppingList];
//            if (self.dataArray.count==0) {
//                self.tableView.hidden = YES;
//                NoDataView.hidden = NO;
//                _btn.hidden = YES;
//            }else {
//                self.tableView.hidden = NO;
//                _btn.hidden = NO;
//                NoDataView.hidden = YES;
////                [self.tableView reloadData];
//            }
//        }];
//    }
    
}



@end
