//
//  YKFilterHeaderView.h
//  YK
//
//  Created by edz on 2018/10/29.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKFilterHeaderView : UIView

@property (nonatomic,strong)NSArray *selectFilterKeys;//已选的筛选标签

@property (nonatomic,copy)void (^filterActionDid)(void);
//选择器

@end
