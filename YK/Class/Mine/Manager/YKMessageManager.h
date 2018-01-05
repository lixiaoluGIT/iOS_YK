//
//  YKMessageManager.h
//  YK
//
//  Created by LXL on 2017/12/14.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKMessageManager : NSObject

+ (YKMessageManager *)sharedManager;

//获取消息通知列表列表
- (void)getMessageListOnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取物流消息列表
- (void)getSMSMessageListOnResponse:(void (^)(NSDictionary *dic))onResponse;
@end
