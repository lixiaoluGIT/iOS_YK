//
//  YKCommunicationManager.h
//  YK
//
//  Created by EDZ on 2018/5/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKCommunicationManager : NSObject

+ (YKCommunicationManager *)sharedManager;

//晒图发布
/*
imageArray 照片数组
 text   编辑的文字
 onResponse 请求回掉
 */
- (void)publicWithImageArray:(NSArray *)imageArray
                  clothingId:(NSString *)clothingId
                        text:(NSString *)text
                  OnResponse:(void (^)(NSDictionary *dic))onResponse;

//社区列表展示
- (void)requestCommunicationListWithNum:(NSInteger)Num
                                   Size:(NSInteger)Size
                             OnResponse:(void (^)(NSDictionary *dic))onResponse;

//点赞

//取消点赞

@end
