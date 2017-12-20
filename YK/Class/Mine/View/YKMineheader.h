//
//  YKMineheader.h
//  YK
//
//  Created by LXL on 2017/11/15.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMineheader : UITableViewCell

@property (nonatomic,copy)void (^VIPClickBlock)(NSInteger VIPStatus);
@property (nonatomic,strong)YKUser *user;
@property (nonatomic,copy)void (^viewClickBlock)(void);

@end
