//
//  YKProductDetailHeader.m
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import "YKProductDetailHeader.h"
#import "YKProductType.h"

@interface YKProductDetailHeader()

@property (weak, nonatomic) IBOutlet UILabel *productDes;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (weak, nonatomic) IBOutlet UILabel *brandName;

@property (nonatomic,strong)YKSizeView *sizeView;
@property (nonatomic,strong)NSArray *stockArray;//库存数组
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *toBrandDetailView;
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *tishiImage;

@property (weak, nonatomic) IBOutlet UILabel *recommentWords;

@end

@implementation YKProductDetailHeader
- (void)awakeFromNib{
    [super awakeFromNib];
    [_brandName setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    [_brandName addGestureRecognizer:tap];
    
    //
     NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:4];
    self.recommentWords.text = @"这件衣服很好，黄金时代剋建行卡接受的；卡还是打卡好看的哈剋就是打卡机浑善达克借记卡很多事";
    
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.recommentWords.text ];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.recommentWords.text  length])];
    // 设置Label要显示的text
    [self.recommentWords  setAttributedText:setString];
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

- (void)setRecomment:(NSString *)recomment{
    
    _recomment = [recomment isEqual:[NSNull null]] ? @"暂无买手推荐语～" : recomment;
    _recommentWords.text = _recomment;
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle  setLineSpacing:4];
    self.recommentWords.text = _recomment;
    
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.recommentWords.text ];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.recommentWords.text  length])];
    // 设置Label要显示的text
    [self.recommentWords  setAttributedText:setString];
    
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

@property (nonatomic,strong)UILabel *stockStatuslabel;//显示库存状态
@property (nonatomic,strong)NSMutableArray *stockStatusLabelArray;//存储库存状态label数组
@property (nonatomic,strong)NSMutableArray *typeBtnArray;

@property (nonatomic,strong)UILabel *tishilabel;
@property (nonatomic,strong)UIImageView *tishiImage;


@end
@implementation YKSizeView

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
        btn.tag = i;
        [self addSubview:btn];
        
//        UILabel *label = [[UILabel alloc]init];
//        label.text = @"待返架";
//        label.font = [UIFont systemFontOfSize:12];
//        label.textColor = [UIColor colorWithHexString:@"ee2d2d"];
//        [self addSubview:label];
//        label.hidden = YES;
        
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(btn.mas_centerX);
//            make.top.equalTo(btn.mas_bottom).offset(6);
//        }];
        
        [self.typeBtnArray addObject:btn];
//        [self.stockStatusLabelArray addObject:label];
        
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
        [product initWithDictionary:self.stockArray[self.selectindex]];
//        self.stockStatuslabel = self.stockStatusLabelArray[self.selectindex];
//        self.stockStatuslabel.hidden = product.isHadStock;
       
//        for (UILabel *otherlabel in self.stockStatusLabelArray) {
//            if (otherlabel!=self.stockStatuslabel) {
//                otherlabel.hidden = YES;
//            }
//        }
       
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
//                btn.frame = CGRectMake((44+20)*self.selectindex,4,48, 24);
                btn.backgroundColor = YKRedColor;
                btn.layer.borderWidth = 0;
                _tishilabel.hidden = NO;
                _tishiImage.hidden = NO;
            }else {
                _tishilabel.hidden = YES;
                _tishiImage.hidden = YES;
            }
            
//            for (int i=0; i<self.typeBtnArray.count; i++) {//找到上一个选中的下标
//                UIButton *b = self.typeBtnArray[i];
//                if (self.Button1 == b) {
//                    btn.backgroundColor = mainColor;
////                    self.Button1.frame = CGRectMake(20+(44+20)*i,12,44, 26);
//                }
//            }
        }];
        
    }
    
    self.Button1 = btn;
    
    if (self.selectBlock) {
        self.selectBlock(self.stockArray[self.selectindex][@"clothingStockId"]);
    }
}
@end
