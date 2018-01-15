//
//  YKProductDetailVC.h
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKProduct.h"

@interface YKProductDetailVC : UIViewController

@property (nonatomic,strong)YKProduct *product;

@property (nonatomic,strong)NSString *productId;

@property (nonatomic,strong)NSString *titleStr;

@end
