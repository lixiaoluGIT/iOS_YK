//
//  YKMineBagCell.h
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMineBagCell : UITableViewCell

@property (nonatomic,copy)void (^scanBlock)(NSInteger tag);
@end
