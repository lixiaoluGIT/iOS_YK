//
//  YKBrandDetailHeader.m
//  YK
//
//  Created by LXL on 2017/11/23.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKBrandDetailHeader.h"

@interface YKBrandDetailHeader()
@property (weak, nonatomic) IBOutlet UILabel *detailText;
@property (weak, nonatomic) IBOutlet UIImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UILabel *brandName;

@end
@implementation YKBrandDetailHeader

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
- (void)setBrand:(YKBrand *)brand{
    if (!brand) {
        return;
    }
    _brand = brand;
   
    
    //品牌logo
    [_brandLogo sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:brand.brandLogo]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
    //品牌名
    _brandName.text = brand.brandName;
    //品牌介绍
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:15];
    self.labelText = brand.brandDesc;
//    self.labelText = @"首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图首页品牌图";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.labelText ];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.labelText  length])];
    // 设置Label要显示的text
    [self.detailText  setAttributedText:setString];
    self.Lheight = [self lableHeight];
}

- (CGFloat)lableHeight{
    if (WIDHT==375) {
        return 125 + [self heightForString:self.labelText  andWidth:WIDHT/2];
    }else {
        return 110 + [self heightForString:self.labelText  andWidth:WIDHT/2];
    }
}
- (CGFloat) heightForString:(NSString *)value andWidth:(CGFloat)width{
    
    if (value.length == 0) {
        return 0;
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 40.0, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return sizeToFit.height + 16.0;
}


@end
