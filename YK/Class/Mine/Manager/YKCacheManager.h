//
//  YKCacheManager.h
//  YK
//
//  Created by LXL on 2018/1/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKCacheManager : NSObject

+ (YKCacheManager *)sharedManager;

//获取app缓存大小
- (CGFloat)getFolderSize;

//清除缓存
- (void)removeCacheOnResponse:(void (^)(NSDictionary *dic))onResponse;

@end
