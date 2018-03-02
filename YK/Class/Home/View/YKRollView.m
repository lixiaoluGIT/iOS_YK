//
//  YKRollView.m
//  YK
//
//  Created by LXL on 2018/1/30.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKRollView.h"

@interface YKRollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *rollDataArr;   // 图片数据

@property (nonatomic, assign) float halfGap;   // 图片间距的一半

@end

@implementation YKRollView

- (instancetype)initWithFrame:(CGRect)frame withDistanceForScroll:(float)distance withGap:(float)gap
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.halfGap = gap/2;
        
        /** 设置 UIScrollView */
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(distance, 0, self.frame.size.width - 2 * distance, self.frame.size.height)];
        [self addSubview:self.scrollView];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        self.scrollView.clipsToBounds = NO;
//        self.scrollView.backgroundColor = [UIColor redColor];
        
        /** 添加手势 */
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self.scrollView addGestureRecognizer:tap];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        /** 数据初始化 */
        self.rollDataArr = [NSArray array];
        
    }
    
    
    return self;
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
#pragma mark - 视图数据
-(void)rollView:(NSArray *)dataArr{
    
    self.rollDataArr = dataArr;
    
//    NSString *s = [NSString stringWithFormat:@"%@",dataArr[i][@"brandLargeLogo"]];
//    [btn.image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:s]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
    
    //循环创建添加轮播图片, 前后各添加一张
    NSInteger count;
    if (dataArr.count==1) {
        count=0;
    }else {
        count=2;
    }
    for (int i = 0; i < self.rollDataArr.count + count; i++) {
        
        for (UIView *underView in self.scrollView.subviews) {
            
            if (underView.tag == 400 + i) {
                [underView removeFromSuperview];
            }
        }
        
        UIImageView *picImageView = [[UIImageView alloc] init];
        picImageView.userInteractionEnabled = YES;
        picImageView.tag = 400 + i ;
        
        /**  说明
         *   1. 设置完 ScrollView的width, 那么分页的宽也为 width.
         *   2. 图片宽为a 间距为 gap, 那么 图片应该在ScrollView上居中, 距离ScrollView左右间距为halfGap.
         *   与 ScrollView的width关系为 width = halfGap + a + halfGap.
         *   3. distance : Scroll距离 底层视图View两侧距离.
         *   假设 要露出上下页内容大小为 m ,   distance = m + halfGap
         *
         *  图片位置对应关系 :
         *  0 ->  1 * halfGap ;
         *  1 ->  3 * halfGap + a ;
         *  2 ->  5 * halfGap + 2 * a ;
         .
         .
         *  i   -> (2 * i +1) *  halfGap + i *(width - 2 * halfGap )
         */
        
        if (self.rollDataArr.count == 1) {
            picImageView.frame = CGRectMake(12, 0, (self.scrollView.frame.size.width - 24), self.frame.size.height);
        }else {
        picImageView.frame = CGRectMake((2 * i + 1) * self.halfGap + i * (self.scrollView.frame.size.width - 2 * self.halfGap), 0, (self.scrollView.frame.size.width - 2 * self.halfGap), self.frame.size.height);
            
//            picImageView.backgroundColor = [UIColor redColor];
        }
        //设置图片
        if (i == 0) {
            
//            picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.rollDataArr[self.rollDataArr.count - 1]]];
            
            NSString *s = [NSString stringWithFormat:@"%@",self.rollDataArr[self.rollDataArr.count - 1][@"brandLargeLogo"]];
            [picImageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:s]] placeholderImage:[UIImage imageNamed:@"activity"]];
            
        }else if (i == self.rollDataArr.count+1) {
            
//            picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.rollDataArr[0]]];
            
            NSString *s = [NSString stringWithFormat:@"%@",self.rollDataArr[0][@"brandLargeLogo"]];
            [picImageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:s]] placeholderImage:[UIImage imageNamed:@"activity"]];
        }else {
            
//            picImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.rollDataArr[i - 1]]];
            NSString *s = [NSString stringWithFormat:@"%@",self.rollDataArr[i - 1][@"brandLargeLogo"]];
            [picImageView sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:s]] placeholderImage:[UIImage imageNamed:@"activity"]];
        }
        
        [self.scrollView addSubview:picImageView];
//        [picImageView setContentMode:UIViewContentModeScaleAspectFit];
        picImageView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    //设置轮播图当前的显示区域
    if (dataArr.count==1) {
       self.scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.userInteractionEnabled = NO;
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (self.rollDataArr.count + 2), 0);
    }else {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * (self.rollDataArr.count + 2), 0);
    }

    
}

#pragma mark - UIScrollViewDelegate 方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger curIndex = scrollView.contentOffset.x  / self.scrollView.frame.size.width;
    
    if (curIndex == self.rollDataArr.count + 1) {
        
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }else if (curIndex == 0){
        
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.rollDataArr.count, 0);
    }
    
}

#pragma mark - 轻拍手势的方法
-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    if ([self.rollDataArr isKindOfClass:[NSArray class]] && (self.rollDataArr.count > 0)) {
        
        [_delegate didSelectPicWithIndexPath:(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)];
    }else{
        
        [_delegate didSelectPicWithIndexPath:-1];
    }
    
}

@end
