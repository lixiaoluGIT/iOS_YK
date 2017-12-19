//
//  YKSuitHeader.h
//  YK
//
//  Created by LXL on 2017/12/13.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSuitHeader : UITableViewCell
@property (nonatomic,copy)void (^SMSBlock)(void);
@property (nonatomic,copy)void (^ensureReceiveBlock)(void);
@property (nonatomic,copy)void (^orderBackBlock)(void);
@end
