//
//  YKHomeVC.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//
#define h [UIScreen mainScreen].bounds.size.height
#define w [UIScreen mainScreen].bounds.size.width
#import "YKHomeVC.h"
#import "CGQCollectionViewCell.h"
#import "ZYCollectionView.h"
#import "WMHCustomScroll.h"
#import "YKScrollView.h"
#import "YKALLBrandVC.h"
#import "YKRecommentTitleView.h"
#import "YyxHeaderRefresh.h"
#import "YKProductDetailVC.h"
#import "YKBrandDetailVC.h"
#import "YKMessageVC.h"

#import <UMSocialCore/UMSocialCore.h>
#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>


@interface YKHomeVC ()<UICollectionViewDelegate, UICollectionViewDataSource,ZYCollectionViewDelegate,WMHCustomScrollViewDelegate>

//@property (nonatomic, strong) NSArray * imagesArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *images2;
//真实数据源
@property (nonatomic,strong)NSArray *imagesArr;
@property (nonatomic,strong)NSArray *brandArray;
@property (nonatomic,strong)NSArray *productArray;

@property (strong, nonatomic) YyxHeaderRefresh *refresh;
@property (nonatomic,strong)YKScrollView *scroll;
@end

@implementation YKHomeVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //请求数据
    self.images2 = [NSArray array];
    self.images2 = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"36.jpg",@"8.jpg",@"9.jpg",@"10.jpg",@"11.jpg",@"12.jpg",@"13.jpg",@"14.jpg",@"15.jpg",@"16.jpg",@"17.jpg",@"18.jpg",@"19.jpg",@"20.jpg",@"21.jpg",@"22.jpg",@"23.jpg",@"24.jpg",@"25.jpg",@"26.jpg",@"27.jpg",@"28.jpg",@"29.jpg",@"30.jpg",@"31.jpg",@"32.jpg",@"33.jpg",@"34.jpg",@"35.jpg",@"36.jpg",@"37.jpg",@"38.jpg",@"39.jpg",@"40.jpg",@"41.jpg",@"42.jpg",@"43.jpg"];
    self.view.backgroundColor =[ UIColor whiteColor];



UICollectionViewFlowLayout *layoutView = [[UICollectionViewFlowLayout alloc] init];
layoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
layoutView.itemSize = CGSizeMake((WIDHT-48)/2, (w-48)/2*240/180);

self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layoutView];
self.collectionView.backgroundColor = [UIColor whiteColor];
[self.view addSubview:self.collectionView];
self.collectionView.delegate = self;
self.collectionView.dataSource = self;
[self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CGQCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CGQCollectionViewCell"];
[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer2"];
   self.collectionView.hidden = YES;

    
    //监听tableView 偏移量
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    self.refresh = [YyxHeaderRefresh header];
    
    self.refresh.tableView = self.collectionView;
    [self dd];
    CATWEAKSELF
    self.refresh.beginRefreshingBlock = ^(YyxHeaderRefresh *refreshView){
        [weakSelf dd];
    };

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIButton *releaseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    releaseButton.frame = CGRectMake(0, 25, 25, 25);
    [releaseButton addTarget:self action:@selector(toMessage) forControlEvents:UIControlEventTouchUpInside];
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:releaseButton];
    UIBarButtonItem *negativeSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    self.navigationItem.rightBarButtonItems=@[negativeSpacer2,item2];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
   
}

- (void)toMessage{
//    YKMessageVC *message = [[YKMessageVC alloc]init];
//    message.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:message animated:YES];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        [self shareWebPageToPlatformType:platformType];
//
//    }];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Facebook),@(UMSocialPlatformType_Twitter)]]; // 设置需要分享的平台
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"回调");
        NSLog(@"%ld",(long)platformType);
        NSLog(@"%@",userInfo);
        
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"共享贡献共荣共衣库" descr:@"哈哈哈哈哈,这是一条测试数据" thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = @"http://p198v6g26.bkt.clouddn.com/user/2017122637869";
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            NSLog(@"调用分享接口");
            if (error) {
                NSLog(@"调用失败%@",error);
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"调用成功");
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            //        [self alertWithError:error];
        }];
    }];
}
- (NSMutableArray *)getImageArray:(NSArray *)array{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSDictionary *imageModel in array) {
        [imageArray addObject:imageModel[@"homeImgUrl"]];
    }
    return imageArray;
}
-(void)dd{
    
    NSInteger num = 0;
    NSInteger size = 1;
    [[YKHomeManager sharedManager]getMyHomePageDataWithNum:num Size:size OnResponse:^(NSDictionary *dic) {
        self.collectionView.hidden = NO;
        self.imagesArr = [NSArray arrayWithArray:dic[@"data"][@"imgList"]];
        self.imagesArr = [self getImageArray:self.imagesArr];
        self.brandArray = [NSArray arrayWithArray:dic[@"data"][@"brandList"]];
        self.productArray = [NSArray arrayWithArray:dic[@"data"][@"productList"][@"list"]];
       
        [self.collectionView reloadData];
        
        double delayInSeconds = 0.6;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.refresh endRefreshing];
            
        });
        
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *shareDetailStr = @"衣库";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"衣库衣库" descr:shareDetailStr thumImage:[UIImage imageNamed:@"logo"]];
    
    //设置网页地址
    NSString *urlString = @"";
    //    shareObject.webpageUrl = share_travelUrl(@"");
    shareObject.webpageUrl = urlString;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
       
    }];

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
    
    if (scrollView.contentOffset.y>100) {
        self.refresh.hidden = YES;
    }else {
        self.refresh.hidden = NO;
    }

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.productArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CGQCollectionViewCell" forIndexPath:indexPath];
    YKProduct *procuct = [[YKProduct alloc]init];
    [procuct initWithDictionary:self.productArray[indexPath.row]];
    cell.product = procuct;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
//    if (section==0) {
        return CGSizeMake(WIDHT, WIDHT*0.55 +200 +60);
//    }else {
//         return CGSizeMake(self.view.frame.size.width, 60);
//    }
}

#pragma mark - scrollViewDelegate
-(void)scrollViewImageClick:(WMHCustomScroll *)WMHView{
    NSLog(@"%.f",WMHView.WMHScroll.contentOffset.x / WIDHT - 1);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        headerView.backgroundColor =[UIColor whiteColor];

        //banner图
            ZYCollectionView * cycleView = [[ZYCollectionView alloc]initWithFrame:CGRectMake(0,0,WIDHT, self.view.frame.size.width*0.55)];
            cycleView.imagesArr = self.imagesArr;
            cycleView.delegate  = self;
            cycleView.placeHolderImageName = @"banner.jpg";
            [headerView addSubview:cycleView];
        WeakSelf(weakSelf)
        
        //品牌
            _scroll=  [[NSBundle mainBundle] loadNibNamed:@"YKScrollView" owner:self options:nil][0];
            _scroll.frame = CGRectMake(0, WIDHT*0.55,WIDHT, 200);
            [_scroll resetUI];
        _scroll.brandArray = [NSMutableArray arrayWithArray:self.brandArray];
            _scroll.clickALLBlock = ^(){
                YKALLBrandVC *brand = [YKALLBrandVC new];
                brand.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:brand animated:YES];
            };
        _scroll.toDetailBlock = ^(NSString *brandId){
            NSLog(@"所点品牌ID:%@",brandId);
            YKBrandDetailVC *brand = [YKBrandDetailVC new];
            brand.hidesBottomBarWhenPushed = YES;
            brand.brandId = brandId;
            
            [weakSelf.navigationController pushViewController:brand animated:YES];
        };
            [headerView addSubview:_scroll];
        
        //推荐标题
            YKRecommentTitleView  *ti =  [[NSBundle mainBundle] loadNibNamed:@"YKRecommentTitleView" owner:self options:nil][0];
            ti.frame = CGRectMake(0, WIDHT*0.55+200,WIDHT, 60);
            [headerView addSubview:ti];
            return headerView;
        }
    
    return nil;
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16, 16, 16, 16);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.row);
    CGQCollectionViewCell *cell = (CGQCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    YKProductDetailVC *detail = [[YKProductDetailVC alloc]init];
    detail.productId = cell.goodsId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index === %ld",indexPath.row);

}
- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
    
}

//- (NSArray *)imagesArr {
//    if (!_imagesArr) {
//        NSString * url1 = @"http://pic.newssc.org/upload/news/20161011/1476154849151.jpg";
//        NSString * url2 = @"http://img.mp.itc.cn/upload/20160328/f512a3a808c44b1ab9b18a96a04f46cc_th.jpg";
//        NSString * url3 = @"http://p1.ifengimg.com/cmpp/2016/10/10/08/f2016fa9-f1ea-4da5-a0f5-ba388de46a96_size80_w550_h354.JPG";
//        NSString * url4 = @"http://image.xinmin.cn/2016/10/11/6150190064053734729.jpg";
//        NSString * url5 = @"http://imgtu.lishiquwen.com/20160919/63e053727778a18993545741f4028c67.jpg";
//        NSString * url6 = @"http://imgtu.lishiquwen.com/20160919/590346287e6e45faf1070a07159314b7.jpg";
////        _imagesArr = [NSArray arrayWithObjects: url1, url2, url3, url4, url5, url6, nil];
//        
//        _imagesArr = [NSArray arrayWithObjects:@"banner1.jpg",@"banner2.jpg",@"banner3.jpg",@"banner4.jpg",@"banner5.jpg",nil];
//    }
//    return _imagesArr;
//}
@end
