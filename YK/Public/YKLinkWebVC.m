//
//  YKLinkWebVC.m
//  YK
//
//  Created by LXL on 2018/1/10.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKLinkWebVC.h"
#import "YKMainVC.h"

@interface YKLinkWebVC ()<UIWebViewDelegate>{
    UILabel *title;
}

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;

//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *flexSpacer;

@end

@implementation YKLinkWebVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self creatWeb];
    self.webView.scrollView.bounces = NO;
    
}

- (void)viewDidLoad {

    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"衣庫";
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
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    title.font = PingFangSC_Semibold(20);;

    self.navigationItem.titleView = title;
    [self creatWeb];
}

- (void)leftAction{
    if (_status == 1) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        window.rootViewController = [YKMainVC new];
        
        CATransition *anim = [CATransition animation];
        anim.duration = 0.8;
        anim.type = @"fade";
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)creatWeb{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIDHT, HEIGHT-64)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURL* url = [NSURL URLWithString:[self URLEncodedString:_url]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-10, 20, 20)];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_indicatorView startAnimating];
    [self.view addSubview:_indicatorView];
    _indicatorView.hidden = NO;
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

-(void)webViewDidFinishLoad:(UIWebView*)webView {
    
   
    NSString *allHtml =[_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    //获取网页title
    
    NSString *htmlTitle = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    if ([htmlTitle length] == 0) {
        title.text = @"衣库";
    }else {
        title.text = htmlTitle;
        
    }

    
    _indicatorView.hidden = YES;
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"requestString : %@",requestString);
   
        return YES;
    
    
}
-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error{
    _indicatorView.hidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}



@end
