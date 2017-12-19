//
//  YKTotalMsgView.h
//  YK
//
//  Created by LXL on 2017/12/18.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKTotalMsgView : UITableViewCell

@property (nonatomic,copy)void (^ToMsgBlock)(void);
@property (nonatomic,copy)void (^ToSMSBlock)(void);

@end
