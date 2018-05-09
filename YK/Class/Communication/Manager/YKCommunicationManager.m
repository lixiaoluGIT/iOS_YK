//
//  YKCommunicationManager.m
//  YK
//
//  Created by EDZ on 2018/5/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCommunicationManager.h"

@implementation YKCommunicationManager

+ (YKCommunicationManager *)sharedManager{
    static YKCommunicationManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//社区发布
- (void)publicWithImageArray:(NSArray *)imageArray
                  clothingId:(NSString *)clothingId
                        text:(NSString *)text
                  OnResponse:(void (^)(NSDictionary *dic))onResponse{
   
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient uploadPicsUrl:Public_Url token:nil clothingId:clothingId text:text pic:imageArray success:^(NSDictionary *dict) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if ([dict[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"发布成功" delay:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                        if (onResponse) {
                            onResponse(dict);
                        }
            
                    });
            
                });
            
        }else {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"发布失败" delay:1.5];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//社区列表展示
- (void)requestCommunicationListWithNum:(NSInteger)Num Size:(NSInteger)Size OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
//    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@?articleStatus=0&page=%ld&size=%ld",GetCommunicationList_Url,Num,Size];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}

- (void)setLikeCommunicationWithArticleId:(NSString *)articleId
                               OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    if ([Token length]==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:2];
        return;
    }
    
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@?articleId=%@",Like_Url,articleId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
       
    [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] intValue] == 200) {
             [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"点赞成功" delay:1.5];
            if (onResponse) {
                onResponse(dic);
            }
        }
       
    }];
}

//取消点赞  
- (void)cancleLikeCommunicationWithArticleId:(NSString *)articleId
                                  OnResponse:(void (^)(NSDictionary *dic))onResponse{
    if ([Token length]==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:2];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?articleId=%@",Like_Url,articleId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"取消点赞" delay:1.5];
            if (onResponse) {
                onResponse(dic);
            }
        }
        
    }];
}
@end
