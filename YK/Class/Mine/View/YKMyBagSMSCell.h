//
//  YKMyBagSMSCell.h
//  YK
//
//  Created by LXL on 2017/11/21.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMyBagSMSCell : UITableViewCell

@property (nonatomic,copy)void(^scanSMSBlock)(void);
@end
