//
//  CGQCollectionViewCell.m
//  collectionview
//
//  Created by 迟国强 on 2016/12/28.
//  Copyright © 2016年 迟国强. All rights reserved.
//

#import "CGQCollectionViewCell.h"

@interface CGQCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *shangxinImage;

@property (weak, nonatomic) IBOutlet UIImageView *qiangkongImage;
@property (weak, nonatomic) IBOutlet UIButton *freeBtn;
@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UILabel *zhanyiweiNum;//占衣位数量

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *addSuitBtn;

@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

@property (nonatomic,strong)NSString *collectionId;

@end

@implementation CGQCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _imageView.contentMode   = UIViewContentModeScaleAspectFit;
//    _imageView.clipsToBounds = YES;
//    _tagimage.clipsToBounds = YES;
//    _imageView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//    _backView.hidden= _tagimage.hidden = YES;
    
//    qiangkongImgae = [UIImageView alloc]in
    _qiangkongImage.hidden = _shangxinImage.hidden = YES;
//    self.backgroundColor = [UIColor redColor];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
//    [self addGestureRecognizer:tap];
    
    _freeBtn.layer.masksToBounds = YES;
    _freeBtn.layer.cornerRadius = 4;
    
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = _backView.frame.size.height/2;
    
    //字体适配
    _lable.font = PingFangSC_Regular(kSuitLength_H(13));
    _detailLabel.font = PingFangTC_Light(kSuitLength_H(11));
    _des.font = PingFangSC_Medium(kSuitLength_H(11));
    _freeBtn.titleLabel.font = PingFangSC_Regular(10);
    _zhanyiweiNum.font = PingFangTC_Light(kSuitLength_H(7));
    
    [_addSuitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
    [_addSuitBtn addTarget:self action:@selector(addBlock) forControlEvents:UIControlEventTouchUpInside];
//    _addSuitBtn.backgroundColor = [UIColor redColor];
    
    _loveBtn.hidden = YES;
}

//加入衣袋
- (void)addBlock{
    
    [[YKSuitManager sharedManager]addToShoppingCartwithclothingId:_goodsId clothingStckType:_clothingStockId OnResponse:^(NSDictionary *dic) {
        
            
        
    }];
    
}

- (void)setlableFont:(UILabel *)label bond:(NSInteger)bond{
    label.font = PingFangSC_Regular(kSuitLength_V(13));
}

- (void)toDetail{
    if (self.toDetailBlock) {
        self.toDetailBlock(self.goodsId);
    }
}
- (void)setQiangKongImage{
    
}
- (void)setProduct:(YKProduct *)product{
    _product = product;
    
    _clothingStockId = product.clothingStockId;
    _brandId = product.brandId;
     _brandName = product.brandName;
     _catId = product.catId;
     _goodsId = product.goodsId;
     _goodsName = product.goodsName;
     _goodsNo = product.goodsNo;
     _imageAttach = product.imageAttach;
     _imageDetails = product.imageDetails;
     _imageMaster = product.imageMaster;
    _clothingPrice = product.clothingPrice;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageAttach] placeholderImage:[UIImage imageNamed:@"商品图"]];
    _lable.text = _goodsName;
    _detailLabel.text = _brandName;
    _qiangkongImage.hidden = product.isHadStock;
    _shangxinImage.hidden = !product.isNew;
    
    //已抢空，不显示上新
   
    if (!product.isHadStock) {
        _shangxinImage.hidden = YES;
    }
    _imageView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    if (product.isStarSame) {//明星同款
        _shangxinImage.hidden = NO;
        _shangxinImage.image = [UIImage imageNamed:@"明星同款"];
    }
    
    
//    if ([Token length] == 0) {//未登录
//        _freeBtn.hidden = NO;
//        _des.hidden = NO;
//    }else {
//
//    //未开通会员
//    if ([[YKUserManager sharedManager].user.effective intValue] == 4) {
//        _freeBtn.hidden = NO;
//        _des.hidden = NO;
//    }else {//已是会员
//        _freeBtn.hidden = YES;
//        _des.hidden = YES;
//    }
//    }
    
    if ([product.OwenNum intValue] == 2) {
         _zhanyiweiNum.text = product.OwenNum;
    }else {
        _backView.hidden = YES;
    }
   
//    _zhanyiweiNum.text = @"2";
    
//    _backView.hidden = ([product.OwenNum intValue] == 1);
    
    if (_isInLoveVC) {
        _freeBtn.hidden = YES;
        _des.hidden = YES;
        _addSuitBtn.hidden = NO;
    }else {
        _freeBtn.hidden = NO;
        _des.hidden = NO;
        _addSuitBtn.hidden = YES;
        
        if ([Token length] == 0) {//未登录
            _freeBtn.hidden = NO;
            _des.hidden = NO;
        }else {
            
            //未开通会员
            if ([[YKUserManager sharedManager].user.effective intValue] == 4) {
                _freeBtn.hidden = NO;
                _des.hidden = NO;
            }else {//已是会员
                _freeBtn.hidden = YES;
                _des.hidden = YES;
            }
        }
    }
    
    _collectionId = product.collectionId;
    
}

- (IBAction)changeLove:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    
    if (!btn.selected) {//喜欢
        NSMutableArray *list = [NSMutableArray array];
        [list addObject:_goodsId];
        //取消喜欢
        [[YKSuitManager sharedManager]deleteCollecttwithShoppingCartId:list OnResponse:^(NSDictionary *dic) {
            if (self.changeCollectStatus) {
                self.changeCollectStatus(0);
            }
        }];
        
    }else {//未喜欢
        //喜欢
        [[YKSuitManager sharedManager]collectWithclothingId:_goodsId clothingStckType:_clothingStockId OnResponse:^(NSDictionary *dic) {
            if (self.changeCollectStatus) {
                self.changeCollectStatus(1);
            }
        }];
    }
    
    btn.selected = !btn.selected;
    
    
}

- (void)showLoveBtn:(NSString *)status{
     _loveBtn.hidden = NO;
    _loveBtn.selected = ![status intValue];
}

@end
