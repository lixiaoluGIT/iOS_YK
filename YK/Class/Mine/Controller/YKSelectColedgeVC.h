//
//  YKSelectColedgeVC.h
//  YK
//
//  Created by edz on 2018/6/5.
//  Copyright © 2018年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSelectColedgeVC : UIViewController

@property (nonatomic,copy)void (^selectColedgeBlock)(NSString *coledge,NSString *colledgeId);

@end
