//
//  YKMyHeaderView.h
//  YK
//
//  Created by LXL on 2018/1/31.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMyHeaderView : UIView

@property (nonatomic,copy)void (^VIPClickBlock)(NSInteger VIPStatus);
@property (nonatomic,strong)YKUser *user;
@property (nonatomic,copy)void (^viewClickBlock)(void);
@property (nonatomic,copy)void (^btnClickBlock)(NSInteger tag);
@property (nonatomic,strong)UIImageView *headPho;

@end
