//
//  YKMineCategoryCell.h
//  YK
//
//  Created by LXL on 2018/2/1.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMineCategoryCell : UITableViewCell

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSArray *imageArray;

- (void)initWithTitleArray:(NSArray *)title ImageArray:(NSArray *)imageArray;
@property (nonatomic,copy)void (^clickBlock)(NSInteger tag);
@end
