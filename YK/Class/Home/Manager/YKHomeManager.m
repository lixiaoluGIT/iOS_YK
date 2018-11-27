//
//  YKHomeManager.m
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKHomeManager.h"
#import "YKShareVC.h"
#import "YKInvitVC.h"
#import "YKHomeAleartView.h"

@implementation YKHomeManager

+ (YKHomeManager *)sharedManager{
    static YKHomeManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//home page
- (void)getMyHomePageDataWithNum:(NSInteger)Num Size:(NSInteger)Size
                      OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?num=1&size=%ld",GetHomePage_Url,Size];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
        
        
    }];
}

//品牌详情
- (void)getBrandDetailInforWithBrandId:(NSInteger)brandId
                            OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    //    NSDictionary *dic = @{@"brandId":@"12"};
    NSString *url = [NSString stringWithFormat:@"%@?brandId=%ld",GetBrandDetail_Url,brandId];
    //    NSLog(@"%@",dic);
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

- (void)getBrandPageByCategoryWithBrandId:(NSString *)brandId categoryId:(NSString *)categoryId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?brandId=%@&categoryId=%@",GetBrandPageByCategory_Url,brandId,categoryId];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        if (array.count == 0) {
            //            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"暂无相关商品" delay:1.2];
        }
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

//获取品牌列表
- (void)getBrandListStatus:(NSInteger)status OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    if (status==0) {
//        [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    
//    self.brandList = [NSMutableArray arrayWithArray:dic[@"data"][@"brandVoList"]];
    
    [YKHttpClient Method:@"GET" apiName:getBrandList_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        self.brandList = [NSMutableArray arrayWithArray:dic[@"data"][@"brandVoList"]];
        NSThread *thread=[[NSThread alloc]initWithTarget:self selector:@selector(groupArray) object:nil];
        thread.name=[NSString stringWithFormat:@"group"];//设置线程名称
        [thread start];
//        [self group:self.brandList];
        if (onResponse) {
            onResponse(dic);
        }
        
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


- (void)groupArray{
    NSLog(@"进来了》〉》〉》〉》〉》〉》〉》〉");
    
    NSMutableArray *indexArray = [NSMutableArray array];
    for (NSDictionary *blacker in self.brandList) {
        NSString *firstChar = [self firstCharactor:blacker[@"brandName"]];
        if ([firstChar characterAtIndex:0] < 'A' || [firstChar characterAtIndex:0] > 'Z') {
            if (![indexArray containsObject:@"#"]) {
                [indexArray addObject:@"#"];
            }
        }else {
            if (![indexArray containsObject:firstChar]) {
                [indexArray addObject:[NSString stringWithFormat:@"%@",firstChar]];
            }
        }
    }
    
    NSArray *result = [indexArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    //得到角标
    _searchBtnArr = [NSArray arrayWithArray:result];
    NSLog(@"索引栏==%@",_searchBtnArr);
    
    NSMutableArray *totalSections = [NSMutableArray array];
    for (NSString *cha in _searchBtnArr) {
        NSLog(@"首字母%@",cha);
        NSMutableArray *sections = [NSMutableArray array];
        for (NSDictionary *blacker in self.brandList) {
            
            if (![cha isEqualToString:@"#"] && [[self firstCharactor:blacker[@"brandName"]] isEqualToString:cha]) {
                [sections addObject:blacker];
            }
            
            if (([cha isEqualToString:@"#"] && [[self firstCharactor:blacker[@"brandName"]] characterAtIndex:0] < 'A') || [[self firstCharactor:blacker[@"brandName"]] characterAtIndex:0] > 'Z'){
                [sections addObject:blacker];
            }
        }
        [totalSections addObject:sections];
        
    }
    //    [totalSections addObject:sections];
    self.sections = [NSArray arrayWithArray:totalSections];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/myJson.json"];
    NSLog(@"%@",filePath);
    NSDictionary *json_dic = @{@"arr":self.sections,@"a":_searchBtnArr};//key为arr value为arr数组的字典
    //    第三步.封包数据
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
    
    //    第四步.写入数据
    [json_data writeToFile:filePath atomically:YES];
    NSLog(@"出去了》〉》〉》〉》〉》〉》〉》〉");
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
//获取商品详情
- (void)getProductDetailInforWithProductId:(NSInteger )ProductId type:(NSInteger)type
                                OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url;
    if (type==0) {//衣服
        url = [NSString stringWithFormat:@"%@?clothing_id=%ld&userId=%@",GetProductDetail_Url,ProductId,[Token length]>0 ? [YKUserManager sharedManager].user.userId : @""];
    }else {//配饰
        url = [NSString stringWithFormat:@"%@?ornamentId=%ld&userId=%@",PSDetail_Url,ProductId,[Token length]>0 ? [YKUserManager sharedManager].user.userId : @""];
    }
  
        [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
       
            if ([dic[@"status"] intValue] == 200) {
                if (onResponse) {
                    onResponse(dic);
                }
            }else {
                [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:1.5];
            }
       
        
    }];
}

//分页请求商品
- (void)requestForMoreProductsWithNumPage:(NSInteger)numPage typeId:(NSString *)typeId sortId:(NSString *)sortId sytleId:(NSString *)sytleId brandId:(NSString *)brandId OnResponse:(void (^)(NSArray *array))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?page=%ld&size=%d&typeId=%@&sortId=%@&styleId=%@&brandId=%@",GetMoreProduct_Url,numPage,10,typeId,sortId,sytleId,brandId];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
        if (array.count == 0) {
            
        }
        
        if (onResponse) {
            onResponse(array);
        }
        
    }];
}

//弹出分享提示框
- (void)showAleartViewToShare{
    //暂时取消掉
//    [self appear];
}

- (NSString *)getTimeNow{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    return date;
}
- (void)saveCurrentTime{
    [UD setObject:[self getTimeNow] forKey:@"lastAleartTime"];
}

//判断时间是否在一天
- (BOOL)timeGpIsOK{
    if ([[self getTimeNow] isEqualToString:[UD objectForKey:@"lastAleartTime"]]) {
        return NO;
    }
    return YES;
}

- (void)appear{
    if ([Token length] == 0) {//未登录
        return;
    }
    if (![self timeGpIsOK]) {
        return;
    }
    
    if ([Token length]>0) {//已登录
        [[YKUserManager sharedManager]getUserInforOnResponse:^(NSDictionary *dic) {
            //如果已经分享过
            if ([[YKUserManager sharedManager].user.isShare intValue] == 1) {
                return ;
            }
            //如果是老会员并且会员少于7天
            if ([[YKUserManager sharedManager].user.effective intValue] == 4) {
                //弹出分享
                DDAleartView *aleart = [[DDAleartView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
                
                [aleart showWithImage:[UIImage imageNamed:@"hongbao"] title:@"" detailTitle:@"分享后立减150元" notitle:@"取消" yestitle:@"查看" color:mainColor type:2 cancelBlock:^{
                    
                } ensureBlock:^{
                    YKShareVC *share = [YKShareVC new];
                    share.hidesBottomBarWhenPushed = YES;
                    [[self getCurrentVC].navigationController pushViewController:share animated:YES];
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:aleart];
                
                [UD setBool:YES forKey:@"appearShare"];
                [UD synchronize];
                
                [self saveCurrentTime];
            }else {
                if ([[YKUserManager sharedManager].user.validity intValue] <= 7) {
                    //弹出分享
                    DDAleartView *aleart = [[DDAleartView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
                    
                    [aleart showWithImage:[UIImage imageNamed:@"huiyuan-2"] title:@"" detailTitle:@"分享延长会员日期" notitle:@"取消" yestitle:@"查看" color:mainColor type:2 cancelBlock:^{
                        
                    } ensureBlock:^{
                        YKShareVC *share = [YKShareVC new];
                        share.hidesBottomBarWhenPushed = YES;
                        [[self getCurrentVC].navigationController pushViewController:share animated:YES];
                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:aleart];
                    [UD setBool:YES forKey:@"appearShare"];
                    [UD synchronize];
                    
                    [self saveCurrentTime];
                }
            }
        }];
    }
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
        else{
            result = window.rootViewController;
        }
    }
    else{
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    
    return result;
}

- (NSArray *)getSizeArray:(NSArray *)array{
    NSMutableArray *sizeArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSMutableArray *typeArray = [NSMutableArray array];
        if ([dic[@"type"] intValue] == 1) {//上装（衣长，胸围，肩宽，袖长）
            
            [typeArray addObject:dic[@"model"]];
            [typeArray addObject:dic[@"chestWidth"]];
            [typeArray addObject:dic[@"clothesLength"]];
            [typeArray addObject:dic[@"shoulderWidth"]];
            [typeArray addObject:dic[@"sleeveLength"]];
            
            [sizeArray addObject:typeArray];
        }
        
        if ([dic[@"type"] intValue] == 2) {//下装（裤长，腰围，臀围）
            [typeArray addObject:dic[@"model"]];
            [typeArray addObject:dic[@"trousersLength"]];
            [typeArray addObject:dic[@"waistline"]];
            [typeArray addObject:dic[@"hipline"]];
            
            
            [sizeArray addObject:typeArray];
        }
        if ([dic[@"type"] intValue] == 3) {//裙子（裙长，胸围，腰围，肩宽，袖长）
            [typeArray addObject:dic[@"model"]];
            [typeArray addObject:dic[@"skirtLength"]];
            [typeArray addObject:dic[@"chestWidth"]];
            [typeArray addObject:dic[@"waistline"]];
            [typeArray addObject:dic[@"shoulderWidth"]];
            [typeArray addObject:dic[@"sleeveLength"]];
            
            [sizeArray addObject:typeArray];
            
        }
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:array[0]];
    if ([dic[@"type"] intValue] == 1) {
        [sizeArray insertObject:@[@"尺码",@"胸围",@"衣长",@"肩宽",@"袖长"] atIndex:0];
    }
    if ([dic[@"type"] intValue] == 2) {
        [sizeArray insertObject:@[@"尺码",@"裤长",@"腰围",@"臀围"] atIndex:0];
    }
    if ([dic[@"type"] intValue] == 3) {
        [sizeArray insertObject:@[@"尺码",@"裙长",@"胸围",@"腰围",@"肩宽",@"袖长"] atIndex:0];
    }
    
    return sizeArray;
}

//得到用户尺码表
- (NSArray *)getUserSizeArray:(NSDictionary *)dic{
    NSMutableArray *sizeArray = [NSMutableArray array];
//    for (NSDictionary *dic in array) {
        NSMutableArray *typeArray = [NSMutableArray array];
//        if ([dic[@"type"] intValue] == 1) {//上装（衣长，胸围，肩宽，袖长）
            [typeArray addObject:@"我的"];
            [typeArray addObject:dic[@"shoulderWidth"]];
            [typeArray addObject:dic[@"bust"]];
            [typeArray addObject:dic[@"hipline"]];
            [typeArray addObject:dic[@"theWaist"]];
//            [typeArray addObject:dic[@"shoulderWidth"]];
    
    
            [sizeArray addObject:typeArray];
//        }
    
    
            
//        }
//    }

        [sizeArray insertObject:@[@"尺码",@"肩宽",@"胸围",@"腰围",@"臀围"] atIndex:0];

    
    return sizeArray;
}

- (void)showAleart{
//    [self showPoint];
    if ([[YKUserManager sharedManager].user.isNewUser intValue] == 1) {//已付费
        return;
    }
    YKHomeAleartView *loginView = [[NSBundle mainBundle]loadNibNamed:@"YKHomeAleartView" owner:nil options:nil][0];
    loginView.frame = CGRectMake(0, HEIGHT, 0, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:loginView];
    [loginView appear];
}

- (void)showPoint{
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"悬浮窗"]];
    if (HEIGHT==812) {
        image.frame = CGRectMake(WIDHT-80, HEIGHT-150, 25, 25);
    }else {
        image.frame = CGRectMake(WIDHT-80, HEIGHT-80, 25, 25);
    }
    [image sizeToFit];
    [[UIApplication sharedApplication].keyWindow addSubview:image];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(invite)];
    [image setUserInteractionEnabled:YES];
    [image addGestureRecognizer:tap];
}

- (void)invite{
    [[self getCurrentVC].navigationController pushViewController:[YKInvitVC new] animated:YES];
    [self getCurrentVC].hidesBottomBarWhenPushed = YES;
}

//请求活动列表
- (void)getList:(NSInteger)page cid:(NSString *)cid OnResponse:(void (^)(NSArray *array))onResponse{
    
    NSInteger ci = [cid intValue];
    NSString *url;
    switch (ci) {
        case 1:
            url = [NSString stringWithFormat:@"%@?page=%d&size=%d",GetSuitList_Url,page,10];
            break;
        case 2:
            url = [NSString stringWithFormat:@"%@?page=%d&size=%d",GetFashionList_Url,page,10];
        default:
            break;
    }

    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        NSArray *array = [NSArray arrayWithArray:dic[@"data"][@"content"]];
        if (array.count == 0) {
            
        }
        
        if (onResponse) {
            onResponse(array);
        }
        
    }];
}
//请求时尚穿搭
- (void)getFashionListOn:(NSInteger)page Response:(void (^)(NSDictionary *dic))onResponse{
    
}

@end
