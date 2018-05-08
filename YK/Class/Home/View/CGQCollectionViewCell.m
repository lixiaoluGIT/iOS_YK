//
//  CGQCollectionViewCell.m
//  collectionview
//
//  Created by 迟国强 on 2016/12/28.
//  Copyright © 2016年 迟国强. All rights reserved.
//

#import "CGQCollectionViewCell.h"

@interface CGQCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *tagimage;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation CGQCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.contentMode   = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _tagimage.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    _backView.hidden= _tagimage.hidden = YES;
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
    
    _backView.hidden= _tagimage.hidden = product.isHadStock;
    _imageView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];

}

@end
