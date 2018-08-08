//
//  YKLogInView.h
//  YK
//
//  Created by edz on 2018/8/8.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLogInView : UITableViewCell
- (void)appear;
@property (nonatomic,copy)void (^dis)(void);
@property (nonatomic,copy)void (^toPlayYK)(void);
@end
