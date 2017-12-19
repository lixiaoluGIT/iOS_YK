//
//  YKUser.m
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKUser.h"

@implementation YKUser

- (instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    if (self = [super init]) {
        self.userId = Dictionary[@"userId"];
        self.nickname = Dictionary[@"nickname"];
        self.phone = Dictionary[@"phone"];
        self.gender = Dictionary[@"gender"];
        self.phone = Dictionary[@"phone"];
    }
    return self;
}

@end
