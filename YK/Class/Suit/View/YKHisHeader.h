//
//  YKHisHeader.h
//  YK
//
//  Created by edz on 2018/11/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKHisHeader : UITableViewCell
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)NSMutableArray *clothList;//历史衣服json
@property (nonatomic,strong)NSString *Number;
@property (nonatomic,strong)NSString *Price;
@end
