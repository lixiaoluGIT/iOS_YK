//
//  YKCommunicationManager.h
//  YK
//
//  Created by EDZ on 2018/5/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKComheader.h"

@interface YKCommunicationManager : NSObject

@property (nonatomic,strong)NSMutableArray *concernArray;//关注数组
+ (YKCommunicationManager *)sharedManager;

//晒图发布
/*
imageArray 照片数组
 text   编辑的文字
 activityId 活动Id
 onResponse 请求回掉
 */
- (void)publicWithImageArray:(NSArray *)imageArray
                  clothingId:(NSString *)clothingId
                        text:(NSString *)text
                  activityId:(NSString *)activityId
                  OnResponse:(void (^)(NSDictionary *dic))onResponse;

//轮播图接口
- (void)requestCommunicationImgListOnResponse:(void (^)(NSDictionary *dic))onResponse;

//社区列表展示
- (void)requestCommunicationListWithCommunicationType:(CommunicationType)CommunicationType Num:(NSInteger)Num Size:(NSInteger)Size clothingId:(NSString *)clothingId activityId:(NSString *)activityId OnResponse:(void (^)(NSDictionary *dic))onResponse;

//点赞

/*
 articleId 列表ID
 onResponse 请求回掉
 */
- (void)setLikeCommunicationWithArticleId:(NSString *)articleId
                               OnResponse:(void (^)(NSDictionary *dic))onResponse;

//取消点赞
/*
 articleId 列表ID
 onResponse 请求回掉
 */
- (void)cancleLikeCommunicationWithArticleId:(NSString *)articleId
                               OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取可晒衣服
- (void)getHistoryOrderToPublicWithNum:(NSInteger)Num
                                  Size:(NSInteger)Size
                            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//关注
/*
 userId 用户ID
 onResponse 请求回掉
 */
- (void)setConcernWithUserId:(NSString *)userId
                               OnResponse:(void (^)(NSDictionary *dic))onResponse;

//取消关注
/*
 userId 用户ID
 onResponse 请求回掉
 */
- (void)cancleConcernWithUserId:(NSString *)userId
                     OnResponse:(void (^)(NSDictionary *dic))onResponse;

//用户关注列表
- (void)getUserConcernListOnResponse:(void (^)(NSDictionary *dic))onResponse;

@end
