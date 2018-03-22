//
//  YKProductDetailVC.h
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKProduct.h"

@interface YKProductDetailVC : YKBaseVC

@property (nonatomic,strong)YKProduct *product;

@property (nonatomic,strong)NSString *productId;

@property (nonatomic,strong)NSString *titleStr;

@property (nonatomic,assign)BOOL isFromShare;

@end
