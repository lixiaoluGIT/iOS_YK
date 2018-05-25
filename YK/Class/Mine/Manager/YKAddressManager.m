//
//  YKAddressManager.m
//  YK
//
//  Created by LXL on 2017/12/5.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKAddressManager.h"

@implementation YKAddressManager

+ (YKAddressManager *)sharedManager{
    static YKAddressManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//添加地址
- (void)addAddressWithAddress:(YKAddress *)address
                   OnResponse:(void (^)(NSDictionary *dic))onResponse{

  NSDictionary *dic =@{
      @"consignee":address.name,
      @"contactNumber":address.phone,
      @"detailedAddress":address.detail,
      @"region":address.zone,
      @"defaultAddress":address.isDefaultAddress
    };
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"POST" URLString:AddAddress_Url paramers:dic success:^(NSDictionary *dict) {

        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dict[@"status"] intValue] == 419) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2];
            return ;
        }
          [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"保存成功" delay:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [smartHUD  Hide];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (onResponse) {
                    onResponse(dic);
                }
                
            });
            
        });
    } failure:^(NSError *error) {
        
    }];
}

//获取地址列表
- (void)getAddressListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

    [YKHttpClient Method:@"GET" URLString:queryAddress_Url paramers:nil success:^(NSDictionary *dict) {

//        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

        if (dict[@"data"] != [NSNull null]) {
            if (onResponse) {
                onResponse(dict);
            }
        }else {
            if (onResponse) {
                onResponse(nil);
            }
        }
        

    } failure:^(NSError *error) {

    }];
}

//删除地址
- (void)deleteAddressWithAddress:(YKAddress *)address
                      OnResponse:(void (^)(NSDictionary *dic))onResponse{
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?addressId=%@",deleteAddress_Url,address.addressId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"删除成功" delay:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (onResponse) {
                    onResponse(dic);
                }
                
            });
            
        });
    
    }];
}
//设为默认地址
- (void)setDetaultAddressWithAddress:(YKAddress *)address
                          OnResponse:(void (^)(NSDictionary *dic))onResponse{
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?addressId=%@",settingDefaultAddress_Url,address.addressId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
//        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
//        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"设置成功" delay:1.2];
      
                
                if (onResponse) {
                    onResponse(dic);
                }
   
    }];
}
//查询默认地址
- (void)queryDetaultAddressOnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];

        [YKHttpClient Method:@"GET" apiName:queryDefaultAddress_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
            if (dic[@"data"] != [NSNull null]) {
                if (onResponse) {
                    onResponse(dic);
                }
            }else {
                if (onResponse) {
                    onResponse(nil);
                }
            }
    }];
}

- (void)updateAddressWithAddress:(YKAddress *)address  addressId:(NSString *)addressId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    NSDictionary *dic =@{
                         @"consignee":address.name,
                         @"contactNumber":address.phone,
                         @"detailedAddress":address.detail,
                         @"region":address.zone,
                         @"defaultAddress":address.isDefaultAddress,
                         };
    
    
    NSString *url = [NSString stringWithFormat:@"%@?addressId=%@",updateAddress_Url,addressId];
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [YKHttpClient Method:@"POST" URLString:url paramers:dic success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dict[@"status"] intValue] == 419) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:dict[@"msg"] delay:2];
            return ;
        }
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"修改成功" delay:1.2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [smartHUD  Hide];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (onResponse) {
                    onResponse(dic);
                }
                
            });
            
        });
    } failure:^(NSError *error) {
        
    }];
}

@end
