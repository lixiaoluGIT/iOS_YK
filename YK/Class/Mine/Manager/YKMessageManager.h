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

@property (nonatomic,strong)NSArray *pushMsgList;//文本消息通知
@property (nonatomic,strong)NSArray *smsMsgList;//物流消息通知
@property (nonatomic,strong)NSArray *activityMsgList;//活动消息通知

- (void)showMessageWithTitle:(NSString *)title Content:(NSString *)content;

/*
 获取消息通知列表列表
 MsgType 2:消息文本通知 1:物流信息通知 3:活动通知
 */
- (void)getMessageListMsgType:(NSInteger)MsgType OnResponse:(void (^)(NSArray *array))onResponse;

@end
