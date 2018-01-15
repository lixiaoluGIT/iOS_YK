//
//  YKWebVC.m
//  YK
//
//  Created by LXL on 2017/12/18.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKWebVC.h"

@interface YKWebVC ()

@end

@implementation YKWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, WIDHT, HEIGHT); // frame中的size指UIScrollView的可视范围
         scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scrollView];

        // 2.创建UIImageView（图片）
         UIImageView *imageView = [[UIImageView alloc] init];
         imageView.image = [UIImage imageNamed:_imageName];
         CGFloat imgW = imageView.image.size.width; // 图片的宽度
         CGFloat imgH = imageView.image.size.height; // 图片的高度
    CGFloat pix = imgW/imgH;//宽高比
         imageView.frame = CGRectMake(0, 0, WIDHT,WIDHT/pix);
         [scrollView addSubview:imageView];
    
         // 3.设置scrollView的属性
    
         // 设置UIScrollView的滚动范围（内容大小）
         scrollView.contentSize = CGSizeMake(0, WIDHT/pix);

    imageView.image = [UIImage imageNamed:_imageName];
    
    [scrollView addSubview:imageView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _titleStr;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 44);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 11) {
        btn.frame = CGRectMake(0, 0, 44, 44);//ios7以后右边距默认值18px，负数相当于右移，正数左移
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
    title.font = PingFangSC_Regular(17);
    
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
