//
//  YKOrderManager.m
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKOrderManager.h"

@interface YKOrderManager()
{
    int i;
}
@end
@implementation YKOrderManager

+ (YKOrderManager *)sharedManager{
    static YKOrderManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (NSMutableArray *)totalOrderList{
    if (!_totalOrderList) {
        _totalOrderList = [NSMutableArray array];
    }
    return _totalOrderList;
}

- (NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (NSMutableArray *)handleArrayWithArry:(NSMutableArray *)suitArray{
    NSMutableArray *suitIdList = [NSMutableArray array];
    for (YKSuit *suit in suitArray) {
        [suitIdList addObject:suit.shoppingCartId];
    }
    return suitIdList;
}

- (void)releaseOrderWithAddress:(YKAddress *)address
             shoppingCartIdList:(NSMutableArray *)shoppingCartIdList
                       cardType:(NSInteger)cardType
                     OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSDictionary *dic = @{@"addressId":address.addressId,@"shoppingCartIdList":[self handleArrayWithArry:shoppingCartIdList],@"cardType":@(cardType)};
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"POST" URLString:releaseOrder_Url paramers:dic success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] != 200) {
            if (onResponse) {
                onResponse(dict);
            }
            return ;
        }
        
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"订单提交成功" delay:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (onResponse) {
                    onResponse(dict);
                }
                
            });
            
        });
    } failure:^(NSError *error) {
        
    }];
}

//此接口后台返回的数据太乱（TODO：优化接口）
- (void)searchOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSMutableArray *array))onResponse{
    
    switch (status) {
        case 100:
            status=0;//全部衣袋
            break;
        case 101:
            status=3;//待签收(待发货,待签收)
            break;
        case 102:
            status=4;//待归还
            break;
        case 103:
            status=5;//已归还
            break;
        default:
            break;
    }
    
    //待签收:包括待配货,待发货和待签收>>>查询3待签收,先查看1待配货 2,待发货
    if (status==3) {
        [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
        NSInteger s = 1;
        NSString *str = [NSString stringWithFormat:@"%@?orderStatus=%ld",queryOrder_Url,(long)s];
        [YKHttpClient Method:@"GET" apiName:str Params:nil Completion:^(NSDictionary *dic) {
            [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
            NSMutableArray *listArray;
            NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"data"]];
            if (array.count!=0) {//待配货有数据
                _isOnRoad = NO;//未发货
                listArray = [NSMutableArray arrayWithArray:array[0][@"orderDetailsVoList"]];
                _orderNo = dic[@"data"][0][@"orderNo"];
                _ID = dic[@"data"][0][@"id"];
                
                if (onResponse) {
                    onResponse(listArray);
                }
                
            }else {//没有待配货的1,查询待发货2
                
                NSInteger s = 2;
                NSString *url = [NSString stringWithFormat:@"%@?orderStatus=%ld",queryOrder_Url,(long)s];
                [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
                    NSMutableArray *listArray;
                    
                    NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
                    if (array.count>0) {//待发货有数据
                        _isOnRoad = NO;
                        listArray = [NSMutableArray arrayWithArray:dic[@"data"][0][@"orderDetailsVoList"]];
                        _orderNo = dic[@"data"][0][@"orderNo"];
                        _ID = dic[@"data"][0][@"id"];
                        if (onResponse) {
                            onResponse(listArray);
                        }
                    }else {//待发货没数据,查询待签收
                        listArray = [NSMutableArray array];//
                        NSString *url = [NSString stringWithFormat:@"%@?orderStatus=%ld",queryOrder_Url,(long)status];
                        [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
                            NSMutableArray *listArray;
                            
                            NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
                            if (array.count>0) {//待签收有数据
                                _isOnRoad = YES;
                                listArray = [NSMutableArray arrayWithArray:dic[@"data"][0][@"orderDetailsVoList"]];
                                _orderNo = dic[@"data"][0][@"orderNo"];
                                _ID = dic[@"data"][0][@"id"];
                                if (onResponse) {
                                    onResponse(listArray);
                                }
                                
                            }else {//待发货没数据
                                _isOnRoad = NO;
                                listArray = [NSMutableArray array];
                                if (onResponse) {
                                    onResponse(listArray);
                                }
                            }
                            
                            
                        }];
                    }
                    
                }];
                
            }
            
        }];
        
    }else {//不是查询待签收
        [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
        NSString *str = [NSString stringWithFormat:@"%@?orderStatus=%ld",queryOrder_Url,(long)status];
        [YKHttpClient Method:@"GET" apiName:str Params:nil Completion:^(NSDictionary *dic) {
            
            [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
            if ([dic[@"status"] integerValue] == 200) {
                NSArray *array = [NSArray arrayWithArray:dic[@"data"]];
                if (array.count == 0) {
                    if (onResponse) {
                        onResponse(nil);
                    }
                    return ;
                }
                
                if (status==0) {//全部衣袋
                    [self groupWithDictionary:dic groupDoneBlock:^(void) {
                        if (onResponse) {
                            onResponse(nil);
                        }
                    }];
                }else {
                    NSMutableArray *listArray;
                    if (dic[@"data"]) {
                        if (status==5) {//已归还
                            NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"data"]];
                            NSMutableArray *totalArray = [NSMutableArray array];
                            //合并到大数组里
                            for (int index=0; index<array.count; index++) {
                                if (listArray.count==0) {
                                    listArray = array[0][@"orderDetailsVoList"];
                                    totalArray = listArray;
                                }else {
                                    NSArray *a = [NSArray arrayWithArray:array[index][@"orderDetailsVoList"]];
                                    for (int i=0; i<a.count; i++) {
                                        [totalArray addObject:array[index][@"orderDetailsVoList"][i]];
                                    }
                                }
                            }
                            
                            listArray = [NSMutableArray arrayWithArray:totalArray];
                            
                        }else {//待归还
                            
                            listArray = [NSMutableArray arrayWithArray:dic[@"data"]];
                                _orderNo = dic[@"data"][0][@"orderNo"];
                                _ID = dic[@"data"][0][@"id"];
                            
                        }
                    }else {
                        listArray = [NSMutableArray array];
                    }
                    
                    if (onResponse) {
                        onResponse(listArray);
                    }
                }
            }
            
        }];
        
    }
    
}

//物流信息(顺丰)
- (void)searchForSMSInforWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSArray *array))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?orderNo=%@",queryOrderSMSInfor_Url,orderNo];
    
    [YKHttpClient Method:@"POST" URLString:url paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        //最新一条
        NSArray *arr;
        if (![dict[@"msg"] isEqualToString:@"没有该订单信息"]) {
           arr = [NSArray arrayWithArray:dict[@"data"][@"body"]];
        }
        
        if (arr.count == 0) {//未查到物流信息
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"未查到物流信息" delay:2];
            return ;
        }
        
        NSDictionary *model;
        if (arr.count>0) {
            model = [NSDictionary dictionaryWithDictionary:arr[0]];
            _sfOrderId = model[@"mailNo"];
        }
        
        NSInteger SMSStatus = [model[@"opcode"] integerValue];
        
        switch (SMSStatus) {
            case 50:
                self.SMSStatus = @"已收件";
                break;
            case 30:
                self.SMSStatus = @"运输中";
                break;
            case 31:
                self.SMSStatus = @"运输中";
                break;
            case 44:
                self.SMSStatus = @"正在派件";
                break;
            case 70:
                self.SMSStatus = @"派件不成功";
                break;
            case 80:
                self.SMSStatus = @"派件成功";
                break;
            case 8000:
                self.SMSStatus = @"已签收";
                break;
            case 123:
                self.SMSStatus = @"便利店出仓";
                break;
            case 130:
                self.SMSStatus = @"便利店交接";
                break;
            case 607:
                self.SMSStatus = @"代理收件";
                break;
                
            default:
                self.SMSStatus = @"未知";
                break;
        }
        
        if (onResponse) {
            onResponse(arr);
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

//查询物流信息(中通)
- (void)searchForZTSMSInforWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSArray *array))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?orderNo=%@",queryOrderZTSMSInfor_Url,orderNo];
    
    [YKHttpClient Method:@"POST" URLString:url paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        //最新一条
        NSArray *arr;
        if (![dict[@"data"][@"msg"] isEqualToString:@"暂无运单信息"]) {
            arr = [NSArray arrayWithArray:dict[@"data"][@"data"]];
        }
        
        if (arr.count == 0) {//未查到物流信息
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"未查到物流信息" delay:2];
            return ;
        }
        
        NSDictionary *model;
        if (arr.count>0) {
            model = [NSDictionary dictionaryWithDictionary:arr[0]];
            _sfOrderId = model[@"mailNo"];
        }
        
        NSInteger SMSStatus = [model[@"opcode"] integerValue];
        
        switch (SMSStatus) {
            case 50:
                self.SMSStatus = @"已收件";
                break;
            case 30:
                self.SMSStatus = @"运输中";
                break;
            case 31:
                self.SMSStatus = @"运输中";
                break;
            case 44:
                self.SMSStatus = @"正在派件";
                break;
            case 70:
                self.SMSStatus = @"派件不成功";
                break;
            case 80:
                self.SMSStatus = @"派件成功";
                break;
            case 8000:
                self.SMSStatus = @"已签收";
                break;
            case 123:
                self.SMSStatus = @"便利店出仓";
                break;
            case 130:
                self.SMSStatus = @"便利店交接";
                break;
            case 607:
                self.SMSStatus = @"代理收件";
                break;
                
            default:
                self.SMSStatus = @"未知";
                break;
        }
        
        if (onResponse) {
            onResponse(arr);
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

//确认收货
- (void)ensureReceiveWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [self clear];
    
    NSString *url = [NSString stringWithFormat:@"%@?orderNo=%@",ensureReceiveOrder_Url,orderNo];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {//成功确认收货
        
            [smartHUD alertText:kWindow alert:@"签收成功" delay:1.0];
            if (onResponse) {
                onResponse(dic);
            }
            
        }else {
            [smartHUD alertText:kWindow alert:dic[@"msg"] delay:1.0];
        }
    }];
}

//测试用
- (void)toReceiveWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [self clear];
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@&orderStatus=%@",ensureReceiveOrder_Url,orderNo,@"5"];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:2];
        
        if ([dic[@"status"] integerValue] == 200) {
            
            if (onResponse) {
                onResponse(dic);
            }
            
        }
    }];
}

//预约归还
- (void)orderReceiveWithOrderNo:(NSString *)orderNo addressId:(NSString *)addressId time:(NSString *)time OnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?orderNo=%@&addressId=%@",orderReceiveOrder_Url,self.orderNo,addressId];
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dic[@"status"] integerValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"预约成功" delay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if (onResponse) {
                        onResponse(dic);
                    }
                    
                });
                
            });
            
        }
        
    }];
}

//有待归还的时候查询是否已预约归还
- (void)queryReceiveOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@",isHadOrderReceiveOrder_Url,orderNo];
    
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] integerValue] == 200) {
            
            if (onResponse) {
                onResponse(dic);
            }
            
        }
    }];
}

//分组
- (void)groupWithDictionary:(NSDictionary *)dic groupDoneBlock:(void (^)(void))groupDoneBlock; {
    
    NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"]];
    NSMutableArray *totlaList = [NSMutableArray array];
    NSMutableArray *receiveList = [NSMutableArray array];//存储待签收
    NSMutableArray *backList = [NSMutableArray array];//存储待归还(di'yi'd)
    NSMutableArray *backList2 = [NSMutableArray array];//存储待归还(第二单)

    NSMutableArray *hadBackList = [NSMutableArray array];//存储已归还
    
    for (NSDictionary *model in currentArray) {
        
        //不是4,5,8的状态全部放入待签收
        if ([model[@"orderStatus"] intValue] != 5 && [model[@"orderStatus"] intValue] != 4 && [model[@"orderStatus"] intValue] != 8 ){
            
            //如果状态有1或2,存在待配货或待发货的订单
            if ([model[@"orderStatus"] intValue] == 1 || [model[@"orderStatus"] intValue] == 2 ){
                _isOnRoad = NO;
            }else {//状态为3(待签收)已发货
                _isOnRoad = YES;
            }
            
            self.orderNo = model[@"orderNo"];
            self.orderNo = model[@"orderNo"];
            self.ID = model[@"id"];
            receiveList = [NSMutableArray arrayWithArray:model[@"orderDetailsVoList"]];
        }if ([model[@"orderStatus"] intValue] == 4) {//待归还
            self.orderNo = model[@"orderNo"];
            self.ID = model[@"id"];
            
            if (backList.count>0) {//第二个待归还
                [backList2 addObject:model[@"orderDetailsVoList"]];
                
            }else {
                //第一个待归还
                [backList addObject:model[@"orderDetailsVoList"]];
            }
            
           }else if([model[@"orderStatus"] intValue] == 5 || [model[@"orderStatus"] intValue] == 8) {//已归还
            
            if (hadBackList.count > 0 ) {
                [totlaList removeObject:hadBackList];
                NSMutableArray *totalArray = [NSMutableArray arrayWithArray:hadBackList[0]];
                
                NSArray *array = [NSArray arrayWithArray:model[@"orderDetailsVoList"]];
                for (int index=0; index<array.count; index++) {
                    [totalArray addObject:array[index]];
                }
                [hadBackList removeAllObjects];
                [hadBackList insertObject:totalArray atIndex:0];
            }else {
                [hadBackList addObject:model[@"orderDetailsVoList"]];
            }
        }
        
        if (receiveList.count>0&&![totlaList containsObject:receiveList]) {
            [totlaList insertObject:receiveList atIndex:0];   
            if (![self.sectionArray containsObject:receiveSection]) {
                [self.sectionArray addObject:receiveSection];
            }
        }
        
        if (backList.count>0&&![totlaList containsObject:backList]) {
            [totlaList insertObject:backList atIndex:0];
            [self.sectionArray addObject:backSection];
        }
        
        if (backList2.count>0&&![totlaList containsObject:backList2]) {
            [totlaList insertObject:backList2 atIndex:0];
                [self.sectionArray addObject:backSection];
        }
        
        if (hadBackList.count>0&&![totlaList containsObject:hadBackList]) {
            [totlaList addObject:hadBackList];
            if (![self.sectionArray containsObject:hadBackSection]) {
                [self.sectionArray addObject:hadBackSection];
            }
        }
    }
    
    NSArray *resultArray = [self.sectionArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2]; //升序
        
    }];
    
    self.sectionArray = [NSMutableArray arrayWithArray:resultArray];
    
    self.totalOrderList = totlaList;
    
    if (groupDoneBlock) {//分组完毕
        groupDoneBlock();
    }
    
}

- (void)creatSfOrderWithOrderNum:(NSString *)orderNum OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@",creatSFOrder_Url,self.orderNo];
    
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] integerValue] == 200) {
            
            if (onResponse) {
                onResponse(dic);
            }
            
        }
    }];
    
}

- (void)clear{
    [[YKOrderManager sharedManager].totalOrderList removeAllObjects];
    [[YKOrderManager sharedManager].sectionArray removeAllObjects];
    [YKOrderManager sharedManager].orderNo = nil;
    [YKOrderManager sharedManager].ID = nil;
}

//
- (void)searchBeHistoryOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *str = [NSString stringWithFormat:@"%@?orderState=%ld",newQueryOrder_Url,(long)status];
    [YKHttpClient Method:@"GET" apiName:str Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
   
      
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}
//查询历史订单(新接口)
- (void)searchHistoryOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSArray     *array))onResponse{
 
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
   
    NSString *str = [NSString stringWithFormat:@"%@?orderState=%ld",newQueryOrder_Url,(long)status];
    [YKHttpClient Method:@"GET" apiName:str Params:nil Completion:^(NSDictionary *dic) {
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if (status == 0) {//全部衣袋
            [self groupOrderWithDictionary:dic groupDoneBlock:^{
                if (onResponse) {
                    onResponse(nil);
                }
            }];
            
            return ;
        }
        
        if (status == 1) {//待签收
            NSMutableArray *list = [NSMutableArray arrayWithArray:dic[@"data"][@"userOrderVoList"]];
            NSMutableArray *arr = [NSMutableArray array];
           
            for (NSDictionary *model in list) {
                NSArray *a = [NSArray arrayWithArray:model[@"userOrderDetailsVoList"]];
                [arr addObjectsFromArray:a];
            }
            
            NSDictionary *dic;
            if (list.count!=0) {
                 dic = [NSDictionary dictionaryWithDictionary:list[0]];
                _orderNo = list[0][@"orderNo"];
                
                if ([dic[@"sendTime"] isEqual:[NSNull null]]) {//是否发货
                    _isOnRoad = NO;
                    
                }else {
                    _isOnRoad = YES;
                }
            }
            
            
            
            if (onResponse) {
                onResponse(arr);
            }
            return;
        }
       
        
        if (status == 2) {//待归还
            NSLog(@"%@",dic);
            NSMutableArray *list = [NSMutableArray arrayWithArray:dic[@"data"][@"userOrderVoList"]];
            if (list.count==0) {
                if (onResponse) {
                    onResponse(list);
                }
                return ;
            }
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSDictionary *model in list) {
                NSArray *a = [NSArray arrayWithArray:model[@"userOrderVoList"]];
                [arr addObjectsFromArray:a];
            }
//            listArray = [NSMutableArray arrayWithArray:dic[@"data"]];
//            _orderNo = dic[@"data"][0][@"orderNo"];
//            _ID = dic[@"data"][0][@"id"];
//            NSDictionary *dic;
//            if (list.count!=0) {
//                dic = [NSDictionary dictionaryWithDictionary:list[0]];
//                _orderNo = list[0][@"orderNo"];
//
//                if ([dic[@"sendTime"] intValue] > 0) {//是否发货
//                    _isOnRoad = YES;
//
//                }else {
//                    _isOnRoad = NO;
//                }
//            }
            
            
            
            if (onResponse) {
                onResponse(list);
            }
        }
//        NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"userOrderVoList"]];
//        if (onResponse) {
//            onResponse(nil);
//        }

        if (status == 3) {//待归还
            NSLog(@"%@",dic);
            NSMutableArray *list = [NSMutableArray arrayWithArray:dic[@"data"][@"userOrderVoList"]];
            if (list.count==0) {
                if (onResponse) {
                    onResponse(list);
                }
                return ;
            }
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSDictionary *model in list) {
                NSArray *a = [NSArray arrayWithArray:model[@"userOrderDetailsVoList"]];
                [arr addObjectsFromArray:a];
            }
            //            listArray = [NSMutableArray arrayWithArray:dic[@"data"]];
            //            _orderNo = dic[@"data"][0][@"orderNo"];
            //            _ID = dic[@"data"][0][@"id"];
            //            NSDictionary *dic;
            //            if (list.count!=0) {
            //                dic = [NSDictionary dictionaryWithDictionary:list[0]];
            //                _orderNo = list[0][@"orderNo"];
            //
            //                if ([dic[@"sendTime"] intValue] > 0) {//是否发货
            //                    _isOnRoad = YES;
            //
            //                }else {
            //                    _isOnRoad = NO;
            //                }
            //            }
            
            
            
            if (onResponse) {
                onResponse(arr);
            }
        }
    }];
}

//分组
- (void)groupOrderWithDictionary:(NSDictionary *)dic groupDoneBlock:(void (^)(void))groupDoneBlock; {
    
    NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"][@"userOrderVoList"]];
    NSMutableArray *totlaList = [NSMutableArray array];
    NSMutableArray *receiveList = [NSMutableArray array];//存储待签收
    NSMutableArray *backList = [NSMutableArray array];//存储待归还(di'yi'd)
    NSMutableArray *backList2 = [NSMutableArray array];//存储待归还(第二单)
    
    NSMutableArray *hadBackList = [NSMutableArray array];//存储已归还
    
    for (NSDictionary *model in currentArray) {
        
        //不是4,5,8的状态全部放入待签收
        if ([model[@"orderState"] intValue] == 1){
            
            //如果状态有1或2,存在待配货或待发货的订单
            if ([model[@"orderState"] intValue] == 1 || [model[@"orderState"] intValue] == 2 ){
                _isOnRoad = NO;
            }else {//状态为3(待签收)已发货
                _isOnRoad = YES;
            }
         
            self.orderNo = model[@"orderNo"];
            self.ID = model[@"id"];
            receiveList = [NSMutableArray arrayWithArray:model[@"userOrderDetailsVoList"]];
        }if ([model[@"orderState"] intValue] == 2) {//待归还
            self.orderNo = model[@"orderNo"];
            self.ID = model[@"id"];
            
            if (backList.count>0) {//第二个待归还
                [backList2 addObject:model[@"userOrderDetailsVoList"]];
                
            }else {
                //第一个待归还
                [backList addObject:model[@"userOrderDetailsVoList"]];
            }
            
        }else if([model[@"orderState"] intValue] == 3) {//已归还
            
            if (hadBackList.count > 0 ) {
                [totlaList removeObject:hadBackList];
                NSMutableArray *totalArray = [NSMutableArray arrayWithArray:hadBackList[0]];
                
                NSArray *array = [NSArray arrayWithArray:model[@"userOrderDetailsVoList"]];
                for (int index=0; index<array.count; index++) {
                    [totalArray addObject:array[index]];
                }
                [hadBackList removeAllObjects];
                [hadBackList insertObject:totalArray atIndex:0];
            }else {
                [hadBackList addObject:model[@"userOrderDetailsVoList"]];
            }
        }
        
        if (receiveList.count>0&&![totlaList containsObject:receiveList]) {
            [totlaList insertObject:receiveList atIndex:0];
            if (![self.sectionArray containsObject:receiveSection]) {
                [self.sectionArray addObject:receiveSection];
            }
        }
        
        if (backList.count>0&&![totlaList containsObject:backList]) {
            [totlaList insertObject:backList atIndex:0];
            [self.sectionArray addObject:backSection];
        }
        
        if (backList2.count>0&&![totlaList containsObject:backList2]) {
            [totlaList insertObject:backList2 atIndex:0];
            [self.sectionArray addObject:backSection];
        }
        
        if (hadBackList.count>0&&![totlaList containsObject:hadBackList]) {
            [totlaList addObject:hadBackList];
            if (![self.sectionArray containsObject:hadBackSection]) {
                [self.sectionArray addObject:hadBackSection];
            }
        }
    }
    
    NSArray *resultArray = [self.sectionArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2]; //升序
        
    }];
    
    self.sectionArray = [NSMutableArray arrayWithArray:resultArray];
    
    self.totalOrderList = totlaList;
    
    if (groupDoneBlock) {//分组完毕
        groupDoneBlock();
    }
    
}


@end
