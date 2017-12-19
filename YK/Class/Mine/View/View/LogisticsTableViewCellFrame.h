//
//  LogisticsTableViewCellFrame.h
//  logisticsInfo
//
//  Created by My Mac on 2017/6/8.
//  Copyright © 2017年 MyMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LogisticsInfo;

@interface LogisticsTableViewCellFrame : NSObject

@property(nonatomic,strong) LogisticsInfo *logisticsInfo;
@property(nonatomic,assign,readonly) CGRect imgViewFrame;
@property(nonatomic,assign,readonly) CGRect lineViewFrame;
@property(nonatomic,assign,readonly) CGRect addressFrame;
@property(nonatomic,assign,readonly) CGRect infoFrame;
@property(nonatomic,assign,readonly) CGRect timeFrame;
@property(nonatomic, assign, readonly) CGFloat rowHeight;
@property(nonatomic, assign, readonly) CGRect lineFrame;


@end
