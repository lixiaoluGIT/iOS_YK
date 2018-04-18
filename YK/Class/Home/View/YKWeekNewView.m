//
//  YKWeekNewView.m
//  YK
//
//  Created by EDZ on 2018/4/17.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKWeekNewView.h"

@interface YKWeekNewView()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
@implementation YKWeekNewView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    [self addGestureRecognizer:tap];
    // Initialization code
}

- (void)toDetail{
    if (self.toDetailBlock) {
        self.toDetailBlock();
    }
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

- (void)initWithDic:(NSDictionary *)dic{
//    [_image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:dic[@"productImg"]]] placeholderImage:[UIImage imageNamed:@"首页商品图"]];
//    [_image setContentMode:UIViewContentModeScaleAspectFill];
}


@end
