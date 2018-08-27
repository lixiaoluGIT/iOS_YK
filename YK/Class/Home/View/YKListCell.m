//
//  YKListCell.m
//  YK
//
//  Created by edz on 2018/8/23.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKListCell.h"

@interface YKListCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
@implementation YKListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    [_image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:dic[@"hotWearImg"]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    _clickUrl = dic[@"hotWearUrl"];
}
@end
