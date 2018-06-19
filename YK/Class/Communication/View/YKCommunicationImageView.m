//
//  YKCommunicationImageView.m
//  YK
//
//  Created by edz on 2018/6/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKCommunicationImageView.h"
#import "UIImageView+WebCache.h"
#import "YYPhotoGroupView.h"


@interface YKCommunicationImageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end
@implementation YKCommunicationImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self setup];
    }
    return self;
}

//- (UIScrollView *)scrollView{
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, 286)];
//        _scrollView.delegate = self;
//        _scrollView.scrollEnabled = YES;
//        [self addSubview:_scrollView];
//    }
//    return _scrollView;
//}
- (void)setup
{
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WIDHT, 286);
//    NSMutableArray *temp = [NSMutableArray new];
    
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDHT, 286)];
//    [self addSubview:self.scrollView];
//    self.scrollView.scrollEnabled = YES;
//    self.scrollView.backgroundColor = [UIColor clearColor];
    
//    for (int i = 0; i < 9; i++) {
//        UIImageView *imageView = [UIImageView new];
//        imageView.userInteractionEnabled = YES;
//        imageView.tag = i;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.clipsToBounds = YES;
//        imageView.backgroundColor = [UIColor grayColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
//        [imageView addGestureRecognizer:tap];
//        [temp addObject:imageView];
//        [self addSubview:imageView];
//    }
    
//    self.imageViewsArray = [temp copy];
}

- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
//    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
//        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
////        imageView.hidden = YES;
//    }
//
//    if (_picPathStringsArray.count == 0) {
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
//        return;
//    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < picPathStringsArray.count; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor grayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
        [self addSubview:imageView];
    }
    self.imageViewsArray = [temp copy];
    
    CGFloat itemW;
    CGFloat margin;
    if (_picPathStringsArray.count == 1) {
        itemW = WIDHT-48;
        margin = 100;
        self.scrollEnabled = NO;
    }else {
        itemW = 220;
        margin = 14;
        self.scrollEnabled = YES;
    }
    CGFloat itemH = 286*WIDHT/414;
  
//    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
//    CGFloat margin = 14;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        
        NSURL * url = [NSURL URLWithString:[self URLEncodedString:_picPathStringsArray[idx]]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"商品图"] options:SDWebImageRetryFailed];
        imageView.frame = CGRectMake(24+(itemW + margin)*idx,0,itemW, itemH);
        imageView.backgroundColor = [UIColor redColor];
        [self addSubview:imageView];
    }];

//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WIDHT-48, itemH);
//    self.backgroundColor = [UIColor greenColor];
    self.contentSize = CGSizeMake(_picPathStringsArray.count*(itemW+margin)+24, itemH);
    self.contentOffset = CGPointMake(0, 0);
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
#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *fromView = nil;
    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < _picPathStringsArray.count; i++) {
        UIView * imgView = _imageViewsArray[i];
        YYPhotoGroupItem * item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:_picPathStringsArray[i]];
        [items addObject:item];
        if (i == tap.view.tag) {
            fromView = imgView;
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    v.superView = self.superView;
    [v presentFromImageView:fromView toContainer:self.window animated:YES completion:nil];
}

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray{
    return CGSizeMake(WIDHT, 286*WIDHT/414);
}

@end
