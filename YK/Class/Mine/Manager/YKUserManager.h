//
//  YKUserManager.h
//  YK
//
//  Created by LXL on 2017/12/4.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKUser.h"

@interface YKUserManager : NSObject

@property (nonatomic,strong)YKUser *user;

+ (YKUserManager *)sharedManager;

//获取验证码
- (void)getVetifyCodeWithPhone:(NSString *)phone
                    OnResponse:(void (^)(NSDictionary *dic))onResponse;

//登录
- (void)LoginWithPhone:(NSString *)phone
            VetifyCode:(NSString *)vetifiCode
            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取用户信息
- (void)getUserInforOnResponse:(void (^)(NSDictionary *dic))onResponse;

//更新用户信息
- (void)updateUserInforWithGender:(NSString *)gender
                         nickname:(NSString *)nickname
                            photo:(NSString *)photo
                       OnResponse:(void (^)(NSDictionary *dic))onResponse;

//上传用户头像
-(void)uploadHeadImageWithData:(NSData*)picData
                    OnResponse:(void (^)(NSDictionary *dic))onResponse;

//更新手机号获取验证信息
- (void)changePhoneGetVetifyCodeWithPhone:(NSString *)phone
                    OnResponse:(void (^)(NSDictionary *dic))onResponse;

//更新手机号
- (void)changePhoneWithPhone:(NSString *)phone
            VetifyCode:(NSString *)vetifiCode
            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//退出登录
- (void)exitLoginWithPhone:(NSString *)phone
            VetifyCode:(NSString *)vetifiCode
            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//用户注册推送
- (void)registerPushForGeTui;

//注销推送
- (void)exitPushForGeTui;

@end
