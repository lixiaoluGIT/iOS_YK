//
//  YKFilterUpHeaderView.h
//  YK
//
//  Created by edz on 2018/11/20.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKFilterUpHeaderView : UIView
@property (nonatomic,strong)NSArray *selectFilterKeys;//已选的筛选标签

@property (nonatomic,copy)void (^filterActionDid)(void);
@property (nonatomic,copy)void (^changeTypeBlock)(BOOL isSelected);
@property (nonatomic,assign)BOOL isSelected;
@end
