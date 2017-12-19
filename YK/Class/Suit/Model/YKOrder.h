//
//  YKOrder.h
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKOrder : NSObject

@property (nonatomic,strong)YKAddress *address;
//@property (nonatomic,strong)NSString *addressId;
@property (nonatomic,strong)NSMutableArray *shoppingCartIdList;//购物车Id数组

@end
