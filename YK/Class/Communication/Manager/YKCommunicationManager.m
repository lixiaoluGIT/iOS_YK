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

- (void)requestCommunicationImgListOnResponse:(void (^)(NSDictionary *dic))onResponse{

    [YKHttpClient Method:@"GET" apiName:CommunicationImgList_Url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}
//社区发布
- (void)publicWithImageArray:(NSArray *)imageArray
                  clothingId:(NSString *)clothingId
                        text:(NSString *)text
                  activityId:(NSString *)activityId
                  OnResponse:(void (^)(NSDictionary *dic))onResponse{
   
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    [YKHttpClient uploadPicsUrl:Public_Url token:nil clothingId:clothingId text:text pic:imageArray activityId:activityId==nil?@"":activityId success:^(NSDictionary *dict) {
        
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
- (void)requestCommunicationListWithCommunicationType:(CommunicationType)CommunicationType Num:(NSInteger)Num Size:(NSInteger)Size clothingId:(NSString *)clothingId activityId:(NSString *)activityId OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    NSString *url;
    if (CommunicationType == 2) {
     url = [NSString stringWithFormat:@"%@?articleStatus=0&page=%ld&size=%ld&clothingId=%@&activityId=%@&userId=%@",GetCommunicationList_Url,Num,Size,clothingId,activityId,[Token length]>0 ? [YKUserManager sharedManager].user.userId : @""];
    }else {
       url = [NSString stringWithFormat:@"%@?articleStatus=%ld&page=%ld&size=%ld&clothingId=%@&activityId=%@",GetCommunicationList_Url,CommunicationType,Num,Size,clothingId,activityId];
    }
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        
        if (onResponse) {
            onResponse(dic);
        }
        
    }];
}
//点赞
- (void)setLikeCommunicationWithArticleId:(NSString *)articleId
                               OnResponse:(void (^)(NSDictionary *dic))onResponse{
 
    NSString *url = [NSString stringWithFormat:@"%@?articleId=%@",Like_Url,articleId];
    [YKHttpClient Method:@"GET" apiName:url Params:nil Completion:^(NSDictionary *dic) {
       
    [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] intValue] == 200) {

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

            if (onResponse) {
                onResponse(dic);
            }
        }
        
    }];
}

- (void)getHistoryOrderToPublicWithNum:(NSInteger)Num
                                  Size:(NSInteger)Size
                            OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
     [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@?page=%ld&size=%ld",historyOrder_Url,Num,Size];
    
    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        
        [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"status"] intValue] == 200) {
           
            if (onResponse) {
                onResponse(dic);
            }
        }else {
            if (onResponse) {
                onResponse(dic);
            }
        }
        
    }];
}

- (void)setConcernWithUserId:(NSString *)userId
                  OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    if ([Token length]==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:2];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?articleUserId=%@",Concern_Url,userId];

    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] intValue] == 200) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"已关注" delay:1.5];
            if (onResponse) {
                onResponse(dic);
            }
        }
        
    }];
}

- (void)cancleConcernWithUserId:(NSString *)userId
                     OnResponse:(void (^)(NSDictionary *dic))onResponse{
    
    if ([Token length]==0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请先登录" delay:2];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?articleUserId=%@",Concern_Url,userId];

    [YKHttpClient Method:@"POST" apiName:url Params:nil Completion:^(NSDictionary *dic) {
        
        if ([dic[@"status"] intValue] == 200) {

            if (onResponse) {
                onResponse(dic);
            }
        }
        
    }];
}

- (void)getUserConcernListOnResponse:(void (^)(NSDictionary *dic))onResponse{
    [YKHttpClient Method:@"GET" apiName:ConcernList_Url Params:nil Completion:^(NSDictionary *dic) {
        if ([Token length] == 0) {
            _concernArray = [NSMutableArray array];
            if (onResponse) {
                onResponse(dic);
            }
            return ;
        }
        _concernArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        if ([dic[@"status"] intValue] == 200) {
            if (onResponse) {
                onResponse(dic);
            }
        }
        
    }];
}

@end
