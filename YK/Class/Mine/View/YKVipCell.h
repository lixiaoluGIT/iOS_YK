//
//  YKVipCell.h
//  YK
//
//  Created by edz on 2018/7/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKVipCell : UITableViewCell

@property (nonatomic,strong)YKUser *user;
@property (nonatomic,copy)void (^btnClick)(void);
@end
