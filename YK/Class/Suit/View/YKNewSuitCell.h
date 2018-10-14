//
//  YKNewSuitCell.h
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKNewSuitCell : UITableViewCell

@property (nonatomic,strong)YKSuit *suit;
@property (nonatomic,strong)NSString *suitId;
@property (nonatomic,copy)void (^deleteBlock)(NSString *shopCartId);
@end
