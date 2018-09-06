//
//  YKAddCCouponView.h
//  YK
//
//  Created by edz on 2018/8/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKAddCCouponView : UITableViewCell

@property (nonatomic,copy)void (^buyBlock)(void);
@property (nonatomic,copy)void (^ensureBlock)(void);

- (void)reloadData;

@end
