//
//  YKShareManager.m
//  YK
//
//  Created by LXL on 2018/3/19.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKShareManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

@implementation YKShareManager

+ (YKShareManager *)sharedManager{
    static YKShareManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)YKShareProductClothingId:(NSString *)ClothingId{
    
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Facebook),@(UMSocialPlatformType_Twitter)]]; // 设置需要分享的平台
    
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            NSLog(@"回调");
            NSLog(@"%ld",(long)platformType);
            NSLog(@"%@",userInfo);
    
    
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
            //创建网页内容对象
            NSString* thumbURL =  @"http://img-cdn.xykoo.cn/clothing/流苏民族格纹毛衣外套/clothingImg";
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"我在衣库看上了一件衣服,欢迎大家来围观" descr:@"衣服分享" thumImage:thumbURL];
            //设置网页地址
            shareObject.webpageUrl = @"http://dingniu8.com/desk/UploadPic/2013-1/201311122394666.jpg";
    
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
    
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                NSLog(@"调用分享接口");
    
                if (error) {
                    NSLog(@"调用失败%@",error);
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"调用成功");
                    //弹出分享成功的提示,告诉后台,成功后getuser
                    
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
    
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
                //        [self alertWithError:error];
            }];
        }];
}

@end
