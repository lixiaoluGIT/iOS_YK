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
    
}

@end
