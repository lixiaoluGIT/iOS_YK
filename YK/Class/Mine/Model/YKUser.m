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
        self.userId = Dictionary[@"userInfo"][@"userId"];
        self.nickname = Dictionary[@"userInfo"][@"nickname"];
        self.phone = Dictionary[@"userInfo"][@"phone"];
        self.gender = Dictionary[@"userInfo"][@"gender"];
        self.photo = Dictionary[@"userInfo"][@"photo"];
        
        self.cardNum = Dictionary[@"cardInfo"][@"cardNum"];
        self.cardType = Dictionary[@"cardInfo"][@"cardType"];
        self.depositEffective = Dictionary[@"cardInfo"][@"depositEffective"];
        self.effective = Dictionary[@"cardInfo"][@"effective"];
        self.validity = Dictionary[@"cardInfo"][@"validity"];
    }
    return self;
}

@end
