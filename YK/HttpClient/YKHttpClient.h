//
//  YKHttpClient.h
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface YKHttpClient : NSObject
+ (YKHttpClient *)sharedManager;

/*!
 
 @http(s)请求
 
 @method 请求类型
 
 @urlString 方法名
 
 @dict(1) 向server传的参数
 
 @dict(2) 成功后返回的参数
 
 @error 失败错误信息
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!()
 */
+(void)Method:(NSString *)method
    URLString:(NSString *)urlString
     paramers:(id)dict
      success:(void (^)(NSDictionary *dict))success
      failure:(void(^)(NSError *error))failure;

/*!
 
 @url 图片接口地址

 @pic 图片二进制
 
 @dict 成功后返回的参数
 
 @error 失败错误信息
 
 */
+(void)uploadPicUrl:(NSString *)url pic:(NSData *)pic success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure;

/*!
 
 @上传多张图片
 
 */
+(void)uploadPicsUrl:(NSString *)url
               token:(NSDictionary *)dict
          clothingId:(NSString *)clothingId
                text:(NSString *)text
                 pic:(NSArray *)pics
          activityId:(NSString *)activityId
             success:(void(^)(NSDictionary *dict))success
             failure:(void(^)(NSError *error))failure;

//
+ (NSURLSessionDataTask*)Method:(NSString*)method apiName:(NSString*)apiName Params:(NSDictionary*)params Completion:(void (^)(NSDictionary *dic)) completion;
@end
