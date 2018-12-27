//
//  YKShareCell.h
//  YK
//
//  Created by edz on 2018/8/8.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKShareCell : UITableViewCell
@property(nonatomic,copy)void (^shareBlock1)(void);
@property(nonatomic,copy)void (^shareBlock2)(void);
@end
