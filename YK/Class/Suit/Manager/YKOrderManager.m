//
//  YKOrderManager.m
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKOrderManager.h"

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
                     OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    

    NSDictionary *dic = @{@"addressId":address.addressId,@"shoppingCartIdList":[self handleArrayWithArry:shoppingCartIdList]};
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"POST" URLString:releaseOrder_Url paramers:dic success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] != 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2];
            
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

- (void)searchOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSMutableArray *array))onResponse{
    
    switch (status) {
        case 100:
            status=0;//全部衣袋
            break;
        case 101:
            status=2;//待签收
            break;
        case 102:
            status=3;//待归还
            break;
        case 103:
            status=5;//已归还
            break;
        default:
            break;
    }
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
                        
                    }else {//待签收或待归还
                        listArray = [NSMutableArray arrayWithArray:dic[@"data"][0][@"orderDetailsVoList"]];
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

//物流信息
- (void)searchForSMSInforWithOrderNo:(NSString *)orderNo OnResponse:(void (^)(NSArray *array))onResponse{

    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?orderNo=%@",queryOrderSMSInfor_Url,orderNo];
    
    [YKHttpClient Method:@"POST" URLString:url paramers:nil success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dict[@"status"] intValue] != 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2];
       
            return ;
        }
       
        //最新一条
        NSArray *arr = [NSArray arrayWithArray:dict[@"data"][@"body"]];
        
        NSDictionary *model;
        if (arr.count>0) {
            model = [NSDictionary dictionaryWithDictionary:arr[0]];
        }
        
        
        NSInteger SMSStatus = [model[@"opcode"] integerValue];
        
        switch (SMSStatus) {
            case 50:
                self.SMSStatus = @"已收件";
                break;
            case 3036:
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
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@&orderStatus=%@",ensureReceiveOrder_Url,orderNo,@"3"];
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
    
    NSString *url = [NSString stringWithFormat:@"%@?orderNo=%@&addressId=%@&time=%@",orderReceiveOrder_Url,self.orderNo,addressId,time];
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dic[@"msg"] delay:2];
        
        if ([dic[@"status"] integerValue] == 200) {
            
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
- (void)queryReceiveOrderOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@",isHadOrderReceiveOrder_Url,self.orderNo];
//    NSDictionary *dic = @{@"orderId":self.orderNo};
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
    NSMutableArray *backList = [NSMutableArray array];//存储待归还
    NSMutableArray *hadBackList = [NSMutableArray array];//存储已归还
    
    for (NSDictionary *model in currentArray) {
        
        if ([model[@"orderStatus"] intValue] == 2){
            self.orderNo = model[@"orderNo"];
            self.ID = model[@"id"];
           receiveList = [NSMutableArray arrayWithArray:model[@"orderDetailsVoList"]];
        }if ([model[@"orderStatus"] intValue] == 3) {//待归还
            self.orderNo = model[@"orderNo"];
            self.ID = model[@"id"];
            [backList addObject:model[@"orderDetailsVoList"]];
        }else if([model[@"orderStatus"] intValue] == 5) {//已归还
            
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


        //分数组添加到总数组里
        if (receiveList.count>0&&![totlaList containsObject:receiveList]) {
            [totlaList insertObject:receiveList atIndex:0];
            if (![self.sectionArray containsObject:receiveSection]) {
                [self.sectionArray addObject:receiveSection];
            }
        }
        
        if (backList.count>0&&![totlaList containsObject:backList]) {
            [totlaList insertObject:backList atIndex:0];
            if (![self.sectionArray containsObject:backSection]) {
                [self.sectionArray addObject:backSection];
            }
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

- (void)clear{
    [[YKOrderManager sharedManager].totalOrderList removeAllObjects];
    [[YKOrderManager sharedManager].sectionArray removeAllObjects];
    [YKOrderManager sharedManager].orderNo = nil;
     [YKOrderManager sharedManager].ID = nil;
}

@end
