//
//  YKCacheManager.m
//  YK
//
//  Created by LXL on 2018/1/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCacheManager.h"

@implementation YKCacheManager

+ (YKCacheManager *)sharedManager{
    static YKCacheManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (CGFloat)getFolderSize{
    
    CGFloat folderSize;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}

- (void)removeCacheOnResponse:(void (^)(NSDictionary *dic))onResponse{
    

    //===============清除缓存==============
    [LBProgressHUD showHUDto:[UIApplication sharedApplication].keyWindow animated:YES];
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError*error;
        
        NSString*path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"清除成功" delay:1.6];
                
                if (onResponse) {
                    onResponse(nil);
                }
                
            }else{
                [LBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                  [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"清除成功" delay:1.6];
                
                NSLog(@"清除失败");
                
            }
        }
    }
}

@end
