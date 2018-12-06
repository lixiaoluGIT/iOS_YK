//
//  YKRecProductHeaderView.m
//  YK
//
//  Created by edz on 2018/12/5.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKRecProductHeaderView.h"

@implementation YKRecProductHeaderView

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

- (void)initWithImage:(NSString *)imageName content:(NSString *)content{
    //图片
    UIImageView *image = [[UIImageView alloc]init];
    image.frame = CGRectMake(0, 0, WIDHT, kSuitLength_H(200));
    [image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:imageName]] placeholderImage:[UIImage imageNamed:@"top1.jpg"]];
    [image setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:image];
    
    //文字
    UILabel *contentLable = [[UILabel alloc]init];
    contentLable.frame = CGRectMake(kSuitLength_H(12), image.bottom+kSuitLength_H(14), WIDHT-kSuitLength_H(12)*2,kSuitLength_H(62));
    contentLable.text = content;
    contentLable.textColor = mainColor;
    contentLable.font = PingFangSC_Regular(kSuitLength_H(14));
    contentLable.numberOfLines = 0;
    contentLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:contentLable];
    
    //灰色条
    UILabel *line = [[UILabel alloc]init];
    line.frame = CGRectMake(0, contentLable.bottom + kSuitLength_H(10), WIDHT, kSuitLength_H(10));
    line.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [self addSubview:line];
}

@end
