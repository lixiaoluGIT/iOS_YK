//
//  YKSelectTimeView.h
//  YK
//
//  Created by EDZ on 2018/4/10.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSelectTimeView : UITableViewCell

@property (nonatomic,copy)void (^BtnClickBlock)(NSString *timeStr);
@end


