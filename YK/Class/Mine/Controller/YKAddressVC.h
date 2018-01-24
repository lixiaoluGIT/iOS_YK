//
//  YKAddressVC.h
//  YK
//
//  Created by LXL on 2017/11/16.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKAddressVC : YKBaseVC

@property (nonatomic,copy)void (^selectAddressBlock)(YKAddress *address);
@end
