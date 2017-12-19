//
//  YKAddressDetailCell.h
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKAddress.h"
@interface YKAddressDetailCell : UITableViewCell

@property (nonatomic,strong)YKAddress *address;

@property (nonatomic,copy)void (^selectDefaultBlock)(void);
@property (nonatomic,copy)void (^editBlock)(YKAddress *address);
@property (nonatomic,copy)void (^deleteBlock)(void);

@end
