//
//  YKBrand.h
//  YK
//
//  Created by LXL on 2017/12/6.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKBrand : NSObject

@property (nonatomic,copy)NSString *brandIma;//品牌ID
@property (nonatomic,copy)NSString *brandId;//品牌ID
@property (nonatomic,copy)NSString *brandLogo;//品牌Logo
@property (nonatomic,copy)NSString *brandName;//品牌名
@property (nonatomic,copy)NSString *brandDesc;//品牌介绍

- (void)initWithDictionary:(NSDictionary *)dictionary;
@end
