//
//  YKFashionRecView.m
//  YK
//
//  Created by edz on 2018/11/7.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKFashionRecView.h"

@implementation YKFashionRecView

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    
    CGFloat w = WIDHT-20;
    CGFloat h = kSuitLength_H(355);
    NSMutableArray *a = [NSMutableArray array];
    if (imageArray.count!=0) {
        [a addObject:imageArray[0]];
    }
    if (a.count==0) {
        return;
    }
    for (int i=0; i<1; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:imageArray[0]];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, (h+10)*i, w, h)];
        [image setUserInteractionEnabled:YES];
        [image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:dic[@"img1"]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
        [self addSubview:image];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            
            //            if ([Token length] == 0) {
            if (self.toDetailBlock) {
                self.toDetailBlock(_imageArray[0]);
                //                }
            }
            
        }];
        [image addGestureRecognizer:tap];
        
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

@end
