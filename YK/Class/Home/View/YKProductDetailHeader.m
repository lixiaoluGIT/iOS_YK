//
//  YKProductDetailHeader.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKProductDetailHeader.h"

@interface YKProductDetailHeader()

@property (weak, nonatomic) IBOutlet UILabel *productDes;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (weak, nonatomic) IBOutlet UILabel *brandName;

@property (nonatomic,strong)YKSizeView *sizeView;
@property (nonatomic,strong)NSArray *stockArray;//库存数组
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *toBrandDetailView;

@end

@implementation YKProductDetailHeader
- (void)awakeFromNib{
    [super awakeFromNib];
    [_toBrandDetailView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    [_toBrandDetailView addGestureRecognizer:tap];
}

- (void)toDetail{
    if (self.toDetailBlock ) {
        self.toDetailBlock([_brand[@"brandId"] integerValue],_brand[@"brandName"]);
    }
}

- (void)setProduct:(NSDictionary *)product{
    _product = product;
    [_brandImage setContentMode:UIViewContentModeScaleAspectFit];
    NSString *des =  [product objectForKey:@"clothingName"];
    _productDes.text = des;
    _productPrice.text = [NSString stringWithFormat:@"参考价:¥%@",product[@"clothingPrice"]];
    
    _brandName.text = [NSString stringWithFormat:@"%@",product[@"brandName"]];
    
    self.stockArray = [NSArray arrayWithArray:product[@"clothingStockDTOS"]];
    //尺码显示
    self.sizeView = [[YKSizeView alloc]init];
    [self.sizeView initViewWithArray:self.stockArray];
    self.sizeView.frame = self.scrollView.frame;
    self.sizeView.selectBlock = self.selectBlock;
    [self addSubview:self.sizeView];
    
}

- (void)setBrand:(NSDictionary *)brand{
    _brand = brand;
     [_brandImage sd_setImageWithURL:[NSURL URLWithString:[self URLEncodedString:brand[@"brandDetailLogo"]]] placeholderImage:[UIImage imageNamed:@"首页品牌图"]];
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


@interface YKSizeView()

@property (nonatomic,strong) UIButton *Button1;
@property (nonatomic,strong) NSArray *stockArray;
@property (nonatomic,assign) NSInteger selectindex;

@end
@implementation YKSizeView

- (void)initViewWithArray:(NSArray *)array{
    self.stockArray = [NSArray arrayWithArray:array];
    for (int i=0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 13;
        btn.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        btn.frame = CGRectMake(20+(44+20)*i,13,44, 26);
        [btn setTitle:array[i][@"clothingStockType"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn setTitleColor:[UIColor colorWithHexString:@"676869"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i;
        [self addSubview:btn];
    }
}

- (void)btnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.selectindex = btn.tag;
    if (self.Button1 == btn) {
        
    }else{
        self.Button1.selected = NO;
        btn.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            btn.backgroundColor = [UIColor colorWithHexString:@"ff6d6a"];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.Button1.titleLabel.font = [UIFont systemFontOfSize:12];
            self.Button1.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
            [self.Button1 setTitleColor:[UIColor colorWithHexString:@"676869"] forState:UIControlStateNormal];
        }];
        
    }
    
    self.Button1 = btn;
    
    if (self.selectBlock) {
        self.selectBlock(self.stockArray[self.selectindex][@"clothingStockId"]);
    }
}
@end
