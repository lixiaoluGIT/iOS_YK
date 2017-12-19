//
//  YKALLBrandVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKALLBrandVC.h"
#import "YKALLBrandCell.h"
#import "ZYCollectionView.h"
#import "YKBrandDetailVC.h"

@interface YKALLBrandVC ()<ZYCollectionViewDelegate>
{
    NSMutableArray *_searchBtnArr;
    UIImageView *noMessageView;
}

@property (nonatomic, strong) NSArray * imagesArr;
@property (nonatomic,strong)NSArray *blackLists;//原数据源
@property (nonatomic,strong)NSMutableArray *sections;//分好组的数据源
//@property (nonatomic,strong)DDIndicatorView *indicatorView;
@end


@implementation YKALLBrandVC

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (NSMutableArray *)sections{
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"品牌馆";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = title;
    
    _searchBtnArr = [NSMutableArray array];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
   
    [self.tableView setSectionIndexColor:[UIColor colorWithHexString:@"676869"]];

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    ZYCollectionView * cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.width*0.45)];
    cycleView.imagesArr = self.imagesArr;
    cycleView.delegate  = self;
    cycleView.placeHolderImageName = @"0K143Xa_0.jpg";
    self.tableView.tableHeaderView = cycleView;
    
     [self getBrandList];
}

- (void)getBrandList{
    [[YKHomeManager sharedManager]getBrandListOnResponse:^(NSDictionary *dic) {
        
        self.blackLists = [NSMutableArray arrayWithArray:dic[@"data"]];
        [self group:self.blackLists];
        [self.tableView reloadData];
    }];
}
- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
}

- (NSArray *)imagesArr {
    if (!_imagesArr) {
        NSString * url1 = @"http://pic.newssc.org/upload/news/20161011/1476154849151.jpg";
        NSString * url2 = @"http://img.mp.itc.cn/upload/20160328/f512a3a808c44b1ab9b18a96a04f46cc_th.jpg";
        NSString * url3 = @"http://p1.ifengimg.com/cmpp/2016/10/10/08/f2016fa9-f1ea-4da5-a0f5-ba388de46a96_size80_w550_h354.JPG";
        NSString * url4 = @"http://image.xinmin.cn/2016/10/11/6150190064053734729.jpg";
        NSString * url5 = @"http://imgtu.lishiquwen.com/20160919/63e053727778a18993545741f4028c67.jpg";
        NSString * url6 = @"http://imgtu.lishiquwen.com/20160919/590346287e6e45faf1070a07159314b7.jpg";
//        _imagesArr = [NSArray arrayWithObjects: url1, url2, url3, url4, url5, url6, nil];
        
        _imagesArr = [NSArray arrayWithObjects:@"pp5.jpg",@"pp1.jpg",@"pp2.jpg",@"pp3.jpg",@"pp4.jpg",nil];
    }
    return _imagesArr;
}
- (void)group:(NSArray *)array{

    for (NSDictionary *blacker in self.blackLists) {
        if (blacker[@"brandName"] == [NSNull null] || blacker[@"brandName"] == nil){
            break;
        }
        NSString *firstChar = [self firstCharactor:blacker[@"brandName"]];
        if ([firstChar characterAtIndex:0] < 'A' || [firstChar characterAtIndex:0] > 'Z') {
            if (![_searchBtnArr containsObject:@"#"]) {
                [_searchBtnArr addObject:@"#"];
            }
        }else {
            if (![_searchBtnArr containsObject:firstChar]) {
                [_searchBtnArr addObject:[NSString stringWithFormat:@"%@",firstChar]];
            }
        }
    }
    
    NSArray *result = [_searchBtnArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    _searchBtnArr = [NSMutableArray arrayWithArray:result];
    
    for (NSString *cha in _searchBtnArr) {
        NSMutableArray *sections = [NSMutableArray array];
        for (NSDictionary *blacker in self.blackLists) {
            
            if (![cha isEqualToString:@"#"] && [[self firstCharactor:blacker[@"brandName"]] isEqualToString:cha]) {
                [sections addObject:blacker];
            }
            
            if (([cha isEqualToString:@"#"] && [[self firstCharactor:blacker[@"brandName"]] characterAtIndex:0] < 'A') || [[self firstCharactor:blacker[@"brandName"]] characterAtIndex:0] > 'Z'){
                [sections addObject:blacker];
            }
        }
        [self.sections addObject:sections];
    }
    [self.tableView reloadData];
}

- (NSString *)firstCharactor:(NSString *)aString
{
    if (!aString) {
        return nil;
    }
    
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [NSArray arrayWithArray:self.sections[section]];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cell";
    
    YKALLBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[YKALLBrandCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
    }
    NSDictionary *blacker = self.sections[indexPath.section][indexPath.row];
    [cell initWithDictionary:blacker];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _searchBtnArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *header in _searchBtnArr){
        if([header isEqualToString:title]){
            return count;
        }
        count ++;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc]init];
    head.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UILabel *title = [[UILabel alloc]init];
    if (section<_searchBtnArr.count) {
        title.text = _searchBtnArr[section];
    }
    title.font = [UIFont boldSystemFontOfSize:14];
    title.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [head addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(head.mas_centerY);
        make.left.equalTo(@25);
        make.width.height.equalTo(@20);
        
    }];
    title.layer.masksToBounds = YES;
    title.layer.cornerRadius = 10;
    return head;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section<_searchBtnArr.count) {
//        return _searchBtnArr[section];
//    }
//    return nil;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKALLBrandCell *brandCell = (YKALLBrandCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    YKBrandDetailVC *brand = [YKBrandDetailVC new];
    brand.brandId = brandCell.brandId;
    [self.navigationController pushViewController:brand animated:YES];
    
}

@end
