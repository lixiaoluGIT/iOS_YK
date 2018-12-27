//
//  YKSelectColedgeCell.h
//  YK
//
//  Created by edz on 2018/6/5.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSelectColedgeCell : UITableViewCell

@property (nonatomic,strong)NSString *colledge;
@property (nonatomic,strong)NSString *colledgeId;
- (void)initWithDic:(NSDictionary *)dic;

@end
