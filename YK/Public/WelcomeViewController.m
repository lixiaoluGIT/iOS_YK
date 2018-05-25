//
//  WelcomeViewController.m
//  StartAppPageViewControl
//
//  Created by 冷求慧 on 16/12/19.
//  Copyright © 2016年 冷求慧. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ViewController.h"

#import "ChangeFontWithLabel.h"
#import "ChangeFontWithButton.h"

#import "CusPageControlWithView.h"  // 自定义的Page视图
#import "YKMainVC.h"

#import "STPageControl.h"

#define screenWidthW  [[UIScreen mainScreen] bounds].size.width
#define screenHeightH [[UIScreen mainScreen] bounds].size.height


#define showTitleLabelH 28*titleRatio

#define startButtonW  100*titleRatio   // 按钮的宽高
#define startButtonH  40*titleRatio

#define imageCount 4


@interface WelcomeViewController ()<UIScrollViewDelegate>
{
    CusPageControlWithView *pageView;
    NSMutableArray *arrTitleName;
}

/**
 *  2.仿系统pageControl
 */
@property (nonatomic, weak, nullable)STPageControl *pageSystem;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UD setBool:YES forKey:@"notFirst"];
    
    [self createScrollView];
    [self addPageControl];

}
#pragma mark 创建UIScrollView
-(void)createScrollView{
    arrTitleName=[NSMutableArray array];
//    [arrTitleName addObjectsFromArray:@[@"衣库衣库衣库衣库衣库衣库",@"衣库衣库衣库衣库衣库",@"衣库衣库衣库衣库衣库"]];
    
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    scrollView.frame=[UIScreen mainScreen].bounds;
    scrollView.pagingEnabled=YES;//设置分页
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.bounces=NO;//设置不能弹回
    scrollView.delegate=self;
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*imageCount, 0);
    //添加图片
    for (int i=0; i<imageCount; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        NSString *strImageName=[NSString stringWithFormat:@"引导页%zi copy",i+1];
        imageView.image=[UIImage imageNamed:strImageName];
        imageView.frame=CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        
        if (HEIGHT==812) {
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
        }
        
//        ChangeFontWithLabel *showTitleLabel=[[ChangeFontWithLabel alloc]initWithFrame:CGRectMake(0, screenHeightH*0.7, screenWidthW, showTitleLabelH)];  //在图片上面添加UILabel
//        showTitleLabel.text=arrTitleName[i];
//        showTitleLabel.textColor=[UIColor whiteColor];
//        showTitleLabel.textAlignment=NSTextAlignmentCenter;
//        showTitleLabel.cusFont=[UIFont systemFontOfSize:18];
//        [imageView addSubview:showTitleLabel];
        
        //在最后一个UIImageView上面添加开始App按钮
        if (i==imageCount-1) {
            [self addStartButton:imageView];//在图片上面添加开始微博按钮
        }
        [scrollView addSubview:imageView];//将图片视图添加到ScrollView上面
    }
    [self.view addSubview:scrollView];//将ScrollView添加到控制器的View上面
}
#pragma mark ScrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat  getNum=scrollView.contentOffset.x/scrollView.frame.size.width;
    NSInteger pageValue=(NSInteger)(getNum+0.5);
    
    _pageSystem.currentPage = pageValue;
    pageView.indexNumWithSlide=pageValue; // 这个属性中的Setting会调用很多次,所以在其里面判断前后值
    if(pageValue==(imageCount-1)){
        pageView.hidden=YES;
        _pageSystem.hidden = YES;
    }
    else{
        pageView.hidden=NO;
        _pageSystem.hidden = NO;
    }
}
#pragma mark 创建UIPageControl
-(void)addPageControl{
//    CGRect rectValue=CGRectMake(0, self.view.frame.size.height*0.85, screenWidthW, 33);
//    UIImage *currentImage=[UIImage imageNamed:@"red"];
//    UIImage *pageImage=[UIImage imageNamed:@"white"];;
//    pageView=[CusPageControlWithView cusPageControlWithView:rectValue pageNum:imageCount currentPageIndex:0 currentShowImage:currentImage pageIndicatorShowImage:pageImage];
//    [self.view addSubview:pageView];
    
    STPageControl *pageDefault = [STPageControl pageControlDefaultWithFrame:CGRectMake(0,HEIGHT*0.9, screenWidthW, 33)
                                                              numberOfPages:imageCount
                                                            coreNormalColor:[UIColor whiteColor]
                                                          coreSelectedColor:mainColor
                                                            lineNormalColor:[UIColor blackColor]
                                                          lineSelectedColor:[UIColor blackColor]];
    [self.view addSubview:pageDefault];
//    pageDefault.backgroundColor = [UIColor yellowColor];
//    [pageDefault setCenter:CGPointMake(self.view.frame.size.width/2, 200)];

    self.pageSystem = pageDefault;
}
#pragma mark 在图片上面添加开始按钮
-(void)addStartButton:(UIImageView *)imageView{
    
    imageView.userInteractionEnabled=YES;//设置UIImageView可以点击,不然UIButton不能点击
    ChangeFontWithButton *button=[[ChangeFontWithButton alloc]init];
    [button setTitle:@"开始体验" forState:UIControlStateNormal];
    button.cusFont=[UIFont boldSystemFontOfSize:13];
    button.layer.cornerRadius=8;
    button.layer.masksToBounds=YES;
    button.backgroundColor = mainColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    button.frame=CGRectMake(screenWidthW/2-startButtonW/2, screenHeightH*0.86, startButtonW, startButtonH);
    [button addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];//将按钮添加到最后一个UIImageView里面
}
#pragma mark 开始App
-(void)startApp{
    YKMainVC *VC= [[YKMainVC alloc]init];
    UIWindow *windows=[UIApplication sharedApplication].keyWindow;
    windows.rootViewController=VC;
    
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
