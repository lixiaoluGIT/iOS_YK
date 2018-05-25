


//
//  ZYCollectionViewCell.m
//  赵杨图片轮播
//
//  Created by 轶辉 on 16/10/11.
//  Copyright © 2016年 YiHui. All rights reserved.
//

#import "ZYCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ZYCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _imageView.contentMode   = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
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

- (void)setImagesUrl:(NSString *)imagesUrl {
    _imagesUrl = [self URLEncodedString:imagesUrl];
//    _imagesUrl = imagesUrl;

    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imagesUrl] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
}

- (void)setPlaceHolderImageName:(NSString *)placeHolderImageName {
    _placeHolderImageName = placeHolderImageName;
}


@end
