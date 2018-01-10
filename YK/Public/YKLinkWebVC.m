//
//  YKLinkWebVC.m
//  YK
//
//  Created by LXL on 2018/1/10.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKLinkWebVC.h"

@interface YKLinkWebVC ()<UIWebViewDelegate>

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
    self.title = @"衣庫";
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
    
    self.navigationItem.titleView = title;
    [self creatWeb];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)creatWeb{
    CGRect bounds = self.view.frame;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIDHT, HEIGHT-64)];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURL* url = [NSURL URLWithString:_url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-10, 20, 20)];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_indicatorView startAnimating];
    [self.view addSubview:_indicatorView];
    _indicatorView.hidden = NO;
}



-(void)webViewDidFinishLoad:(UIWebView*)webView {
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    

    
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
