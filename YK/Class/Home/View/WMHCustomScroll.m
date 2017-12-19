//
//  WMHCustomScroll.m
//  WMHScrollView
//
//  Created by Archer on 2017/3/21.
//  Copyright © 2017年 jiuji. All rights reserved.
//

#define selfView self.frame.size
#import "WMHCustomScroll.h"

//#import "UIImageView+WebCache.h"

@implementation WMHCustomScroll

+(instancetype)scrollViewWithImageArray:(NSArray *)imageArr pageCtrIsHiden:(BOOL)isHiden ImgType:(NSString *)typeStr{
    WMHCustomScroll *wmhScroll = [[WMHCustomScroll alloc]initWithFrame:CGRectMake(0, 0, WIDHT, WIDHT*0.55)];
    wmhScroll.imgArr = imageArr;
    wmhScroll.isHidePage = isHiden;
    wmhScroll.imgType = typeStr;
    [wmhScroll createViewOnScrollView];
    return wmhScroll;
}

-(void)createViewOnScrollView{
    _WMHScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, selfView.width, selfView.width / 2)];
    _WMHScroll.backgroundColor = [UIColor whiteColor];
    _WMHScroll.showsVerticalScrollIndicator = NO;
    _WMHScroll.showsHorizontalScrollIndicator = NO;
    _WMHScroll.pagingEnabled = YES;
    _WMHScroll.delegate = self;
    _WMHScroll.contentSize = CGSizeMake((_imgArr.count + 2) * selfView.width, 0);
    _WMHScroll.contentOffset = CGPointMake(selfView.width, 0);
    [self addSubview:_WMHScroll];
    
    if (self.isHidePage == NO) {
        _WMHPageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(0, selfView.height - 40, selfView.width, 40)];
        _WMHPageCtr.backgroundColor = [UIColor clearColor];
        _WMHPageCtr.currentPage = 0;
        _WMHPageCtr.numberOfPages = _imgArr.count;
        [self addSubview:_WMHPageCtr];
    }
    
    //添加一个删除定时器的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopTimer) name:@"stopTimer" object:nil];
    
    [self addImageToScroll];
    [self startTimer];
}

-(void)addImageToScroll{
    UIImageView *imageView;
    
    for (NSInteger i = 0; i < _imgArr.count + 2; i++) {
        if (i == 0) {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfView.width, selfView.height)];
            if ([_imgType isEqualToString:@"0"]) {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgArr[_imgArr.count - 1]]];
            }else{
//                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgArr[_imgArr.count - 1]]]];
            }
        }
        else if (i == _imgArr.count + 1){
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_imgArr.count + 1) * selfView.width, 0, selfView.width, selfView.height)];
            if ([_imgType isEqualToString:@"0"]) {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgArr[0]]];
            }else{
//                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgArr[0]]]];
            }
        }else{
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * selfView.width, 0, selfView.width, selfView.height)];
            if ([_imgType isEqualToString:@"0"]) {
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imgArr[i - 1]]];
            }else{
//                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgArr[i - 1]]]];
            }
        }
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)]];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [_WMHScroll addSubview:imageView];
    }
}

#pragma mark - imageDelegate
-(void)imageClicked:(UIImageView *)imageView{
    if ([self.delegate respondsToSelector:@selector(scrollViewImageClick:)]) {
        [_delegate scrollViewImageClick:self];
    }
}

#pragma mark - scrollDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == (_imgArr.count + 1) * selfView.width) {
        [scrollView setContentOffset:CGPointMake(selfView.width, 0)];
        _WMHPageCtr.currentPage = 0;
    }
    else if (scrollView.contentOffset.x == 0){
        [scrollView setContentOffset:CGPointMake(_imgArr.count * selfView.width, 0)];
        _WMHPageCtr.currentPage = _imgArr.count;
    }
    else{
       double pageNum = scrollView.contentOffset.x / selfView.width - 1;
        _WMHPageCtr.currentPage = (int)(pageNum + 0.5);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

#pragma mark - 定时器事件
-(void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

-(void)next{
    [_WMHScroll setContentOffset:CGPointMake(_WMHScroll.contentOffset.x + selfView.width, 0)animated:YES];
}

@end
