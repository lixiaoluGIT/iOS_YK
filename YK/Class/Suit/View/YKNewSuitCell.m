//
//  YKNewSuitCell.m
//  YK
//
//  Created by edz on 2018/10/12.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKNewSuitCell.h"

@interface YKNewSuitCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet UIImageView *suitImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *barnd;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *owendNum;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *tipImage;
@property (weak, nonatomic) IBOutlet UILabel *noSuit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gapB;
@property (weak, nonatomic) IBOutlet UIButton *bugBtn;

@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;

@property (weak, nonatomic) IBOutlet UILabel *Vline;
@property (nonatomic,strong)NSString *suitStatus;
@property (nonatomic,strong)UIButton *pubLicBtn;//晒图按钮
@property (nonatomic,strong)UIButton *leaveBtn;//留下来按钮
//@property (nonatomic,strong)NSString *suitId;
@end
@implementation YKNewSuitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //字体适配
    _name.font = PingFangSC_Regular(kSuitLength_H(14));
    _barnd.font = PingFangSC_Medium(kSuitLength_H(12));
    _price.font = PingFangSC_Medium(kSuitLength_H(12));
    _owendNum.font = PingFangSC_Regular(kSuitLength_H(12));
    _noSuit.font = PingFangSC_Medium(kSuitLength_H(12));
    _type.font = PingFangSC_Medium(kSuitLength_H(12));
    _imageH.constant = kSuitLength_H(93);
    _imageW.constant = kSuitLength_H(76);
    _gapT.constant =
    _gapB.constant = kSuitLength_H(15);
    _suitImage.centerY = self.centerY;
    
    //晒图按钮
    _pubLicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pubLicBtn setImage:[UIImage imageNamed:@"相机"] forState:UIControlStateNormal];
    [_pubLicBtn setTitle:@"晒图" forState:UIControlStateNormal];
    _pubLicBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(10));
    _pubLicBtn.frame = CGRectMake(WIDHT-kSuitLength_H(52)-kSuitLength_H(30)-kSuitLength_H(52), self.price.centerY, kSuitLength_H(52), kSuitLength_H(20));
    _pubLicBtn.layer.masksToBounds = YES;
    _pubLicBtn.layer.cornerRadius = kSuitLength_H(20)/2;
    _pubLicBtn.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    _pubLicBtn.hidden = YES;
    [_pubLicBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [_pubLicBtn addTarget:self action:@selector(public) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pubLicBtn];
    [_pubLicBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -kSuitLength_H(5), 0, 0)];
    [_pubLicBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, kSuitLength_H(5), 0, 0)];
    
    _leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_leaveBtn setTitle:@"买下它" forState:UIControlStateNormal];
    _leaveBtn.titleLabel.font = PingFangSC_Medium(kSuitLength_H(12));
    _leaveBtn.frame = CGRectMake(WIDHT-kSuitLength_H(52)-kSuitLength_H(20), self.price.centerY, kSuitLength_H(52), kSuitLength_H(20));
    _leaveBtn.layer.masksToBounds = YES;
    _leaveBtn.layer.cornerRadius = kSuitLength_H(20)/2;
    _leaveBtn.backgroundColor = YKRedColor;
    _leaveBtn.hidden = YES;
    [_leaveBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [_leaveBtn addTarget:self action:@selector(toBuy) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leaveBtn];
    
    
}

- (void)public{
    NSLog(@"public");
    if (self.publicBlock) {
       
        self.publicBlock(self.suitId);
    }
}

- (void)toBuy{
    if (self.buyBlock) {
        self.buyBlock(@"");
    }
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
    self.price.text = [NSString stringWithFormat:@"¥ %@",suit.clothingPrice];
    
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

//历史衣袋用
- (void)resetUI{
    _bugBtn.hidden = YES;
    _deleteImage.hidden = YES;
    _tipImage.hidden = YES;
    _noSuit.hidden = YES;
    _pubLicBtn.hidden = NO;
    _owendNum.hidden = YES;
    _Vline.hidden = YES;
    _leaveBtn.hidden = NO;
    _type.hidden = YES;
}

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
  
    self.suitImage.autoresizingMask = NO;
    [self.suitImage sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:[NSString stringWithFormat:@"%@",dic[@"clothingImgUrl"]]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    [self.suitImage setContentMode:UIViewContentModeScaleAspectFill];
    self.name.text = [NSString stringWithFormat:@"%@",dic[@"clothingName"]];
    self.barnd.text = [NSString stringWithFormat:@"%@",dic[@"clothingStockType"]];
    self.type.text = [NSString stringWithFormat:@"%@",dic[@"clothingStockType"]];
    self.price.text = [NSString stringWithFormat:@"¥ %@",dic[@"clothingPrice"]];
    
//    //衣位
//    _owendNum.text = [NSString stringWithFormat:@"占%@个衣位",suit.ownedNum];
    
//    self.suitStatus = suit.clothingStockNum;//剩余库存数量
    self.suitId = [NSString stringWithFormat:@"%@",dic[@"clothingId"]];
    
    if ([dic[@"photograph"] intValue] == 2) {//没晒过
        
    }else {
        [self.pubLicBtn setTitle:@"已晒" forState:UIControlStateNormal];
        [self.pubLicBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [self.pubLicBtn setUserInteractionEnabled:NO];
    }
}
@end
