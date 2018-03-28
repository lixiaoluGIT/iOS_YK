//
//  YKBaseScrollView.m
//  YK
//
//  Created by LXL on 2018/3/13.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBaseScrollView.h"
#define SYRealValue(value) ((value)/414.0f*[UIScreen mainScreen].bounds.size.width) ///<屏幕以6p为准
#define SCREEN_SIZE [UIScreen mainScreen].bounds
#define SCREEN_WIDTH SCREEN_SIZE.size.width
#define SCREEN_HEIGHT SCREEN_SIZE.size.height
#define SVHeight 150
#define pageCBottom 20
#define pageCH 30
#define perWidth 20

@interface YKBaseScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *SV;///< 滚动视图
@property (nonatomic,strong)UIPageControl *pageC;///< pageControll

@end

@implementation YKBaseScrollView
{
    CGPoint _currentPoint;///< 当前偏移量
    NSTimer *_timer;///< 定时器对象
}

- (void)setImageClickUrls:(NSArray *)imageClickUrls{
    _imageClickUrls = imageClickUrls;
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
- (void)setImagesArr:(NSArray *)imagesArr {
    _imagesArr = imagesArr;
    
    ///< 测试数据
//    self.imagesArr = [NSMutableArray arrayWithObjects:@"00.jpg",@"01.jpg",@"02.jpg",@"03.jpg",@"04.jpg", nil];
    //self.images = [NSMutableArray arrayWithObjects:@"00.jpg",@"01.jpg",@"02.jpg",@"03.jpg",@"04.jpg",@"IMG_0298.jpg",@"IMG_0299.jpg", nil];///< 可改变数据源，动态添加
    self.SV.contentSize = CGSizeMake(SCREEN_WIDTH*(self.imagesArr.count+2), SYRealValue(SVHeight));
    self.SV.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    ///< 循环创建imgV
    for (int i = 0; i<self.imagesArr.count+2; i++) {
        UIImageView *imgV = [[UIImageView alloc]init];
        if (i == 0) {///< SV最左边的图其实是最后一张，通过设置contentoffset为SCREEN_WIDTH隐藏在最左边
//            imgV.image = [UIImage imageNamed:self.imagesArr[self.imagesArr.count-1]];
            
            [imgV sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:self.imagesArr[self.imagesArr.count-1]]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
        } else if (i == self.imagesArr.count + 1) {///< SV最右边的图其实是第一张
//            imgV.image = [UIImage imageNamed:self.imagesArr[0]];
            [imgV sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:self.imagesArr[0]]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
        } else {
//            imgV.image = [UIImage imageNamed:self.imagesArr[i-1]];
            [imgV sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:self.imagesArr[i-1]]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
            imgV.userInteractionEnabled = YES;
            imgV.tag = i;

        }
        [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClickAction:)]];
        imgV.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.frame.size.height);
        
        [self.SV addSubview:imgV];
    }
    
    ///< 初始化pageControl
    self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-SYRealValue(perWidth*self.imagesArr.count))/2, SYRealValue(SVHeight)+BarH-SYRealValue(pageCBottom), SYRealValue(perWidth*self.imagesArr.count), SYRealValue(pageCH))];
    //  self.pageC.backgroundColor = [UIColor redColor];
    self.pageC.numberOfPages = self.imagesArr.count;
    self.pageC.currentPage = 0;
    self.pageC.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageC.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"999999"];
    self.pageC.hidesForSinglePage = YES;
    [self.pageC addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageC];
    
    ///< 设置定时器
    _currentPoint = CGPointMake(SCREEN_WIDTH, 0);///< 当前偏移量赋初值
    [self setupTimer];
    [self setupListen];

    
    // 如果图片数量小于二 将pageControl隐藏
    if (imagesArr.count < 2) {
        self.pageC.hidden = YES;
    }
}

/** 图片点击事件 */
- (void)imgVClickAction:(UIGestureRecognizer *)tap {
    NSLog(@"点击了第:%ld张图片", tap.view.tag);
    
    if ([self.delegate respondsToSelector:@selector(YKBaseScrollViewImageClick:)]) {
        [self.delegate YKBaseScrollViewImageClick:tap.view.tag];
    }
}

/** 设置监听定时器某一个时间段内是否存在的的定时器，解决UIPageControl响应事件会移除定时器的问题 */
- (void)setupListen {
    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (!_timer) {
                [self setupTimer];///< 循环监听并添加定时器
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

/** page响应事件 */
- (void)pageChange:(UIPageControl *)sender {
    [self removeTimer];
    UIPageControl *pageC = (UIPageControl *)sender;
    NSInteger page = pageC.currentPage;
    [self.SV setContentOffset:CGPointMake((page+1)*SCREEN_WIDTH, 0) animated:YES];
}

/** 设置定时器 */
- (void)setupTimer {
    if (@available(iOS 10.0, *)) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (_currentPoint.x == 0) {///< 偏移量为0，即将展示真正的第一张图
                [UIView animateWithDuration:0.3 animations:^{
                    self.pageC.currentPage = 0;
                    [self.SV setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
                    _currentPoint = self.SV.contentOffset;
                    
                }];
            } else if (_currentPoint.x == self.SV.contentSize.width-2*SCREEN_WIDTH) {///< 偏移量展示最后一张图，即将展示虚拟的第一张图
                [UIView animateWithDuration:0.3 animations:^{
                    self.pageC.currentPage = 0;
                    [self.SV setContentOffset:CGPointMake(_currentPoint.x+SCREEN_WIDTH, 0) animated:NO];
                } completion:^(BOOL finished) {///< 动画结束偷偷的把偏移量设置为真正的第一张图
                    [self.SV setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
                    _currentPoint = self.SV.contentOffset;
                    
                }];
            } else { ///< 其他情况偏移量增加SCREEN_WIDTH
                [UIView animateWithDuration:0.3 animations:^{
                    self.pageC.currentPage = self.SV.contentOffset.x/SCREEN_WIDTH;
                    [self.SV setContentOffset:CGPointMake(_currentPoint.x+SCREEN_WIDTH, 0) animated:NO];
                    _currentPoint = self.SV.contentOffset;
                }];
            }
            
        }];
    } else {
        // Fallback on earlier versions
    }
}

/** 移除定时器 */
- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark *****scrollview Delegate*****
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.x == 0) {///< 偏移量为0，展示最后一张图片
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*SCREEN_WIDTH, 0);
        self.pageC.currentPage = self.imagesArr.count-1;
    } else if (point.x == scrollView.contentSize.width-SCREEN_WIDTH) {///< 偏移量到最后一张图时，展示第一张图片
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        self.pageC.currentPage = 0;
    } else {
        self.pageC.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH-1;
    }
    _currentPoint = self.SV.contentOffset;///< 记录滚动之后的偏移量
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ///< 初始化SV
        self.SV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        self.SV.backgroundColor = [UIColor redColor];
        self.SV.showsVerticalScrollIndicator = NO;
        self.SV.showsHorizontalScrollIndicator = NO;
        self.SV.pagingEnabled = YES;
        self.SV.delegate = self;
//        self.automaticallyAdjustsScrollViewInsets = NO;///< 取消自动偏移
        [self addSubview:self.SV];
        //        [self createPageControl];
    }
    return self;
}


@end
