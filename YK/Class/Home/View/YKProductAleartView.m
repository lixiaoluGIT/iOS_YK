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

- (void)setType:(NSInteger)type{
    _type = type;
    if (type==2) {
        [self.addBtn setTitle:@"买这件" forState:UIControlStateNormal];
    }
        
    if (type==1) {
        [self.addBtn setTitle:@"加入心愿单" forState:UIControlStateNormal];
    }
    
    if (type==3) {
        [self.addBtn setTitle:@"租这件" forState:UIControlStateNormal];
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
    self.sizeView.selectTypeBlock = ^(BOOL hadStock) {
        if (hadStock) {
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.addBtn setTitle:@"买这件" forState:UIControlStateNormal];
            }];
        }else {
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.addBtn setTitle:@"预约购买" forState:UIControlStateNormal];
            }];
        }
    };
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
    if (self.type==1) {
        if (self.favouriteBlock) {
            self.favouriteBlock(@"11");
        }
    }
        
    if (self.type==3) {
        if (self.addTOCartBlock) {
            self.addTOCartBlock(@"11");
        }
    }
    
    if (self.type==2) {
        if (self.buyBlock) {
            self.buyBlock(@"11");
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
    _tishilabel.font = PingFangSC_Regular(kSuitLength_H(12));
    [self addSubview:_tishilabel];
    
    _tishiImage = [[UIImageView alloc]init];
    _tishiImage.image = [UIImage imageNamed:@"tishi"];
    [self addSubview:_tishiImage];
    
    _tishilabel.hidden = YES;
    _tishiImage.hidden = YES;
    
    [_tishilabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-24));
        make.centerY.equalTo(self.mas_centerY).offset(-kSuitLength_H(8));
    }];
    [_tishiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tishilabel.mas_centerY);
        make.right.equalTo(_tishilabel.mas_left).offset(-6);
    }];
    
    for (int i=0; i<array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn.layer.masksToBounds = YES;
        //        btn.layer.borderColor = YKRedColor.CGColor;
        //        btn.layer.borderWidth = 1;
        btn.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        btn.frame = CGRectMake((kSuitLength_H(58)+kSuitLength_H(17))*i,kSuitLength_H(15),kSuitLength_H(58), kSuitLength_H(26));
        [btn setTitle:array[i][@"clothingStockType"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:kSuitLength_H(12)];
        [btn setTitleColor:[UIColor colorWithHexString:@"676869"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = kSuitLength_H(26)/2;
        btn.tag = i+1;
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
        [product initWithDictionary:self.stockArray[self.selectindex-1]];
        //        self.stockStatuslabel = self.stockStatusLabelArray[self.selectindex];
        //        self.stockStatuslabel.hidden = product.isHadStock;
        
        //        for (UILabel *otherlabel in self.stockStatusLabelArray) {
        //            if (otherlabel!=self.stockStatuslabel) {
        //                otherlabel.hidden = YES;
        //            }
        //        }
        
        btn.selected = YES;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            btn.titleLabel.font = [UIFont systemFontOfSize:kSuitLength_H(12)];
            btn.backgroundColor = YKRedColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //             btn.layer.borderWidth = 1;
            
            self.Button1.titleLabel.font = [UIFont systemFontOfSize:kSuitLength_H(12)];
            self.Button1.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
            [self.Button1 setTitleColor:[UIColor colorWithHexString:@"676869"] forState:UIControlStateNormal];
            //            self.Button1.layer.borderWidth = 1;
            
            if (!product.isHadStock) {//当前选择没有库存
                //                btn.frame = CGRectMake((44+20)*self.selectindex,4,48, 24);
               
//                [UIView animateWithDuration:0.5 animations:^{
                    btn.backgroundColor = YKRedColor;
                    btn.layer.borderWidth = 0;
                    _tishilabel.hidden = NO;
                    _tishiImage.hidden = NO;
                    
//                }];
            }else {
                _tishilabel.hidden = YES;
                _tishiImage.hidden = YES;
            }
            
            if (self.selectTypeBlock) {
                self.selectTypeBlock(_tishiImage.hidden);
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
        self.selectBlock(self.stockArray[self.selectindex-1][@"clothingStockId"],self.stockArray[self.selectindex-1][@"clothingStockType"]);
    }
}

@end
