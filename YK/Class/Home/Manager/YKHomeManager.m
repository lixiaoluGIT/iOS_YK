//
//  YKHomeManager.m
//  YK
//
//  Created by LXL on 2017/12/1.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKHomeManager.h"
#import "YKShareVC.h"

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
    
    //    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
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
- (void)getBrandListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"GET" apiName:getBrandList_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

//获取商品详情
- (void)getProductDetailInforWithProductId:(NSInteger )ProductId
                                OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?clothing_id=%ld",GetProductDetail_Url,ProductId];
    
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

//分页请求商品
- (void)requestForMoreProductsWithNumPage:(NSInteger)numPage typeId:(NSString *)typeId sortId:(NSString *)sortId brandId:(NSString *)brandId OnResponse:(void (^)(NSArray *array))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?page=%ld&typeId=%@&sortId=%@&brandId=%@",GetMoreProduct_Url,numPage,typeId,sortId,brandId];
    
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
    [self appear];
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
                
                [aleart showWithImage:[UIImage imageNamed:@"hongbao"] title:@"" detailTitle:@"分享后立减200元" notitle:@"取消" yestitle:@"查看" color:mainColor type:2 cancelBlock:^{
                    
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
            [typeArray addObject:dic[@"clothesLength"]];
            [typeArray addObject:dic[@"chestWidth"]];
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
            [typeArray addObject:dic[@"trousersLength"]];
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
@end
