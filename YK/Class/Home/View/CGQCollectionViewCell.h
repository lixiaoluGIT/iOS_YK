//
//  CGQCollectionViewCell.h
//  collectionview
//
//  Created by 迟国强 on 2016/12/28.
//  Copyright © 2016年 迟国强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKProduct.h"
@interface CGQCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)YKProduct  *product;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic,copy)NSString *brandId;
@property (nonatomic,copy)NSString *brandName;
@property (nonatomic,copy)NSString *catId;
@property (nonatomic,copy)NSString *goodsId;
@property (nonatomic,copy)NSString *goodsName;
@property (nonatomic,copy)NSString *goodsNo;
@property (nonatomic,copy)NSString *imageAttach;
@property (nonatomic,copy)NSString *imageDetails;
@property (nonatomic,copy)NSString *imageMaster;
@property (nonatomic,copy)NSString *clothingPrice;
@property (nonatomic,strong)NSString *clothingStockId;
@property (nonatomic,assign)BOOL isInLoveVC;
@property (nonatomic,copy)void (^toDetailBlock)(NSString *productId);
@end
