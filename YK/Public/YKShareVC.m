//
//  YKShareVC.m
//  YK
//
//  Created by LXL on 2018/1/4.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKShareVC.h"
#import "YKShareSuccessView.h"
#import "VTingSeaPopView.h"
#import "YKSharebView.h"
#import <UMShare/UMShare.h>
#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

@interface YKShareVC ()<VTingPopItemSelectDelegate> {
    NSMutableArray *images;
    NSMutableArray *titles;
    VTingSeaPopView *pop;
    UIView *backView;
    YKShareSuccessView *su ;
    UIButton *close;
}
@end

@implementation YKShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatShareSuccessNotification) name:@"wechatShareSuccessNotification" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分享";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    }
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;//ios7以后右边距默认值18px，负数相当于右移，正数左移
    if ([[UIDevice currentDevice].systemVersion floatValue]< 11) {
        negativeSpacer.width = -18;
    }
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,item];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    title.text = self.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Semibold(20);;
    
    self.navigationItem.titleView = title;
    
    UIImageView *im = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"invite"]];
    [self.view addSubview:im];
    
    [im sizeToFit];
    CGFloat scale = im.frame.size.width/im.frame.size.height;
    im.frame = CGRectMake(0, 64, WIDHT, WIDHT/scale);
    
    UILabel *des = [[UILabel alloc]initWithFrame:CGRectMake(0, im.frame.size.height+im.frame.origin.y+14, WIDHT, 22)];
    des.text = @"分享给好友，获取5天会员加时";
    des.textColor = YKRedColor;
    des.font = PingFangSC_Semibold(16);
    des.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:des];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(88*WIDHT/414, im.frame.size.height+im.frame.origin.y+50, WIDHT-88*WIDHT/414*2, 40);
    btn1.layer.masksToBounds = YES;
//    btn1.layer.cornerRadius = 20;
    btn1.backgroundColor = mainColor;
    [btn1 setTitle:@"分享给好友" forState:UIControlStateNormal];
    
    btn1.titleLabel.font = PingFangSC_Regular(14);
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, im.frame.size.height+im.frame.origin.y+50, WIDHT, 50);
    [btn2 addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    //我的邀请码
  
  YKSharebView *buttom1 = [[NSBundle mainBundle] loadNibNamed:@"YKSharebView" owner:self options:nil][1];
    buttom1.frame = CGRectMake(20, btn2.frame.size.height+btn2.frame.origin.y+19, WIDHT-40, 42);
    [self.view addSubview:buttom1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paste)];
    [buttom1 addGestureRecognizer:tap];
    
    //规则说明
    YKSharebView *buttom = [[NSBundle mainBundle] loadNibNamed:@"YKSharebView" owner:self options:nil][0];
    buttom.frame = CGRectMake(20, buttom1.frame.size.height+buttom1.frame.origin.y+14, WIDHT-40, 260);
    buttom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttom];
    
    backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    backView.hidden = YES;
    
    su = [[NSBundle mainBundle] loadNibNamed:@"YKShareSuccessView" owner:self options:nil][0];
    su.selectionStyle = UITableViewCellSelectionStyleNone;
    su.frame = CGRectMake(57*WIDHT/414, 210*WIDHT/414, WIDHT-57*WIDHT/414*2, 270*WIDHT/414);
    su.layer.cornerRadius = 4;
    su.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:su];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:su];
    su.hidden = YES;
    
    close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setBackgroundImage:[UIImage imageNamed:@"guanbi-1"] forState:UIControlStateNormal];
    [[UIApplication sharedApplication].keyWindow addSubview:close];
    close.frame = CGRectMake(WIDHT/2-20, HEIGHT-80, 40, 40) ;
    [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    close.hidden = YES;

    images = [NSMutableArray array];
    titles = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈", nil];
    
    for (int i = 0; i<2; i++) {
        if (i==0) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"weixin-1"]]];
        }else{
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"pengyouquan"]]];
        }
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
}

- (void)paste{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = @"我的邀请码";
    
    [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"复制成功" delay:1.5];
}

- (void)close{
    [su removeFromSuperview];
    [backView removeFromSuperview];
    [close removeFromSuperview];
}

- (void)share{
    //    [[YKShareManager sharedManager]YKShareProductClothingId:@""];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]]; // 设置需要分享的平台
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"回调");
        NSLog(@"%ld",(long)platformType);
        NSLog(@"%@",userInfo);
        
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
//        NSString* thumbUR =  self.imagesArr[0];
//        NSString *thumbURL = [self URLEncodedString:thumbUR];
        UIImage *image = [UIImage imageNamed:@"logo"];
//        [image setContentMode:UIViewContentModeScaleAspectFit];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"欢迎加入衣库，首月仅需149！"] descr:@"点击领取优惠券，可兑现哦！" thumImage:image];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"http://img-cdn.xykoo.cn/appHtml/invite/invite.html?id=%@", [YKUserManager sharedManager].user.userId];
        
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
- (void)toShare{
    //弹出两种方式
    
    
    pop = [[VTingSeaPopView alloc] initWithButtonBGImageArr:images andButtonBGT:titles];
    [[UIApplication sharedApplication].keyWindow addSubview:pop];
    pop.delegate = self;
    [pop show];
}

#pragma mark delegate
-(void)itemDidSelected:(NSInteger)index {
    
    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:[UIImage imageNamed:@""]];
  
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"newka" ofType:@"png"];
    ext.imageData  = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:ext.imageData];
    
    [message setThumbImage:image];
    
    ext.imageData  = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    if (index==0) {
         req.scene   = WXSceneSession ;
    }else {
        req.scene   = WXSceneTimeline ;
    }
   
    
    [WXApi sendReq:req];
}

//接收分享成功的通知
- (void)wechatShareSuccessNotification{
    [[YKUserManager sharedManager]shareSuccess];
    backView.hidden = NO;
    su.hidden = NO;
    close.hidden = NO;
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
