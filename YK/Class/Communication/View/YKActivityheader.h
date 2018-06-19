//
//  YKActivityheader.h
//  YK
//
//  Created by edz on 2018/6/14.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKActivity.h"

@interface YKActivityheader : UITableViewCell
@property (nonatomic,strong)YKActivity *activity;
@property (nonatomic,copy)void(^attendActivityBlock)(NSString *activityId);
//@property (nonatomic,copy)void (^clickIndexToWebViewBlock)(NSString *webUrl);
@end
