//
//  YKSuitCell.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//
#define Hl 170
#define Hs 140
#import "YKSuitCell.h"
@interface YKSuitCell()

//按钮
@property (weak, nonatomic) IBOutlet UIButton *seleBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigBtn;

//内容
@property (weak, nonatomic) IBOutlet UIImageView *suitImage;
@property (weak, nonatomic) IBOutlet UILabel *suitName;
@property (weak, nonatomic) IBOutlet UILabel *suitBrand;
@property (weak, nonatomic) IBOutlet UILabel *suitType;

@property (weak, nonatomic) IBOutlet UILabel *noSuit;
@property (weak, nonatomic) IBOutlet UIImageView *tipImage;
@property (weak, nonatomic) IBOutlet UILabel *price;


@end
@implementation YKSuitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.suitImage setContentMode:UIViewContentModeScaleAspectFit];
    self.suitImage.clipsToBounds = YES;
}

//点击区域变大
- (IBAction)bigBtn:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if ([YKSuitManager sharedManager].suitAccount>=3&&btn.selected==NO) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"一次最多选三件" delay:1.2];
        return;
    }
    if ([self.suitStatus isEqualToString:@"0"]) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"该商品暂缺" delay:1.2];
        return;
    }
    
    btn.selected = !btn.selected;
    self.seleBtn.selected = btn.selected;
    self.selectStatus = self.seleBtn.selected;
    if (btn.selected) {
        [YKSuitManager sharedManager].suitAccount ++;
        [[YKSuitManager sharedManager]selectCurrentPruduct:self.suit];
    }else {
        [YKSuitManager sharedManager].suitAccount --;
        [[YKSuitManager sharedManager]cancelSelectCurrentPruduct:self.suit];
    }
    
    NSLog(@"选中的商品:%@",[YKSuitManager sharedManager].suitArray);
    
    for (YKSuit *suit in [YKSuitManager sharedManager].suitArray ) {
        NSLog(@"%@",suit.clothingName);
    }
    
    if (self.selectClickBlock) {
        
        if ([YKSuitManager sharedManager].suitAccount>0) {
            self.selectClickBlock(1);
        }else {
            self.selectClickBlock(0);
        }
        
    }
}

//此方法无用
- (IBAction)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if ([YKSuitManager sharedManager].suitAccount>=3&&btn.selected==NO) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"一次最多选三件" delay:1.2];
        return;
    }
    if ([self.suitStatus isEqualToString:@"0"]) {
         [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"该商品暂缺" delay:1.2];
        return;
    }
    
    self.seleBtn.selected = !self.seleBtn.selected;
    self.selectStatus = self.seleBtn.selected;
    if (btn.selected) {
        [YKSuitManager sharedManager].suitAccount ++;
        [[YKSuitManager sharedManager]selectCurrentPruduct:self.suit];
    }else {
        [YKSuitManager sharedManager].suitAccount --;
        [[YKSuitManager sharedManager]cancelSelectCurrentPruduct:self.suit];
    }
    
    NSLog(@"选中的商品:%@",[YKSuitManager sharedManager].suitArray);
    
    for (YKSuit *suit in [YKSuitManager sharedManager].suitArray ) {
        NSLog(@"%@",suit.clothingName);
    }
    
    if (self.selectClickBlock) {

        if ([YKSuitManager sharedManager].suitAccount>0) {
            self.selectClickBlock(1);
        }else {
            self.selectClickBlock(0);
        }
        
    }
    
}

- (void)setSuit:(YKSuit *)suit{
    _suit = suit;
    self.suitImage.autoresizingMask = NO;
    [self.suitImage sd_setImageWithURL:[NSURL URLWithString:suit.clothingImgUrl] placeholderImage:[UIImage imageNamed:@"商品图"]];
    self.suitName.text = suit.clothingName;
    self.suitBrand.text = suit.clothingBrandName;
    self.suitType.text = suit.clothingStockType;
    self.price.text = [NSString stringWithFormat:@"¥%@",suit.clothingPrice];
    self.suitStatus = suit.clothingStockNum;//剩余库存数量
    self.suitId = suit.clothingId;
    
    if (![self.suitStatus isEqualToString:@"0"]) {//有库存
        self.tipImage.hidden = YES;
        self.noSuit.hidden = YES;
        _cellH = 160;
       
    }else {
        self.tipImage.hidden = NO;
        self.noSuit.hidden = NO;
        _cellH = 180;
    }
}

//- (void)setContentWithSuit:(YKSuit *)suit{
//
//    [self.myImae sd_setImageWithURL:[NSURL URLWithString:suit.clothingImgUrl] placeholderImage:[UIImage imageNamed:@"商品图"]];
//    self.myDes.text = [NSString stringWithFormat:@"%@",suit.clothingName];
//    self.myBrand.text = suit.clothingBrandName;
//    self.mySize.text = suit.clothingStockType;
//    self.myPrice.text = [NSString stringWithFormat:@"¥%@",suit.clothingPrice];
//
//    self.suitId = suit.clothingId;
//}

+ (CGFloat)heightForCell:(NSString *)suitStatus{
    if ( [suitStatus isEqualToString:@"1"]) {//有库存
       return Hs;
    }else{
        return Hl;
    }
    return CGFLOAT_MIN;
}

- (void)setSelectBtnStatus:(NSInteger)sype{
    self.seleBtn.selected = sype;
    self.bigBtn.selected = sype;
}

@end
