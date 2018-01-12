//
//  YKHttpClient.m
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKHttpClient.h"
#import "SteyUtil.h"
#import "NSString+FD.h"

@implementation YKHttpClient

+ (YKHttpClient *)sharedManager{
    static YKHttpClient *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

+ (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (completionHandler)
        {
            dispatch_async(dispatch_get_main_queue(),^{
                completionHandler(data,response,error);
            });
            
        }
        
    }];
    [dataTask resume];
    return dataTask;
}

- (NSString*) mk_urlEncodedString:(NSString *)str
{ // mk_ prefix prevents a clash with a private api
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef)str,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    
    if(!encodedString)
        encodedString = @"";
    
    return encodedString;
}

+ (NSString*) urlEncodedKeyValueString:(NSDictionary*)dic
{
    
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in dic) {
        
        NSObject *value = [dic valueForKey:key];
        if([value isKindOfClass:[NSString class]])
            [string appendFormat:@"%@=%@&", [key mk_urlEncodedString], [((NSString*)value) mk_urlEncodedString]];
        
    }
    
    if([string length] > 0)
        [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    
    return string;
}


+ (NSURLRequest*)urlRequstWithMethod:(NSString*)method MethodName:(NSString*)methosName Dic:(NSDictionary*)dic
{
    NSString *dataString = [self urlEncodedKeyValueString:dic];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    //头部设置
    NSDictionary *headField = [NSDictionary dictionary];
    if ([Token length] != 0) {
        headField = @{
                      @"Content-Type":@"application/json; charset=utf-8",
                                    @"X-Auth-Token":Token
                                    };
    }else {
    headField = @{
                    @"Content-Type":@"application/json; charset=utf-8"
                               };
    }
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,methosName]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headField];
    //超时设置
    [request setTimeoutInterval: 60 ];
    //访问方式
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"GET"]) {
        return request;
    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    if ([method isEqualToString:@"POST"]) {
        if (dic.allKeys.count!=0) {
            [request setHTTPBody:data];
        }
        return request;
    }
    //body内容
    return nil;
    
}


// 传入的DIC参数必须要字符串
+ (NSURLSessionDataTask*)Method:(NSString*)method apiName:(NSString*)apiName Params:(NSDictionary*)params Completion:(void (^)(NSDictionary *dic)) completion
{
    
    if ([Token length] ==0) {
        
    }
    
    
    NSURLRequest *request = [YKHttpClient urlRequstWithMethod:(NSString*)method MethodName:apiName Dic:params];
    NSURLSessionDataTask *dataTask = [YKHttpClient dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error.code==-1001) {
            [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请求超时" delay:2];
            return ;
        }
        if (data.length == 0) {
             [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"finished with error ,code: -1004" delay:2];
            
             NSLog(@"HTTPRespose:%@%@\n%@",BaseUrl,apiName,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (completion)
        {
            completion(dic);
        }
        NSLog(@"HTTPRespose:%@%@\n%@",BaseUrl,apiName,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    return dataTask;
}

//暂未用AFN此方法
+(void)Method:(NSString *)method URLString:(NSString *)urlString paramers:(id)dict success:(void (^)(NSDictionary *dict))success  failure:(void(^)(NSError *error))failure {
    
    if ([method isEqualToString:@"POST"]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/javascript",nil];
        
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-Auth-Token"];
        [manager.securityPolicy setAllowInvalidCertificates:YES];
       
        // [manager setSecurityPolicy:[self customSecurityPolicy]];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSLog(@"当前URL:%@%@",BaseUrl,urlString);
        //发送请求
        [manager POST:[NSString stringWithFormat:@"%@%@",BaseUrl,urlString] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"返回json:%@",responseObject);
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
            
        }];
        
    }
    
    
    if ([method isEqualToString:@"GET"]) {
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"charset=UTF-8",nil];
        
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-Auth-Token"];
        [manager.securityPolicy setAllowInvalidCertificates:YES];
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSLog(@"当前URL:%@%@",BaseUrl,urlString);
        //发送请求
        [manager GET:[NSString stringWithFormat:@"%@%@",BaseUrl,urlString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"返回json:%@",responseObject);
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            
        }];
        
    }
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"qcxn" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    securityPolicy.allowInvalidCertificates = YES;
    
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

+(void)uploadPicUrl:(NSString *)url pic:(NSData *)pic success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"X-Auth-Token"];
    
    [manager.securityPolicy setAllowInvalidCertificates:YES];

    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传文件参数
        [formData appendPartWithFileData:pic name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
        
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        success(dict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
        
        //NSLog(@"请求失败：%@",error);
        
    }];
    
    
}


+(void)uploadPicsUrl:(NSString *)url token:(NSDictionary *)dict pic:(NSArray *)pics success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *api=[NSString stringWithFormat:@"%@%@",BaseUrl,url];
    [manager POST:api parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         // 上传 多张图片
         for(NSInteger i = 0; i <pics.count; i++)
         {
             NSData * imageData = [SteyUtil imageData:pics[i]];
             // 上传的参数名
             NSString * Name = @"files";
             
             // 上传filename
             NSString * fileName = @"default.jpg";
             
             [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
             
         }
         
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         //        NSLog(@"%@",result);
         
         NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         
         // NSDictionary *dict = [NSJSONSerialization JSONObjectWithStream:responseObject options:NSJSONReadingAllowFragments error:nil];
         success(dict);
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //         NSLog(@"错误 %@", error.localizedDescription);
         failure(error);
     }];
}

@end
