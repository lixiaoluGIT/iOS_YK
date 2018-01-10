
//
//  ZYCollectionView.m
//  赵杨图片轮播
//
//  Created by 轶辉 on 16/10/11.
//  Copyright © 2016年 YiHui. All rights reserved.
//

#import "ZYCollectionView.h"
#import "ZYCollectionViewCell.h"
#import "CusPageControlWithView.h"  // 自定义的Page视图
#define ZYCycleID @"ZYCycleID"

@interface ZYCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
     CusPageControlWithView *pageView;
}

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
//@property (nonatomic, strong) UIPageControl    * pageControl;
@property (nonatomic, strong) UICollectionView * cycleCollectionView;
@property (nonatomic, strong) NSTimer          * timer;
@property (nonatomic, assign) NSInteger index;

@end


@implementation ZYCollectionView

- (void)setImageClickUrls:(NSArray *)imageClickUrls{
    _imageClickUrls = imageClickUrls;
}

- (void)setImagesArr:(NSArray *)imagesArr {
    _imagesArr = imagesArr;
    
    if (self.cycleCollectionView){
        [_cycleCollectionView reloadData];
        [self startAutoCarousel];
        [self addPageControl];
    }
    
    // 如果图片数量小于二 将pageControl隐藏
    if (imagesArr.count < 2) {
        pageView.hidden = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createCycleView];
//        [self createPageControl];
    }
    return self;
}


//-(void)createPageControl{
//    if (_pageControl) {
//        return;
//    }
//    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleCollectionView.frame) - 30, self.frame.size.width, 30)];
//    _pageControl.userInteractionEnabled = YES;
//    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    [self addSubview:_pageControl];
//}
#pragma mark 创建UIPageControl
-(void)addPageControl{
    CGRect rectValue=CGRectMake(0, self.frame.size.height*0.85, WIDHT, 33);
    UIImage *currentImage=[UIImage imageNamed:@"red"];
    UIImage *pageImage=[UIImage imageNamed:@"white"];
    pageView=[CusPageControlWithView cusPageControlWithView:rectValue pageNum:_imagesArr.count currentPageIndex:0 currentShowImage:currentImage pageIndicatorShowImage:pageImage];
    pageView.indexNumWithSlide = 0;
    [self addSubview:pageView];
}

- (void)createCycleView {
    if (_layout) {
        return;
    }
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing      = 0;
    _layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
    
    _cycleCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_layout];
    _cycleCollectionView.backgroundColor = [UIColor whiteColor];
    

    //停靠模式，宽高都自由
    _cycleCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _cycleCollectionView.delegate = self;
    _cycleCollectionView.dataSource = self;
    _cycleCollectionView.pagingEnabled = YES;
    _cycleCollectionView.showsHorizontalScrollIndicator= NO;
    [self addSubview:_cycleCollectionView];
    
    [_cycleCollectionView registerClass:[ZYCollectionViewCell class] forCellWithReuseIdentifier:ZYCycleID];
}




- (void)roll {
    if (_cycleCollectionView) {
        //取出当前显示的cell
        NSIndexPath * indexPath = [_cycleCollectionView indexPathsForVisibleItems].lastObject;
        if (indexPath) {
            //显示下一张
            [_cycleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0] atScrollPosition:0 animated:YES];
        }
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    _pageControl.currentPage = self.index;
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //TODO:

//    NSLog(@"%f",scrollView.contentOffset.x);
//    pageView.indexNumWithSlide = self.index;
    if (scrollView.contentOffset.x == (_imagesArr.count + 1) * WIDHT) {//最右边
        [scrollView setContentOffset:CGPointMake(WIDHT, 0)];
        pageView.indexNumWithSlide = 0;
    }
    else if (scrollView.contentOffset.x == 0){//最左边
        [scrollView setContentOffset:CGPointMake(_imagesArr.count *WIDHT, 0)];
        pageView.indexNumWithSlide = _imagesArr.count;
    }
    else{
        double pageNum = scrollView.contentOffset.x / self.frame.size.width - 1;
        pageView.indexNumWithSlide = (int)(pageNum + 0.5);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagesArr.count >= 2) {
        return INT16_MAX;
    } else {
        return self.imagesArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYCycleID forIndexPath:indexPath];
    cell.placeHolderImageName  = self.placeHolderImageName;
    self.index = [self indexWithOffset:indexPath.item];
    NSInteger imageIndex       = self.index;
    cell.imagesUrl = self.imagesArr[imageIndex];
   
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(ZYCollectionViewClick:)]) {
        [self.delegate ZYCollectionViewClick:[self indexWithOffset:indexPath.item]];
    }
}

- (NSInteger)indexWithOffset:(NSInteger)offset {
    return offset % self.imagesArr.count;
}


#pragma mark - 将要开始拖拽，停止自动轮播
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoCarousel];
}

#pragma mark - 已经结束拖拽，启动自动轮播
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutoCarousel];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self startAutoCarousel];
//}
- (void)stopAutoCarousel {
    if (_timer == nil) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)startAutoCarousel {
    if (self.imagesArr.count >= 2){
//        if (_timer) {
//            return;
//        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(roll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

@end
