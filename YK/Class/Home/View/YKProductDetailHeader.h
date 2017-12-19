//
//  YKProductDetailHeader.h
//  YK
//
//  Created by LXL on 2017/11/22.
//  Copyright © 2017年 YK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKProductDetail;
@interface YKProductDetailHeader : UITableViewCell


@property (nonatomic,copy)void (^toDetailBlock)(NSInteger brandId);
@property (nonatomic,copy)void (^selectBlock)(NSString *type);
@property (nonatomic,strong)NSDictionary *product;

@property (nonatomic,strong)NSDictionary *brand;
@end

@interface YKSizeView : UIView

- (void)initViewWithArray:(NSArray *)array;
@property (nonatomic,copy)void (^selectBlock)(NSString *clothingStockType);
@end
