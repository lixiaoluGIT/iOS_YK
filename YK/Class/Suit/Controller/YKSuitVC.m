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

@interface YKSuitVC ()<UITableViewDelegate,UITableViewDataSource>
{
    YKNoDataView *NoDataView;
}
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)NSMutableDictionary  *array;//重用标识

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"1a1a1a"]}];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
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
        [weakSelf.tabBarController setSelectedIndex:0];
    }];
 
    NoDataView.frame = CGRectMake(0, 98+64, WIDHT,HEIGHT-162);
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.view addSubview:NoDataView];
    NoDataView.hidden = YES;

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
    
    //确认衣袋
//    [[YKSuitManager sharedManager]postOrderwithSuits:nil OnResponse:^(NSDictionary *dic) {
        YKSuitDetailVC *detail = [YKSuitDetailVC new];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
//    }];
    
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKSuitCell *mycell = (YKSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    YKProductDetailVC *detail = [YKProductDetailVC new];
    detail.productId = mycell.suitId;
    detail.titleStr = mycell.suit.clothingName;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}
- (NSString *)getFilePath
{
    NSString* filePath = [NSHomeDirectory()  stringByAppendingPathComponent:@"Documents/saveData"];
    return filePath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKSuitCell *ce = (YKSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString*  selectRow  = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [[YKSuitManager sharedManager]deleteFromShoppingCartwithShoppingCartId:ce.suit.shoppingCartId OnResponse:^(NSDictionary *dic) {

            if ([_mulitSelectArray containsObject:selectRow]) {
                [_mulitSelectArray removeObject:selectRow];
                [[YKSuitManager sharedManager]cancelSelectCurrentPruduct:ce.suit];
                [YKSuitManager sharedManager].suitAccount--;
            }
            
                //TODO:需重新分配数据,选中状态的保存,此处有BUG
                for (NSString *row in _mulitSelectArray) {
                  
                    int rowInter = [row intValue];
        
                    int seleRowInter = [selectRow intValue];
                  
                    if (rowInter >= seleRowInter) {
                        rowInter--;
                        [_mulitSelectArray removeObject:row];
                        [_mulitSelectArray addObject:@(rowInter)];
                    }
                }
                
//                [YKSuitManager sharedManager].suitAccount--;
//            }
            
                
                if ([YKSuitManager sharedManager].suitAccount==0) {
                    _btn.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
                }else {
                    _btn.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
                    
                }

            [self.dataArray removeObjectAtIndex:indexPath.row];
            // 删除列表中数据
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
             NSLog(@"选中array:%@",_mulitSelectArray);
            
//            [self getShoppingList];
            if (self.dataArray.count==0) {
                self.tableView.hidden = YES;
                NoDataView.hidden = NO;
                _btn.hidden = YES;
            }else {
                self.tableView.hidden = NO;
                _btn.hidden = NO;
                NoDataView.hidden = YES;
//                [self.tableView reloadData];
            }
        }];
    }
         
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"移除";//默认文字为 Delete
}

@end
