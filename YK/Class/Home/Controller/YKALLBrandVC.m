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
#import "YKLinkWebVC.h"

@interface YKALLBrandVC ()<ZYCollectionViewDelegate>
{
    NSMutableArray *_searchBtnArr;
    UIImageView *noMessageView;
}

@property (nonatomic, strong) NSArray * imagesArr;
@property (nonatomic,strong)NSArray *blackLists;//原数据源
@property (nonatomic,strong)NSMutableArray *sections;//分好组的数据源
@property (nonatomic,strong)NSArray *imageClickUrls;
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
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Semibold(20);
    
    self.navigationItem.titleView = title;
    
    _searchBtnArr = [NSMutableArray array];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setSectionIndexColor:[UIColor colorWithHexString:@"676869"]];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    [self getBrandList];
}

- (void)getBrandList{
    
    if ([UD objectForKey:@"brandFile"]) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[UD objectForKey:@"brandFile"]];
        self.blackLists = [NSMutableArray arrayWithArray:dic[@"data"][@"brandVoList"]];
        NSArray *array = [NSArray arrayWithArray:dic[@"data"][@"brandBannerImgList"]];
        
        ZYCollectionView * cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.width*0.5)];
        cycleView.imagesArr =  [self getImageArray:array];;
        cycleView.delegate  = self;
        cycleView.placeHolderImageName = @"";
        self.tableView.tableHeaderView = cycleView;
        [self group:self.blackLists];
        [self.tableView reloadData];
        return;
    }
    [[YKHomeManager sharedManager]getBrandListOnResponse:^(NSDictionary *dic) {
        
        //缓存dic
        //        [UD setObject:dic forKey:@"brandFile"];
        //        [UD synchronize];
        
        self.blackLists = [NSMutableArray arrayWithArray:dic[@"data"][@"brandVoList"]];
        
        NSArray *array = [NSArray arrayWithArray:dic[@"data"][@"brandBannerImgList"]];
        
        self.imageClickUrls = [NSArray array];
        self.imageClickUrls = [self getImageUrlsArray:array];
        
        
        ZYCollectionView * cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.width*0.5)];
        cycleView.imagesArr =  [self getImageArray:array];;
        cycleView.delegate  = self;
        cycleView.placeHolderImageName = @"";
        //        self.tableView.tableHeaderView = cycleView;
        [self group:self.blackLists];
        [self.tableView reloadData];
    }];
}

- (NSMutableArray *)getImageArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"brandImgUrl"]];
    }
    return imageArray;
}

- (NSMutableArray *)getImageUrlsArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"brandLinkUrl"]];
    }
    return imageArray;
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
    title.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    [head addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(head.mas_centerY);
        make.centerX.equalTo(head.mas_centerX);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
        
    }];
   
    return head;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YKALLBrandCell *brandCell = (YKALLBrandCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    YKBrandDetailVC *brand = [YKBrandDetailVC new];
    brand.brandId = brandCell.brandId;
    brand.titleStr = brandCell.brandName;
    [self.navigationController pushViewController:brand animated:YES];
    
}

- (void)ZYCollectionViewClick:(NSInteger)index {
    //跳转到网页
    YKLinkWebVC *web =[YKLinkWebVC new];
    web.url = self.imageClickUrls[index];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    
}

@end
