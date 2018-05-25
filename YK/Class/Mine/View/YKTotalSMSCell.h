//
//  YKTotalSMSCell.h
//  YK
//
//  Created by LXL on 2017/12/18.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKTotalSMSCell : UITableViewCell

@property (nonatomic,strong)NSString *orderNo;

- (void)initWithDictionary:(NSDictionary *)dic;
@end
