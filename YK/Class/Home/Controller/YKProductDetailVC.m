//
//  YKProductDetailVC.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKProductDetailVC.h"

#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"
#import "YyxHeaderRefresh.h"
#import "YKProductDetailHeader.h"
#import "YKProductDetailButtom.h"
#import "YKYifuScanCell.h"
#import "YKLoginVC.h"
#import "YKBrandDetailVC.h"
#import "YKSuitVC.h"

@interface YKProductDetailVC ()
<UICollectionViewDelegate, UICollectionViewDataSource,ZYCollectionViewDelegate>{
    BOOL hadMakeHeader;
    ZYCollectionView * cycleView;
    YKProductDetailHeader *scroll;
}
@property (nonatomic, strong) NSArray * imagesArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *images2;
@property (nonatomic, assign) CGRect origialFrame;

@property (strong, nonatomic) YyxHeaderRefresh *refresh;

@property (nonatomic,assign)NSString *sizeNum;

//真实数据

@end

@implementation YKProductDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    
    self.product = [YKProduct new];
    
    [self getPruductDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)getPruductDetail{
    [[YKHomeManager sharedManager]getProductDetailInforWithProductId:[self.productId intValue] OnResponse:^(NSDictionary *dic) {
        
        self.product  = [YKProduct new];
        YKProductDetail *productDetail = [YKProductDetail new];
        [productDetail initWithDictionary:dic];
        self.product.productDetail = productDetail;
        scroll.product = self.product.product;
        scroll.brand = self.product.brand;
        self.imagesArr = [self getImageArray:self.product.bannerImages];
        
        
        [self.collectionView reloadData];
    }];
}
- (NSMutableArray *)getImageArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"clothingImgUrl"]];
    }
    return imageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _sizeNum = 0;
    self.title = self.titleStr;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Regular(17);
    
    self.navigationItem.titleView = title;
    
    
    
    //请求数据
    self.images = [NSArray array];
    //    self.images= @[@"35.jpg",@"36.jpg",@"37.jpg",@"38.jpg",@"39.jpg",@"40.jpg",@"41.jpg",@"42.jpg",@"43.jpg"];
    self.view.backgroundColor =[ UIColor whiteColor];
    
    
    
    UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
    layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    layoutView.itemSize = CGSizeMake((WIDHT-48)/2, (WIDHT-48)/2*240/180);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, WIDHT, HEIGHT-30) collectionViewLayout:layoutView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YKYifuScanCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YKYifuScanCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
    self.collectionView.hidden = YES;
    
    
    //监听tableView 偏移量
    //    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    //    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    //    self.refresh = [YyxHeaderRefresh header];
    //
    //    self.refresh.tableView = self.collectionView;
    //    [self dd];
    //    CATWEAKSELF
    //    self.refresh.beginRefreshingBlock = ^(YyxHeaderRefresh *refreshView){
    //        [weakSelf dd];
    //    };
    //
    //       // [BQActivityView showActiviTy];
    [LBProgressHUD showHUDto:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [BQActivityView hideActiviTy];
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.collectionView.hidden = NO;
    });
    
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(3, 20, 44, 44);
    btn1.adjustsImageWhenHighlighted = NO;
    [btn1 setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    WeakSelf(weakSelf)
    YKProductDetailButtom *buttom=  [[NSBundle mainBundle] loadNibNamed:@"YKProductDetailButtom" owner:self options:nil][0];
    buttom.frame = CGRectMake(0,HEIGHT-50,WIDHT, 50);
    buttom.AddToCartBlock = ^(void){//添加到购物车
        [weakSelf addTOCart];
    };
    buttom.KeFuBlock = ^(void){//客服
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.3) {
            NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
            NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
            if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                /// 大于等于10.0系统使用此openURL方法
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
                } else {
                    // Fallback on earlier versions
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }
            return;
        }
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:PHONE message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertview.delegate = self;
        [alertview show];
    };
    buttom.ToSuitBlock = ^(void){//去衣袋
        
        YKSuitVC *chatVC = [[YKSuitVC alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = self.tabBarController.viewControllers[2];
        chatVC.hidesBottomBarWhenPushed = YES;
        self.tabBarController.selectedViewController = nav;
        [self.navigationController popToRootViewControllerAnimated:NO];
        //
        //        [nav pushViewController:chatVC animated:YES];
        //        [self.navigationController popToRootViewControllerAnimated:NO];
        //        [self.tabBarController setSelectedIndex:2];
    };
    [self.view addSubview:buttom];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//取消
        
    }
    if (buttonIndex==1) {//拨打
        NSString *callPhone = [NSString stringWithFormat:@"tel://%@",PHONE];
        NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.tabBarController setSelectedIndex:0];
}

- (void)addTOCart{
    //未登录
    
    if ([Token length] == 0) {
        YKLoginVC *login = [[YKLoginVC alloc]initWithNibName:@"YKLoginVC" bundle:[NSBundle mainBundle]];
        [self presentViewController:login animated:YES completion:^{
            
        }];
        login.hidesBottomBarWhenPushed = YES;
        return;
    }
    if (_sizeNum==0) {
        [smartHUD alertText:self.view alert:@"请选择尺码大小" delay:1.2];
        return ;
    }
    [[YKSuitManager sharedManager]addToShoppingCartwithclothingId:self.productId clothingStckType:_sizeNum OnResponse:^(NSDictionary *dic) {
        
    }];
}
-(void)dd{
    
    int random = self.images2.count;
    
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 1; i < random; i++) {
        int randomIndex = arc4random_uniform(random);
        [temp addObject:self.images2[randomIndex]];
    }
    if (temp.count) {
        self.images = [temp copy];
    }
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refresh endRefreshing];
        [self.collectionView reloadData];
    });
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIScrollView * scrollView = (UIScrollView *)object;
    
    if (!self.collectionView == scrollView) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if (scrollView.contentOffset.y>0) {
        self.navigationController.navigationBar.hidden = NO;
    }
    if (scrollView.contentOffset.y>280) {
        self.refresh.hidden = YES;
        self.navigationController.navigationBar.alpha = 1;
        //        self.navigationController.navigationBar.hidden = NO;
    }else {
        self.refresh.hidden = NO;
        self.navigationController.navigationBar.alpha = scrollView.contentOffset.y/280 ;
        //        self.navigationController.navigationBar.hidden = YES;
    }
    
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.product.pruductDetailImgs.count;
    }
    return self.product.productList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    
    
    if (indexPath.section==1) {
        YKProduct *product = [YKProduct new];
        [product initWithDictionary:self.product.productList[indexPath.row]];
        cell.product = product;
        return cell;
    }
    YKYifuScanCell *scan = (YKYifuScanCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YKYifuScanCell" forIndexPath:indexPath];
    
    [scan.imageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:self.product.pruductDetailImgs[indexPath.row][@"clothingImgUrl"]]] placeholderImage:[UIImage imageNamed:@"商品详情头图"]];
    [scan.imageView setContentMode:UIViewContentModeScaleAspectFill];
    scan.imageArray = [self getImageArray:self.product.pruductDetailImgs];
    scan.num = indexPath.row;
    return scan;
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


//头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return CGSizeMake(WIDHT, WIDHT*0.55 +350+100);
    }
    return CGSizeMake(WIDHT, 80);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    WeakSelf(weakSelf)
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section==0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
            headerView.backgroundColor =[UIColor whiteColor];
            
            cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.55+100)];
            cycleView.imagesArr = self.imagesArr;
            cycleView.delegate  = self;
            
            self.origialFrame = cycleView.frame;
            [headerView addSubview:cycleView];
            
            scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKProductDetailHeader" owner:self options:nil][0];
            
            scroll.selectBlock = ^(NSString *type){
                weakSelf.sizeNum = type;
            };
            scroll.toDetailBlock = ^(NSInteger brandId,NSString *brandName){
                YKBrandDetailVC *brand = [YKBrandDetailVC new];
                brand.hidesBottomBarWhenPushed = YES;
                brand.brandId = [NSString stringWithFormat:@"%ld",brandId];
                brand.titleStr = brandName;
                
                [weakSelf.navigationController pushViewController:brand animated:YES];
            };
            scroll.frame = CGRectMake(0, WIDHT*0.55+100,WIDHT, 350);
            if (!hadMakeHeader) {
                [headerView addSubview:scroll];
                hadMakeHeader = YES;
            }
            return headerView;
            
        }
        if (indexPath.section==1) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView2" forIndexPath:indexPath];
            headerView.backgroundColor =[UIColor whiteColor];
            YKRecommentTitleView  *ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][0];
            ti.frame = CGRectMake(0, 15,WIDHT, 80);
            [ti reSetTitle];
            [headerView addSubview:ti];
            
            return headerView;
        }
        
    }
    
    return nil;
}
//设置大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        return CGSizeMake((WIDHT-48)/2, (WIDHT-48)/2*240/180);
    }
    
    return CGSizeMake(WIDHT,(WIDHT));
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return UIEdgeInsetsMake(16, 0, 16, 0);
    }
    return UIEdgeInsetsMake(16, 16, 16, 16);
    
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 30;
    }
    return 16;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        return 16;
    }
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    
    if (indexPath.section==1) {
        YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
        detail.productId = cell.goodsId;
        detail.titleStr = cell.goodsName;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index === %ld",indexPath.row);
    
}
- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
    
}

@end

