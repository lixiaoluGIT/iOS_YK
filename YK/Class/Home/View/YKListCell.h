//
//  YKListCell.h
//  YK
//
//  Created by edz on 2018/8/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKListCell : UITableViewCell
@property (nonatomic,strong)NSString *clickUrl;
- (void)initWithDic:(NSDictionary *)dic cid:(NSString *)cid;
@end
