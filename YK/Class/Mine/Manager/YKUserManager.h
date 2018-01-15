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

//上传PushID
- (void)upLoadPushID;


/**
 *  绑定别名功能:后台可以根据别名进行推送
 *
 *  @param alias 别名字符串
 *  @param aSn   绑定序列码, 不为nil
 */
+ (void)bindAlias:(NSString *)alias andSequenceNum:(NSString *)aSn;

/**
 *  取消绑定别名功能
 *
 *  @param alias   别名字符串
 *  @param aSn     绑定序列码, 不为nil
 *  @param isSelf  是否只对当前cid有效，如果是true，只对当前cid做解绑；如果是false，对所有绑定该别名的cid列表做解绑
 */
+ (void)unbindAlias:(NSString *)alias andSequenceNum:(NSString *)aSn andIsSelf:(BOOL) isSelf;

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

@end
