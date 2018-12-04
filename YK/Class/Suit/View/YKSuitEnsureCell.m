//
//  YKSuitEnsureCell.m
//  YK
//
//  Created by LXL on 2017/12/7.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKSuitEnsureCell.h"

@interface YKSuitEnsureCell()

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myDes;
@property (weak, nonatomic) IBOutlet UILabel *myBrand;
@property (weak, nonatomic) IBOutlet UILabel *mySize;
@property (weak, nonatomic) IBOutlet UILabel *myPrice;
@property (weak, nonatomic) IBOutlet UIImageView *ima;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imaegW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;

@end
@implementation YKSuitEnsureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.ima setContentMode:UIViewContentModeScaleAspectFit];
//    self.ima.clipsToBounds = YES;
//    self.ima.layer.masksToBounds = YES;
//    self.ima.layer.borderColor = [UIColor colorWithHexString:@"f5f5f5"].CGColor;
//    self.ima.layer.borderWidth = 1;
    
    //字体适配
    _myDes.font = PingFangSC_Regular(kSuitLength_H(14));
    _myBrand.font = PingFangSC_Medium(kSuitLength_H(12));
    _mySize.font =  PingFangSC_Medium(kSuitLength_H(12));
    _myPrice.font = PingFangSC_Medium(kSuitLength_H(12));
    
    _imageH.constant = kSuitLength_H(93);
    _imaegW.constant = kSuitLength_H(76);
  
}

- (void)setSuit:(YKSuit *)suit{
    _suit = suit;
    
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:suit.clothingImgUrl]] placeholderImage:[UIImage imageNamed:@"商品图"]];
//    self.myImage.backgroundColor = [UIColor redColor];
//    [self.myImage setContentMode:UIViewContentModeScaleAspectFill];
    self.myDes.text = [NSString stringWithFormat:@"%@",suit.clothingName];
    self.myBrand.text = suit.clothingBrandName;
    self.mySize.text = [NSString stringWithFormat:@"¥%@",suit.clothingPrice];
    self.myPrice.text = suit.clothingStockType;
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
