//
//  YKPublicCell.h
//  YK
//
//  Created by LXL on 2018/3/16.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKPublicCell : UITableViewCell

@property (nonatomic,copy)void (^PublicBlock)(void);

@end
