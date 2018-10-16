//
//  YKProductAleartView.m
//  YK
//
//  Created by edz on 2018/10/15.
//  Copyright © 2018年 YK. All rights reserved.
//

#import "YKProductAleartView.h"

@interface YKProductAleartView()


@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *brand;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,strong)YKNewSizeView *sizeView;
@property (nonatomic,strong)NSArray *stockArray;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong)NSString *clothingStockType;
@end
@implementation YKProductAleartView

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

- (void)setIsAddCart:(BOOL)isAddCart{
    _isAddCart = isAddCart;
    if (isAddCart) {
        [self.addBtn setTitle:@"加入衣袋" forState:UIControlStateNormal];
    }else {
        [self.addBtn setTitle:@"加入心愿单" forState:UIControlStateNormal];
    }
}
- (void)setProduct:(NSDictionary *)product{
    WeakSelf(weakSelf)
    _product = product;
    
    _clothingStockType = @"无";
    [_image sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:product[@"clothingImgUrl"]]] placeholderImage:[UIImage imageNamed:@"商品图"]];
    _name.text = [NSString stringWithFormat:@"%@",product[@"clothingName"]];
    _brand.text = [NSString stringWithFormat:@"%@",product[@"brandName"]];
    _price.text = [NSString stringWithFormat:@"%@",product[@"clothingPrice"]];
    
    self.stockArray = [NSArray arrayWithArray:product[@"clothingStockDTOS"]];
    //尺码显示
    self.sizeView = [[YKNewSizeView alloc]init];
    [self.sizeView initViewWithArray:self.stockArray];
    self.sizeView.frame = self.backView.frame;
//    self.sizeView.selectBlock = ^(NSString *clothingStockType) {
//        weakSelf.clothingStockType = clothingStockType;
//    };
    self.sizeView.selectBlock = self.selectBlock;
    
    [self addSubview:self.sizeView];
}

- (IBAction)close:(id)sender {
    if (self.disBLock) {
        self.disBLock();
    }
}

- (IBAction)addClick:(id)sender {
    
    if (self.sizeView.selectindex == 0) {
        [smartHUD alertText:[UIApplication sharedApplication].keyWindow alert:@"请选择尺码" delay:1.4];
        return;
    }
    if (self.isAddCart) {
        if (self.addTOCartBlock) {
            self.addTOCartBlock(@"11");
        }
    }else {
        if (self.favouriteBlock) {
            self.favouriteBlock(@"11");
        }
    }
}

@end

@interface YKNewSizeView()

@property (nonatomic,strong) UIButton *Button1;
@property (nonatomic,strong) NSArray *stockArray;
//@property (nonatomic,assign) NSInteger selectindex;

@property (nonatomic,strong)UILabel *stockStatuslabel;//显示库存状态
@property (nonatomic,strong)NSMutableArray *stockStatusLabelArray;//存储库存状态label数组
@property (nonatomic,strong)NSMutableArray *typeBtnArray;

@property (nonatomic,strong)UILabel *tishilabel;
@property (nonatomic,strong)UIImageView *tishiImage;


@end
@implementation YKNewSizeView

- (void)initViewWithArray:(NSArray *)array{
    
    self.stockArray = [NSArray arrayWithArray:array];
    self.stockStatusLabelArray = [NSMutableArray array];
    self.typeBtnArray = [NSMutableArray array];
    
    //添加待返架提示
    _tishilabel = [[UILabel alloc]init];
    _tishilabel.text = @"待返架";
    _tishilabel.textColor = YKRedColor;
    _tishilabel.font = PingFangSC_Regular(14);
    [self addSubview:_tishilabel];
    
    _tishiImage = [[UIImageView alloc]init];
    _tishiImage.image = [UIImage imageNamed:@"tishi"];
    [self addSubview:_tishiImage];
    
    _tishilabel.hidden = YES;
    _tishiImage.hidden = YES;
    
    [_tishilabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-24));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_tishiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tishilabel.mas_centerY);
        make.right.equalTo(_tishilabel.mas_left).offset(-6);
    }];
    
    for (int i=0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = mainColor.CGColor;
        btn.layer.borderWidth = 1;
        btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        btn.frame = CGRectMake((48+14)*i,17,48, 24);
        [btn setTitle:array[i][@"clothingStockType"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:mainColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i+1;
        [self addSubview:btn];
        
        [self.typeBtnArray addObject:btn];
        
    }
}

- (void)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.selectindex = btn.tag;
    if (self.Button1 == btn) {
        
    }else{
        
        self.Button1.selected = NO;
        
        //判断显示标签
        YKProductType *product = [[YKProductType alloc]init];
        [product initWithDictionary:self.stockArray[self.selectindex-1]];
       
        btn.selected = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.backgroundColor = mainColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            
            self.Button1.titleLabel.font = [UIFont systemFontOfSize:14];
            self.Button1.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            [self.Button1 setTitleColor:mainColor forState:UIControlStateNormal];
            self.Button1.layer.borderWidth = 1;
            
            if (!product.isHadStock) {//当前选择没有库存
                
                btn.backgroundColor = YKRedColor;
                btn.layer.borderWidth = 0;
                _tishilabel.hidden = NO;
                _tishiImage.hidden = NO;
            }else {
                _tishilabel.hidden = YES;
                _tishiImage.hidden = YES;
            }
            
        }];
        
    }
    
    self.Button1 = btn;
    
    
    if (self.selectBlock) {
        self.selectBlock(self.stockArray[self.selectindex-1][@"clothingStockId"]);
    }
}

@end
