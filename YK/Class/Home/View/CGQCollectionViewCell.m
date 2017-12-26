//
//  CGQCollectionViewCell.m
//  collectionview
//
//  Created by 迟国强 on 2016/12/28.
//  Copyright © 2016年 迟国强. All rights reserved.
//

#import "CGQCollectionViewCell.h"

@implementation CGQCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.contentMode   = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
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
    _lable.text = _brandName;
    _detailLabel.text = _goodsName;
}

@end
