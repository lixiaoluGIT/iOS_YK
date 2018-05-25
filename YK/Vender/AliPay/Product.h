//
//  Product.h
//  journey
//
//  Created by 趣出行开发_小宇 on 15/10/16.
//  Copyright © 2015年 thjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

{
@private
float     _price;
NSString *_subject;
NSString *_body;
NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;


@end
