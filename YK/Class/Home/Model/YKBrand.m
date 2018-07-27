//
//  YKBrand.m
//  YK
//
//  Created by LXL on 2017/12/6.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKBrand.h"

@implementation YKBrand

- (void)initWithDictionary:(NSDictionary *)dictionary{
    if (dictionary) {
        _brandIma = dictionary[@"brandDetailImg"];
        _brandId = dictionary[@"brandId"];
        _brandName = dictionary[@"brandName"];
        _brandDesc = dictionary[@"brandDesc"];
        _brandLogo = dictionary[@"brandLargeLogo"];
    }
}
@end
