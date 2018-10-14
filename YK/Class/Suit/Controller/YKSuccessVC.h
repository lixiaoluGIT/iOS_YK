//
//  YKSuccessVC.h
//  YK
//
//  Created by LXL on 2017/11/20.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSuccessVC : UIViewController

@property (nonatomic,strong)NSMutableArray *pList;//所选商品列表
@property (nonatomic,strong)YKAddress *addressM;
@property (nonatomic,strong)NSString *timeStr;
@property (nonatomic,strong)NSString *orderNum;

@end
