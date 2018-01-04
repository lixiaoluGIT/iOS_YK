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
@end
@implementation YKSuitEnsureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.ima setContentMode:UIViewContentModeScaleAspectFit];
    self.ima.clipsToBounds = YES;
    self.ima.layer.masksToBounds = YES;
    self.ima.layer.borderColor = [UIColor colorWithHexString:@"f5f5f5"].CGColor;
    self.ima.layer.borderWidth = 1;
}

- (void)setSuit:(YKSuit *)suit{
    _suit = suit;
    
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:suit.clothingImgUrl] placeholderImage:[UIImage imageNamed:@"商品图"]];
    self.myDes.text = [NSString stringWithFormat:@"%@",suit.clothingName];
    self.myBrand.text = suit.clothingBrandName;
    self.mySize.text = suit.clothingStockType;
    self.myPrice.text = [NSString stringWithFormat:@"¥%@",suit.clothingPrice];
}

@end
