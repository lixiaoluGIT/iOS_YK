//
//  YKInvitVC.m
//  YK
//
//  Created by edz on 2018/11/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKInvitVC.h"
#import "VTingSeaPopView.h"


@interface YKInvitVC ()<UIScrollViewDelegate,VTingPopItemSelectDelegate>{
    VTingSeaPopView *pop;
    NSMutableArray *imagelist;
    NSMutableArray *titles;
}
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *currentImage;
@property (nonatomic,strong)NSMutableArray *images;
@property (nonatomic,strong)NSMutableArray *imageIds;
@property (nonatomic,strong)NSString *imageId;
@property (nonatomic,strong)NSString *imageUrl;
@end

@implementation YKInvitVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getImages];
}

- (void)getImages{
    [[YKUserManager sharedManager]getShareImagesOnResponse:^(NSDictionary *dic) {
        
        self.images = [NSMutableArray array];
        self.imageIds = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"data"]];
        for (NSDictionary *dic in array) {
            [self.images addObject:dic[@"url"]];
        }
        for (NSDictionary *dic in array) {
            [self.imageIds addObject:dic[@"shareImgId"]];
        }
        
        [self creatScrollWithArray:self.images];
    }];
}

- (void)creatScrollWithArray:(NSArray *)array{
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(WIDHT*array.count, 0);
    for (int i=0; i<array.count; i++) {
        UIImageView *image = [[UIImageView alloc]init];
        image.frame = CGRectMake(WIDHT*i, 0, WIDHT, kSuitLength_H(430));
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", array[i]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
        [self.scrollView addSubview:image];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _images = [NSMutableArray array];
    
    titles = [NSMutableArray array];
        titles = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈", nil];
    imagelist = [NSMutableArray array];
        for (int i = 0; i<2; i++) {
            if (i==0) {
                [imagelist addObject:[UIImage imageNamed:[NSString stringWithFormat:@"weixin111"]]];
            }else{
                [imagelist addObject:[UIImage imageNamed:[NSString stringWithFormat:@"pengyouquan"]]];
            }
        }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"邀请有奖";
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
    title.font = PingFangSC_Regular(kSuitLength_H(14));;
    
    [self setUpUI];
}

- (void)setUpUI{
    UIScrollView *bigScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];
    bigScrollView.contentSize = CGSizeMake(0, HEIGHT*1.3);
    bigScrollView.scrollEnabled = YES;
    [self.view addSubview:bigScrollView];
    
    UILabel *l1 = [[UILabel alloc]initWithFrame:CGRectMake(kSuitLength_H(20), 0, WIDHT-20, kSuitLength_H(55))];
    l1.text = @"方法一：分享海报，好友扫码接受邀请";
    l1.textColor = mainColor;
    l1.font = PingFangSC_Regular(kSuitLength_H(14));
    l1.textAlignment = NSTextAlignmentLeft;
    [bigScrollView addSubview:l1];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, l1.frame.size.height + l1.frame.origin.y,WIDHT, kSuitLength_H(430))];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [bigScrollView addSubview:self.scrollView];
    
    //左箭头
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
     UIButton *left11 = [UIButton buttonWithType:UIButtonTypeCustom];
    left11.frame = CGRectMake(0, 0, kSuitLength_H(60), kSuitLength_H(410));
    [left11 addTarget:self action:@selector(toleft) forControlEvents:UIControlEventTouchUpInside];
    [bigScrollView addSubview:left11];
    left.frame = CGRectMake(kSuitLength_H(16), self.scrollView.top + self.scrollView.frame.size.height/2-kSuitLength_H(16)/2, kSuitLength_H(7), kSuitLength_H(9));
    [left setImage:[UIImage imageNamed:@"右-2"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(toleft) forControlEvents:UIControlEventTouchUpInside];
    [bigScrollView addSubview:left];
    //右箭头
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *right11 = [UIButton buttonWithType:UIButtonTypeCustom];
    right11.frame = CGRectMake(WIDHT-kSuitLength_H(60), 0, kSuitLength_H(60), kSuitLength_H(410));
    [right11 addTarget:self action:@selector(toright) forControlEvents:UIControlEventTouchUpInside];
    [bigScrollView addSubview:right11];
    
    right.frame = CGRectMake(WIDHT-kSuitLength_H(16)-kSuitLength_H(7), self.scrollView.top + self.scrollView.frame.size.height/2-kSuitLength_H(16)/2, kSuitLength_H(7), kSuitLength_H(9));
    [right setImage:[UIImage imageNamed:@"右-2"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(toright) forControlEvents:UIControlEventTouchUpInside];
    CABasicAnimation* rotationAnimation;
    
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
        rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI];
    
        rotationAnimation.duration = 0.3;
    
        rotationAnimation.cumulative = YES;
    
        rotationAnimation.repeatCount = 0;
    
        [right.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
 
    [bigScrollView addSubview:right];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kSuitLength_H(50), self.scrollView.bottom+kSuitLength_H(20), WIDHT-kSuitLength_H(50)*2, kSuitLength_H(36));
    shareBtn.backgroundColor = YKRedColor;
    [shareBtn setTitle:@"分享这张海报给好友" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
    [bigScrollView addSubview:shareBtn];
    shareBtn.layer.shadowColor = [UIColor colorWithHexString:@"ABA9A9"].CGColor;
    shareBtn.layer.shadowOpacity = 0.5f;
    shareBtn.layer.shadowRadius = 4.f;
    shareBtn.layer.shadowOffset = CGSizeMake(2,2);
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *l2 = [[UILabel alloc]initWithFrame:CGRectMake(kSuitLength_H((20)), shareBtn.frame.origin.y + shareBtn.frame.size.height + kSuitLength_H(20), WIDHT-kSuitLength_H(20), kSuitLength_H(55))];
    l2.text = @"方法二：好友填写邀请码接受邀请";
    l2.textColor = mainColor;
    l2.font = PingFangSC_Regular(kSuitLength_H(14));
    l2.textAlignment = NSTextAlignmentLeft;
//    l2.backgroundColor = [UIColor grayColor];
    [bigScrollView addSubview:l2];
    
    UILabel *inviteCode = [[UILabel alloc]initWithFrame:CGRectMake(kSuitLength_H(61), l2.bottom, WIDHT-kSuitLength_H(61)*2, kSuitLength_H(60))];
    inviteCode.text = [NSString stringWithFormat:@"   我的专属邀请码：    %@",[YKUserManager sharedManager].user.inviteCode];
    inviteCode.textColor = mainColor;
    inviteCode.font = PingFangSC_Regular(kSuitLength_H(12));
    inviteCode.textAlignment = NSTextAlignmentLeft;
    [bigScrollView addSubview:inviteCode];
    inviteCode.backgroundColor = [UIColor whiteColor];
    
    //设置阴影
    inviteCode.layer.shadowColor = [UIColor colorWithHexString:@"ABA9A9"].CGColor;
    inviteCode.layer.shadowOpacity = 0.5f;
    inviteCode.layer.shadowRadius = 4.f;
    inviteCode.layer.shadowOffset = CGSizeMake(2,2);
  
    UIButton *copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSuitLength_H(61), inviteCode.bottom, WIDHT-kSuitLength_H(61)*2, kSuitLength_H(36))];
    copyBtn.backgroundColor = YKRedColor;
    [copyBtn setTitle:@"复制邀请码" forState:UIControlStateNormal];
    copyBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(14));
    [bigScrollView addSubview:copyBtn];
    [copyBtn addTarget:self action:@selector(cop) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cop{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSString *Code;
    Code = [YKUserManager sharedManager].user.inviteCode.length>0?[YKUserManager sharedManager].user.inviteCode:@"我的邀请码";
    pboard.string = Code;
    
    [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"复制成功" delay:1.5];
}

- (void)toleft{
    CGFloat l = self.scrollView.contentOffset.x;
    if (l>0) {
       [self.scrollView setContentOffset:CGPointMake(l-WIDHT, 0) animated:YES];
    }
   
}

- (void)toright{
    CGFloat l = self.scrollView.contentOffset.x;
    if (l<(self.images.count-1)*WIDHT) {
        [self.scrollView setContentOffset:CGPointMake(l+WIDHT, 0) animated:YES];
    }
    
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = self.scrollView.contentOffset.x;
    int index = x/WIDHT;
    self.imageId = [NSString stringWithFormat:@"%@",self.imageIds[index]];
    
}
- (void)toShare{
    //弹出两种方式
    pop = [[VTingSeaPopView alloc] initWithButtonBGImageArr:imagelist  andButtonBGT:titles];
    [[UIApplication sharedApplication].keyWindow addSubview:pop];
    pop.delegate = self;
    [pop show];
}
- (void)shareAction{
    [[YKUserManager sharedManager]getShareImageShareimageId:self.imageId OnResponse:^(NSDictionary *dic) {
        //弹出分享
        _imageUrl = [NSString stringWithFormat:@"%@",dic[@"data"]];
        [self toShare];
    }];
}


//#pragma mark delegate
-(void)itemDidSelected:(NSInteger)index {



//    WXMediaMessage *message = [WXMediaMessage message];
//    //    [message setThumbImage:[UIImage imageNamed:@""]];
//
//    WXImageObject *ext = [WXImageObject object];
////    NSString *filePath = _imageUrl;
//    NSURL *url = [NSURL URLWithString:_imageUrl];
//    ext.imageData  = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:ext.imageData];
//
////    UIImageView *imageView = [[UIImageView alloc]init];
////    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
//
//    [message setThumbImage:image];
//
//    ext.imageData  = UIImagePNGRepresentation(image);
//
//    message.mediaObject = ext;
//
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.bText   = NO;
//    req.message = message;
    
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    //2.创建多媒体消息中包含的图片数据对象
    WXImageObject *imgObj = [WXImageObject object];
    //图片真实数据
    imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
    //多媒体数据对象
    mediaMsg.mediaObject = imgObj;
    
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(聊天界面)
    req.scene = WXSceneSession;
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];

    if (index==0) {
        req.scene   = WXSceneSession ;
    }else {
        req.scene   = WXSceneTimeline ;
    }

    [WXApi sendReq:req];
}
@end
