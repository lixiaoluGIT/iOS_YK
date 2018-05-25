//
//  YKYifuScanCell.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKYifuScanCell.h"
#import "LMLGestureHeadImageScrollView.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

//屏幕的宽度
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHight  [UIScreen mainScreen].bounds.size.height

#define DISTENCEW (([UIScreen mainScreen].bounds.size.width) / 320)
#define DISTENCEH (([UIScreen mainScreen].bounds.size.height) / 568)

/*状态栏高度*/

#define STATUS_HEIGHT 20

/*导航栏高度*/

#define NAVGATION_HEIGHT 44

/*状态栏加导航栏高度*/

#define NAVGATION_ADD_STATUS_HEIGHT (STATUS_HEIGHT + NAVGATION_HEIGHT)


/* tabbar 高度*/
#define TABBAR_HEIGHT 49
#define ImageWidthClearance 3   //  图片之间横向的缝隙大小
#define ImageHeightClearance 3  //  图片之间纵向的缝隙大小
//  小图的大小
#define ImageWidth ((screenWidth - 12 - 6) / 3)
//  全图的大小
#define AllImageWidth (screenWidth - 6)

@interface YKYifuScanCell()<UIScrollViewDelegate>
{
    UIScrollView *background;
    LMLGestureHeadImageScrollView *imageScroll;
}
@property(nonatomic)BOOL zoomOut_In;
@property(nonatomic,strong)UIImageView *image;

@property (nonatomic, strong) UIScrollView *imageScroll;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation YKYifuScanCell

- (void)setImageView:(UIImageView *)imageView{
    _imageView = imageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageView.userInteractionEnabled = YES;
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//    [_imageView addGestureRecognizer:tapGesture];
   
}

//- (void)setImageArray:(NSArray *)imageArray{
//    _imageArray = imageArray;
//    [self frame:CGRectMake(0, 0, screenWidth, screenHight) imageWithArr:self.imageArray];
//}
- (void)scrTap:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.imageScroll.alpha = 0;
        _pageControl.hidden = YES;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    int number = offSetX / screenWidth;
    _pageControl.currentPage = number;
}


- (void)frame:(CGRect)frame imageWithArr:(NSArray *)imageArr{
    
    UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHight)];
    imageScroll.backgroundColor = [UIColor blackColor];
    imageScroll.contentSize = CGSizeMake(screenWidth * imageArr.count, screenHight);
    imageScroll.pagingEnabled = YES;
    imageScroll.bounces = NO;
    imageScroll.alpha = 0;
    imageScroll.delegate = self;
    self.imageScroll = imageScroll;
    imageScroll.userInteractionEnabled = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:imageScroll];
    
    
    for (int i = 0; i < imageArr.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth * i, (screenHight - AllImageWidth) / 2, AllImageWidth, AllImageWidth)];
        UIImageView *imageView = [[UIImageView alloc] init];
    
         imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:@""]  placeholderImage:[UIImage imageNamed:@"商品详情头图"]];
        
        imageView.frame = CGRectMake((WIDHT-imageView.frame.size.width)/2, (HEIGHT-imageView.frame.size.height)/2,imageView.frame.size.width ,imageView.frame.size.height);
       
        [imageScroll addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.2;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [imageView.layer addAnimation:animation forKey:nil];
    }
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake((screenWidth - 20) / 2, screenHight - 50, 20, 20);
    pageControl.numberOfPages = imageArr.count;
    pageControl.currentPage = 0;
    pageControl.hidden = YES;
    pageControl.pageIndicatorTintColor = RGB_COLOR(70, 70, 70);
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl = pageControl;
    [[UIApplication sharedApplication].keyWindow addSubview:pageControl];
    
    
    UITapGestureRecognizer *scrTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrTap:)];
    scrTap.numberOfTapsRequired = 1;
    scrTap.numberOfTouchesRequired = 1;
    [imageScroll addGestureRecognizer:scrTap];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = ImageHeightClearance;
    layout.minimumInteritemSpacing = ImageWidthClearance;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    

    
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
/////////////////
- (void) tapAction{
    
//    NSUInteger tag = self.num;
//
//    self.imageScroll.contentOffset = CGPointMake(screenWidth * tag, 0);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.imageScroll.alpha = 1;
//    } completion:^(BOOL finished) {
//        _pageControl.hidden = NO;
//    }];
    
    imageScroll = [[LMLGestureHeadImageScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT) andHeadImage:_imageView.image];
//
    [[UIApplication sharedApplication].keyWindow addSubview:imageScroll];
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    background = bgView;

    [background setBackgroundColor:[UIColor blackColor]];
    [[UIApplication sharedApplication].keyWindow addSubview:background];
    [background addSubview:imageScroll];

    background.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];

    [background addGestureRecognizer:tapGesture];
//
    [self shakeToShow:imageScroll];//放大过程中的动画
}

-(void)closeView{
    [UIView animateWithDuration:0.2 animations:^{
        background.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView transitionFromView:background toView:background duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            [background removeFromSuperview];
            
        }];
    }];
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

@end
