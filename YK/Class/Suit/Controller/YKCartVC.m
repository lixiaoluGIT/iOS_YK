//
//  YKCartVC.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCartVC.h"
#import "YKNewSuitCell.h"
#import "YKAddCell.h"
#import "YKSearchVC.h"
#import "YKBuyAddCCVC.h"
#import "YKSuitDetailVC.h"
#import "YKSuitVC.h"
#import "YKProductDetailVC.h"
#import "YKSPDetailVC.h"

@interface YKCartVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger maxClothesNum;//最大衣位数
    NSInteger currentClothesNum;//当前衣位数
    YKNoDataView *NoDataView;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation YKCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    maxClothesNum = 4;
    currentClothesNum=3;
    [self creatNav];
    [self searchAddCloth];
    [self creatTableView];
    [self creatButtom];
    [self getCartList];
}

- (void)creatNav{
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
        title.text = @"我的衣袋";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        title.font = PingFangSC_Semibold(20);
        self.navigationItem.titleView = title;
    }
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAddCloth{
    //查询加衣劵
    [[YKSuitManager sharedManager]searchAddCCOnResponse:^(NSDictionary *dic) {
        [self getCartList];
    }];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self searchAddCloth];
    
}

- (void)getCartList{
    [[YKSuitManager sharedManager]getShoppingListOnResponse:^(NSDictionary *dic) {
        self.dataArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        if (self.dataArray.count>4) {
            NSMutableArray *a = [NSMutableArray array];
            [a addObject:self.dataArray[0]];
            [a addObject:self.dataArray[1]];
            [a addObject:self.dataArray[2]];
            [a addObject:self.dataArray[3]];
            [self.dataArray removeAllObjects];
            self.dataArray = [NSMutableArray arrayWithArray:a];
        }
        
        [[YKSuitManager sharedManager].suitArray removeAllObjects];
        for (NSDictionary *dic in self.dataArray) {
            YKSuit *suit = [[YKSuit alloc]init];
            [suit initWithDictionary:dic];
            if (![[YKSuitManager sharedManager].suitArray containsObject:suit]) {
                [[YKSuitManager sharedManager].suitArray addObject:suit];
                NSLog(@"%ld",[YKSuitManager sharedManager].suitArray.count);
            }
        }
        
        [self.tableView reloadData];
    }];
}

- (void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 140;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
}

- (void)creatButtom{
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    if (WIDHT==320) {
        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414-50, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==375){
        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414-50, self.view.frame.size.width, 56*WIDHT/414);
    }
    if (WIDHT==414){
        buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414-50, self.view.frame.size.width, 56*WIDHT/414);
    }
    
    if (_isFromeProduct) {
        if (WIDHT==320) {
            buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
        }
        if (WIDHT==375){
            buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
        }
        if (WIDHT==414){
            buttom.frame = CGRectMake(0, self.view.frame.size.height-56*WIDHT/414, self.view.frame.size.width, 56*WIDHT/414);
        }
    }
    [buttom setTitle:@"提交订单" forState:UIControlStateNormal];
    [buttom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttom.titleLabel.font = PingFangSC_Semibold(16);
    buttom.backgroundColor = mainColor;
    [buttom addTarget:self action:@selector(toRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttom];
}

- (void)toRelease{
    
    if (self.dataArray.count==0) {
        [smartHUD alertText:self.view alert:@"请先添加商品" delay:2];
        return;
    }
    YKSuitDetailVC *detail = [YKSuitDetailVC new];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.dataArray.count) {
        return 114;
    }
    return 110;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [YKSuitManager sharedManager].isHadCC?4:3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.row<self.dataArray.count) {
        static NSString *ll = @"c";
        YKNewSuitCell *cell = [tableView dequeueReusableCellWithIdentifier:ll];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"YKNewSuitCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        YKSuit *suit = [[YKSuit alloc]init];
        [suit initWithDictionary:self.dataArray[indexPath.row]];
        cell.suit = suit;
        cell.deleteBlock = ^(NSString *shopCartId){
            [self deleteProduct:shopCartId];
        };
        return cell;
    }
    
    YKAddCell *mycell = [[NSBundle mainBundle] loadNibNamed:@"YKAddCell" owner:self options:nil][0];
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //去详情
    if (indexPath.row<self.dataArray.count) {
        YKNewSuitCell *mycell = (YKNewSuitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
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
    }else {
        //去心愿单
        YKSuitVC *suit = [[YKSuitVC alloc]init];
        suit.isFromeProduct = YES;
        suit.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:suit animated:YES];
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *foot = [[UIView alloc]init];
    UILabel *lable = [[UILabel alloc]init];
    if (![YKSuitManager sharedManager].isHadCC) {
        lable.text = @"还想继续选衣服？立即购买加衣劵> ";
        lable.font = PingFangSC_Medium(10);
        lable.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [foot setUserInteractionEnabled:YES];
    }else {
        lable.text = @"下单时不满4件衣服，不消耗加衣劵";
        lable.font = PingFangSC_Medium(10);
        lable.textColor = [UIColor colorWithHexString:@"7a7a7a"];
        [foot setUserInteractionEnabled:NO];
    }
    [foot addSubview:lable];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(foot.right).offset(-20);
        make.centerY.mas_equalTo(foot);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        YKBuyAddCCVC *buyadd = [[YKBuyAddCCVC alloc]init];
        buyadd.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:buyadd animated:YES];
    }];
    [foot addGestureRecognizer:tap];
    return foot;
}

- (void)deleteProduct:(NSString *)shopCartId{
    NSMutableArray *shopCartList = [NSMutableArray array];
    [shopCartList addObject:shopCartId];
    [[YKSuitManager sharedManager]deleteFromShoppingCartwithShoppingCartId:shopCartList OnResponse:^(NSDictionary *dic) {
        [self getCartList];
    }];
}

@end
