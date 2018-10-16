//
//  YKNewSuitCell.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKNewSuitCell.h"

@interface YKNewSuitCell()

@property (weak, nonatomic) IBOutlet UIImageView *suitImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *barnd;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *owendNum;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *tipImage;
@property (weak, nonatomic) IBOutlet UILabel *noSuit;


@property (nonatomic,strong)NSString *suitStatus;
//@property (nonatomic,strong)NSString *suitId;
@end
@implementation YKNewSuitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//删除当前衣袋
- (IBAction)deleteFromCart:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(self.suit.shoppingCartId);
    }
}

- (void)setSuit:(YKSuit *)suit{
    _suit = suit;
    self.suitImage.autoresizingMask = NO;
    [self.suitImage sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:suit.clothingImgUrl]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    self.suitImage.backgroundColor = [UIColor redColor];
    [self.suitImage setContentMode:UIViewContentModeScaleAspectFill];
    self.name.text = suit.clothingName;
    self.barnd.text = suit.clothingBrandName;
    self.type.text = suit.clothingStockType;
    self.price.text = [NSString stringWithFormat:@"¥%@",suit.clothingPrice];
    
    //衣位
    _owendNum.text = [NSString stringWithFormat:@"占%@个衣位",suit.ownedNum];
    
    self.suitStatus = suit.clothingStockNum;//剩余库存数量
    self.suitId = suit.clothingId;
    
    if (![self.suitStatus isEqualToString:@"0"]) {//有库存
        self.tipImage.hidden = YES;
        self.noSuit.hidden = YES;
        
    }else {
        self.tipImage.hidden = NO;
        self.noSuit.hidden = NO;
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
