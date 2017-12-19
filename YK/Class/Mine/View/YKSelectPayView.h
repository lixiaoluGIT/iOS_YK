//
//  YKSelectPayView.h
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSelectPayView : UITableViewCell

@property (nonatomic,copy)void (^selectPayBlock)(payMethod payMethod);

@property (nonatomic,copy)void (^cancleBlock)(void);


@end
