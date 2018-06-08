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

//注册
- (void)RegisterWithPhone:(NSString *)phone
            VetifyCode:(NSString *)vetifiCode
               InviteCode:(NSString *)inviteCode
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
                      status:(NSInteger)status
                  inviteCode:(NSString *)inviteCode
            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//退出登录
- (void)exitLoginWithPhone:(NSString *)phone
            VetifyCode:(NSString *)vetifiCode
            OnResponse:(void (^)(NSDictionary *dic))onResponse;

//上传PushID
- (void)upLoadPushID;


//用户注册推送
- (void)registerPushForGeTui;

//注销推送
- (void)exitPushForGeTui;

//用户分享成功的回调
- (void)shareSuccess;

//检查更新
- (void)checkVersion;

//第三方登录

//微信登录
- (void)loginByWeChatOnResponse:(void (^)(NSDictionary *dic))onResponse;

- (void)getWechatAccessTokenWithCode:(NSString *)code OnResponse:(void (^)(NSDictionary *dic))onResponse;

//qq登录
- (void)loginByTencentOnResponse:(void (^)(NSDictionary *dic))onResponse;

//qq登录成功(调server)
- (void)loginSuccessByTencentDic:(NSDictionary *)Dic OnResponse:(void (^)(NSDictionary *dic))onResponse;

//使用优惠券
- (void)useCouponId:(NSString *)couponId OnResponse:(void (^)(NSDictionary *dic))onResponse;

//下载广告页内容
- (void)downLoadAdsContentOnResponse:(void (^)(NSDictionary *dic))onResponse;

//校验邀请码是否有效
- (void)checkInviteCode:(NSString *)code OnResponse:(void (^)(NSDictionary *dic))onResponse;

//添加用户尺码表
- (void)addbust:(NSString *)bust hipline:(NSString *)hipline shoulderWidth:(NSString *)shoulderWidth theWaist:(NSString *)theWaist OnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取用户尺码表
- (void)getUserSizeOnResponse:(void (^)(NSDictionary *dic))onResponse;

//获取大学列表(同步操作)
- (void)getColedgeListStatus:(NSInteger)status OnResponse:(void (^)(NSDictionary *dic))onResponse;

//上传学校信息
- (void)postColledgeInforColledgeId:(NSString *)colledgeId OnResponse:(void (^)(NSDictionary *dic))onResponse;
@end
