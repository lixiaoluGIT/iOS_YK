//
//  YKAddress.m
//  YK
//
//  Created by LXL on 2017/12/5.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKAddress.h"

@implementation YKAddress

- (void)ininWithDictionary:(NSDictionary *)Dic{
    
    self.name = Dic[@"consignee"];
    self.phone = Dic[@"contactNumber"];
    self.zone = Dic[@"region"];
    self.detail = Dic[@"detailedAddress"];
    self.isDefaultAddress = Dic[@"defaultAddress"];
    self.addressId = Dic[@"addressId"];
}

@end
