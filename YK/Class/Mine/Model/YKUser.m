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
        if (Dictionary.allKeys.count == 0) {
            return nil;
        }
        self.rongToken = Dictionary[@"rongToken"];
        
        self.userId = Dictionary[@"userInfo"][@"userId"];
        [UD setObject:self.userId forKey:@"userId"];
        self.nickname = Dictionary[@"userInfo"][@"nickname"];
        self.phone = Dictionary[@"userInfo"][@"phone"];
        self.gender = Dictionary[@"userInfo"][@"gender"];
        self.photo = Dictionary[@"userInfo"][@"photo"];
        
        //邀请码
        self.inviteCode = Dictionary[@"userInfo"][@"inviteCode"];
        
        self.cardNum = Dictionary[@"cardInfo"][@"cardNum"];
        self.cardType = Dictionary[@"cardInfo"][@"cardType"];
        self.depositEffective = Dictionary[@"cardInfo"][@"depositEffective"];
        self.effective = Dictionary[@"cardInfo"][@"effective"];
        self.validity = Dictionary[@"cardInfo"][@"validity"];
        
        //是否分享过
        if (Dictionary[@"userInfo"][@"isShare"] == [NSNull null]) {
            self.isShare = @"0";
        }else
            self.isShare = Dictionary[@"userInfo"][@"isShare"];
        }
    
    
    self.colledgeId = Dictionary[@"school"][@"schoolId"];
    self.colledgeName = Dictionary[@"school"][@"schoolName"];
    if([self.colledgeName rangeOfString:@"#"].location !=NSNotFound)//
    {
        self.colledgeName = [self.colledgeName stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    if ([self.colledgeName isEqual:@""]) {
        self.colledgeName = @"选择院校";
    }
    
//    self.newUser = Dictionary[@"school"][@"schoolId"];
    self.isNewUser = Dictionary[@"userInfo"][@"newUser"];
    
    //待签收数量
    self.toQianshouNum = [NSString stringWithFormat:@"%@",Dictionary[@"orderNumberList"][0][@"orderNum"]];
    //待归还数量
    self.toReceiveNum = [NSString stringWithFormat:@"%@",Dictionary[@"orderNumberList"][1][@"orderNum"]];
    
    return self;
}

@end
