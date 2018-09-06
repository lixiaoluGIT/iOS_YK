//
//  YKSuitCell.m
//  YK
//
//  Created by LXL on 2017/11/14.
//  Copyright © 2017年 YK. All rights reserved.
//
#define Hl 190
#define Hs 160
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

@property(nonatomic,weak) UIView *borderLine;//分割线
@property(nonatomic,weak) UIView *borderView;//删除点选按钮的View
@property(nonatomic,assign) NSInteger moveNum;//偏移量

@end
@implementation YKSuitCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
- (void)setupUI {
    [self.suitImage setContentMode:UIViewContentModeScaleAspectFit];
//    self.suitImage.clipsToBounds = YES;
//    self.suitImage.layer.masksToBounds = YES;
//    self.suitImage.layer.borderColor = [UIColor colorWithHexString:@"f5f5f5"].CGColor;
//    self.suitImage.layer.borderWidth = 1;
    
    [self setupRightSelectView];//右侧删除点选按钮
}

- (void)setupRightSelectView{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@1);
    }];
    self.borderLine = line;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderLine.mas_left);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
        make.width.equalTo(@50);
    }];
    self.borderView = view;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
    }];
    self.collectBtn = btn;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self customMultipleChioce];
    }else{
        [self customMultiple];
    }
}

-(void)customMultipleChioce{
    self.moveNum = -50;
    [self updateMasonry];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
-(void)customMultiple{
    self.moveNum = 0;
    [self updateMasonry];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)updateMasonry{
    //更新价钱UI
        [self.price mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-24+self.moveNum);
            
        }];
    //更新标志UI
    [self.seleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24+self.moveNum);
        make.bottom.equalTo(self).offset(-12);
        make.height.with.equalTo(@20);
    }];
    //更新其它UI
    [self.borderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_right).offset(self.moveNum);
        make.width.equalTo(@1);
    }];

    
}

//点击区域变大
- (IBAction)bigBtn:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if ([YKSuitManager sharedManager].isUseCC) {//4件
        if ([YKSuitManager sharedManager].suitAccount>=4&&btn.selected==NO) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"亲,美衣数量已达上限噢" delay:2];
            return;
        }
    }else {
        if ([YKSuitManager sharedManager].suitAccount>=3&&btn.selected==NO) {
            [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"亲,一次最多选购三件哦" delay:2];
            return;
        }
    }
   
    if ([self.suitStatus isEqualToString:@"0"]) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"该宝贝被抢光了,下次记得早点哦" delay:2];
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

- (void)setSuit:(YKSuit *)suit{
    _suit = suit;
    self.suitImage.autoresizingMask = NO;
    [self.suitImage sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:suit.clothingImgUrl]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    self.suitImage.backgroundColor = [UIColor redColor];
    [self.suitImage setContentMode:UIViewContentModeScaleAspectFill];
    self.suitName.text = suit.clothingName;
    self.suitBrand.text = suit.clothingBrandName;
    self.suitType.text = [NSString stringWithFormat:@"¥%@",suit.clothingPrice];
    self.price.text = suit.clothingStockType;
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

+ (CGFloat)heightForCell:(NSString *)suitStatus{
    if ( [suitStatus isEqualToString:@"1"]) {//有库存
       return Hs;
    }else{
        return Hl;
    }
    return CGFLOAT_MIN;
}

- (void)setSelectBtnStatus:(NSInteger)type{
    self.seleBtn.selected = type;
    self.bigBtn.selected = type;
}

- (void)setDeleteBtnStatus:(NSInteger)type{
    self.collectBtn.selected = type;
    if (self.collectBtn.selected) {
        [self.collectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
}

@end
