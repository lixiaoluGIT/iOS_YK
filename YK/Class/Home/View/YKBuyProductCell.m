//
//  YKBuyProductCell.m
//  YK
//
//  Created by Macx on 2018/12/26.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKBuyProductCell.h"
@interface YKBuyProductCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
@implementation YKBuyProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _name.font = PingFangSC_Medium(kSuitLength_H(14));
    _type.font = PingFangSC_Regular(kSuitLength_H(12));
    _price.font = PingFangSC_Regular(14);
    _name.textColor = mainColor;
    _type.textColor = [UIColor colorWithHexString:@"999999"];
    _price.textColor = mainColor;
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
- (void)initWithDictionary:(NSDictionary *)product sizeNum:(NSString *)sizeNum{
    [_image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:product[@"clothingImgUrl"]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    _name.text = [NSString stringWithFormat:@"%@",product[@"clothingName"]];
    _type.text = [NSString stringWithFormat:@"尺码：%@",sizeNum];
    _price.text = [NSString stringWithFormat:@"¥ %.f",[product[@"clothingPrice"] floatValue]*0.6];
}

@end
