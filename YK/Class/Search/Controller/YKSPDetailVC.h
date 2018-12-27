//
//  YKSPDetailVC.h
//  YK
//
//  Created by edz on 2018/6/15.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBaseVC.h"
#import "YKProduct.h"

@interface YKSPDetailVC : YKBaseVC

@property (nonatomic,strong)YKProduct *product;
@property (nonatomic,strong)NSString *productId;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,assign)BOOL isFromShare;
@property (nonatomic,assign)BOOL isSP;
@property (nonatomic,assign)BOOL isFromHome;
@end
