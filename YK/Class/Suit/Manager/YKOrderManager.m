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

- (void)searchOrderWithOrderStatus:(NSInteger)status OnResponse:(void (^)(NSMutableArray *array))onResponse;{
    
    switch (status) {
        case 100:
            status=0;//全部衣袋
            break;
        case 101:
            status=1;//待签收
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
 
            if (status==0) {
                
                [self groupWithDictionary:dic groupDoneBlock:^(void) {
                    
                    if (onResponse) {
                        onResponse(nil);
                    }
                    
                }];
                
            }else {
               
                NSMutableArray *listArray;
                //TODO:数据结构需变动
                if (dic[@"data"]) {
                        listArray = [NSMutableArray arrayWithArray:dic[@"data"][0][@"orderDetailsVoList"]];
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

//分组
- (void)groupWithDictionary:(NSDictionary *)dic groupDoneBlock:(void (^)(void))groupDoneBlock; {
    
    NSArray *currentArray = [NSArray arrayWithArray:dic[@"data"]];
    NSMutableArray *totlaList = [NSMutableArray array];
    NSMutableArray *receiveList = [NSMutableArray array];//存储待签收
    NSMutableArray *backList = [NSMutableArray array];//存储待归还
    NSMutableArray *hadBackList = [NSMutableArray array];//存储已归还
    
    for (NSDictionary *model in currentArray) {
        if ([model[@"orderStatus"] intValue] == 3) {//待归还
            [backList addObject:model[@"orderDetailsVoList"]];
        }else if([model[@"orderStatus"] intValue] == 5) {//已归还
            [hadBackList addObject:model[@"orderDetailsVoList"]];
        }else{//其它全部为待签收
            [receiveList addObject:model[@"orderDetailsVoList"]];
        }
        
        //分数组添加到总数组里
        if (receiveList.count>0&&![totlaList containsObject:receiveList]) {
            [totlaList addObject:receiveList];
            if (![self.sectionArray containsObject:receiveSection]) {
                [self.sectionArray addObject:receiveSection];
            }
        }
        
        if (backList.count>0&&![totlaList containsObject:backList]) {
            [totlaList addObject:backList];
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
        self.totalOrderList = totlaList;
    
        if (groupDoneBlock) {//分组完毕
            groupDoneBlock();
        }
    
}

- (void)clear{
    [[YKOrderManager sharedManager].totalOrderList removeAllObjects];
    [[YKOrderManager sharedManager].sectionArray removeAllObjects];
}

@end
