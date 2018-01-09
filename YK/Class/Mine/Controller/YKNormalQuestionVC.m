//
//  YKNormalQuestionVC.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKNormalQuestionVC.h"
#import "YKMineCell.h"
#import "YKWebVC.h"

@interface YKNormalQuestionVC ()
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *desImages;
@end

@implementation YKNormalQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常见问题";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = title;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 ;
    self.tableView.backgroundColor = self.view.backgroundColor;
    

    
    self.images = [NSArray array];
    self.images = @[@"zuyi",@"huanyi",@"wuliu-1",@"dingdanwenti",@"shangpinwenti",@"qitawenti",@"qingxi"];
    self.titles = [NSArray array];
    self.titles = @[@"租衣规则",@"还衣规则",@"物流配送",@"订单问题",@"清洗服务"];
    
    self.desImages = [NSArray array];
    self.desImages = @[@"租衣规则",@"还衣规则",@"物流配送",@"订单问题",@"清洗服务"];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"F8f8f8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        return 260;
    }
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 1;
    }

    return self.titles.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.section==1) {
        
        YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"contact"];
        if (mycell == nil) {
            mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][1];
        }
        mycell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mycell;
    }
    static NSString *ID = @"cell";
    YKMineCell *mycell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (mycell == nil) {
        mycell = [[NSBundle mainBundle] loadNibNamed:@"YKMineCell" owner:self options:nil][0];
        mycell.title.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
        mycell.image.image = [UIImage imageNamed:self.images[indexPath.row]];
    }
    mycell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mycell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YKWebVC *web = [YKWebVC new];
        web.imageName = self.desImages[indexPath.row];
        web.titleStr = self.titles[indexPath.row];
        [self.navigationController pushViewController:web animated:YES];
    }
}

@end
