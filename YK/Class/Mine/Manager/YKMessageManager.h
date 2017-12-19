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

- (void)getMessageListOnResponse:(void (^)(NSDictionary *dic))onResponse;
@end
