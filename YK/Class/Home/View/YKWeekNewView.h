//
//  YKWeekNewView.h
//  YK
//
//  Created by EDZ on 2018/4/17.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKWeekNewView : UITableViewCell
@property (nonatomic,copy)void (^toDetailBlock)(void);
- (void)initWithDic:(NSDictionary *)dic;
@end
