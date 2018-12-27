//
//  YKAccountCell.h
//  YK
//
//  Created by edz on 2018/7/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKAccountCell : UITableViewCell
@property (nonatomic,copy)void (^btnClick)(void);
@property (nonatomic,copy)void (^tixianClick)(void);
@property (nonatomic,strong)NSDictionary *account;
@end
