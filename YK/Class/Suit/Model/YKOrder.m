//
//  YKOrder.m
//  YK
//
//  Created by LXL on 2017/12/12.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKOrder.h"

@implementation YKOrder

- (void)setAddress:(YKAddress *)address{
    _address = address;
}

- (void)setShoppingCartIdList:(NSMutableArray *)shoppingCartIdList{
    _shoppingCartIdList = shoppingCartIdList;
}
@end
