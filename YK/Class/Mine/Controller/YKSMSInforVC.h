//
//  YKSMSInforVC.h
//  YK
//
//  Created by LXL on 2017/11/30.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSMSInforVC : YKBaseVC

@property (nonatomic,strong)NSString *orderNo;//订单号,查询物流
@property (nonatomic,assign)BOOL isFromeSF;//判断是顺丰还是中通

@end
